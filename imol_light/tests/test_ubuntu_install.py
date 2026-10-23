"""Installer routing, preservation and failure tests; no apt, camera or sound access."""
import contextlib
import io
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import install_ubuntu as installer


class FakeRunner:
    def __init__(self, fail_check=False, fail_apt=False):
        self.commands = []
        self.messages = []
        self.fail_check = fail_check
        self.fail_apt = fail_apt

    def say(self, message):
        self.messages.append(message)

    def run(self, command, required=True, env=None):
        command = [str(item) for item in command]
        self.commands.append(command)
        if self.fail_apt and "apt-get" in command:
            raise RuntimeError("apt failed")
        if "venv" in command:
            (Path(command[-1]) / "bin").mkdir(parents=True)
        return not (self.fail_check and "--check" in command)


class InstallerTests(unittest.TestCase):
    def test_release_and_architecture_gates(self):
        for release in ("22.04", "24.04", "26.04"):
            info = {"ID": "ubuntu", "VERSION_ID": release}
            self.assertEqual(installer.validate_platform(info, "Linux", "x86_64"), release)
        for info, system, arch in (
            ({}, "Darwin", "arm64"),
            ({"ID": "debian", "VERSION_ID": "24.04"}, "Linux", "x86_64"),
            ({"ID": "ubuntu", "VERSION_ID": "20.04"}, "Linux", "x86_64"),
            ({"ID": "ubuntu", "VERSION_ID": "26.10"}, "Linux", "x86_64"),
            ({"ID": "ubuntu", "VERSION_ID": "24.04"}, "Linux", "aarch64"),
        ):
            with self.assertRaises(RuntimeError):
                installer.validate_platform(info, system, arch)

    def test_audio_selection_preserves_existing_choice_and_explicit_override(self):
        choose = installer.choose_audio
        self.assertEqual(choose("22.04", "auto", "", False), "jack")
        self.assertEqual(choose("24.04", "auto", "", False), "pipewire")
        self.assertEqual(choose("26.04", "auto", "", False), "pipewire")
        self.assertEqual(choose("24.04", "auto", "", True), "jack")
        self.assertEqual(choose("24.04", "auto", "jack", False), "jack")
        self.assertEqual(choose("24.04", "pipewire", "jack", True), "pipewire")
        with self.assertRaises(RuntimeError):
            choose("22.04", "pipewire", "", False)

    def test_requirements_preserve_other_versions_and_markers(self):
        original = 'numpy==2.2.1\nopencv-contrib-python>=4.10; python_version >= "3.10"\n# note\n'
        result = installer.linux_requirements(original)
        self.assertEqual(result, original.replace("opencv-contrib-python", "opencv-contrib-python-headless"))
        with self.assertRaises(RuntimeError):
            installer.linux_requirements("numpy\n")

    def test_incompatible_venv_is_backed_up_and_compatible_one_reused(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / ".venv").mkdir()
            (root / ".venv/keep.txt").write_text("existing data")
            runner = FakeRunner()
            with patch.object(installer, "reusable_venv", return_value=False):
                python = installer.prepare_venv(root, runner)
            backups = list(root.glob(".venv.backup-*"))
            self.assertEqual(len(backups), 1)
            self.assertEqual((backups[0] / "keep.txt").read_text(), "existing data")
            self.assertEqual(python, root / ".venv/bin/python")
            runner.commands.clear()
            with patch.object(installer, "reusable_venv", return_value=True):
                installer.prepare_venv(root, runner)
            self.assertEqual(runner.commands, [])
            self.assertEqual(len(list(root.glob(".venv.backup-*"))), 1)

    def test_venv_symlink_does_not_modify_external_target(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "project"
            root.mkdir()
            external = Path(tmp) / "external"
            external.mkdir()
            (external / "keep").write_text("untouched")
            (root / ".venv").symlink_to(external, target_is_directory=True)
            installer.prepare_venv(root, FakeRunner())
            self.assertFalse((root / ".venv").is_symlink())
            self.assertEqual(list(external.iterdir()), [external / "keep"])
            self.assertTrue(next(root.glob(".venv.backup-*")).is_symlink())

    def simulate_install(self, fail_check=False, fail_apt=False, service_check=None):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "runtime").mkdir()
            (root / "requirements.txt").write_text((ROOT / "requirements.txt").read_text())
            camera = root / "video0"
            camera.touch()
            runner = FakeRunner(fail_check, fail_apt)
            with patch.object(installer, "prepare_venv", return_value=root / ".venv/bin/python"), \
                 patch.object(installer.shutil, "which", return_value="/usr/bin/example"), \
                 patch.object(installer, "quiet", return_value=True, side_effect=service_check), \
                 patch.object(Path, "glob", return_value=[camera]), \
                 patch.dict(os.environ, {"DISPLAY": ":99"}):
                result = installer.install(root, "24.04", "pipewire", runner)
            self.assertEqual((root / "runtime/ubuntu_audio_mode").read_text(), "pipewire\n")
            self.assertIn("opencv-contrib-python-headless", (root / "runtime/requirements-ubuntu.txt").read_text())
            return result, runner

    def test_successful_install_does_not_use_sudo_for_python_or_start_app(self):
        code, runner = self.simulate_install()
        self.assertEqual(code, 0)
        for command in runner.commands:
            if command[0] == "sudo":
                self.assertIn(command[1], ("apt-get", "add-apt-repository"))
            if "apt-get" in command and "install" in command:
                self.assertIn("--no-remove", command)
            if any(item.endswith("launch.py") for item in command):
                self.assertIn("--check", command)
        uninstall = next(command for command in runner.commands if "uninstall" in command)
        self.assertIn("opencv-contrib-python-headless", uninstall)

    def test_missing_project_assets_returns_pending_not_success(self):
        code, runner = self.simulate_install(fail_check=True)
        self.assertEqual(code, 2)
        self.assertTrue(any("PENDIENTE:" in message and "WAV" in message for message in runner.messages))

    def test_apt_failure_aborts_before_python_install(self):
        with self.assertRaisesRegex(RuntimeError, "apt failed"):
            self.simulate_install(fail_apt=True)

    def test_dry_run_performs_no_install_or_write(self):
        before = sorted(str(p) for p in ROOT.rglob("ubuntu-install*"))
        with patch.object(installer, "validate_platform", return_value="24.04"), \
             patch.object(installer.os, "geteuid", return_value=1000), \
             patch.object(installer, "quiet", return_value=False), \
             patch.object(installer, "install") as install, \
             contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(installer.main(["--dry-run"]), 0)
            install.assert_not_called()
        self.assertEqual(before, sorted(str(p) for p in ROOT.rglob("ubuntu-install*")))

    def test_root_rejected_before_installing(self):
        with patch.object(installer, "validate_platform", return_value="24.04"), \
             patch.object(installer.os, "geteuid", return_value=0), \
             patch.object(installer, "install") as install, \
             contextlib.redirect_stderr(io.StringIO()) as output:
            self.assertEqual(installer.main([]), 1)
            self.assertIn("sin sudo", output.getvalue())
            install.assert_not_called()

    def test_missing_one_pipewire_service_is_reported(self):
        code, runner = self.simulate_install(service_check=lambda command: command[-1] != "wireplumber")
        self.assertEqual(code, 2)
        self.assertTrue(any("PENDIENTE:" in message and "WirePlumber" in message for message in runner.messages))

    def test_runner_failure_propagates_and_logs_output(self):
        log = io.StringIO()
        with contextlib.redirect_stdout(io.StringIO()), self.assertRaises(RuntimeError):
            installer.Runner(log).run([sys.executable, "-c", "print('diagnostic'); raise SystemExit(3)"])
        self.assertIn("diagnostic", log.getvalue())

    @unittest.skipIf(os.geteuid() == 0, "launcher intentionally refuses root")
    def test_launcher_paths_with_spaces_arguments_and_check_bypass(self):
        with tempfile.TemporaryDirectory(prefix="imol test ") as tmp:
            root = Path(tmp)
            shutil.copyfile(ROOT / "start_imol_light.sh", root / "start_imol_light.sh")
            (root / ".venv/bin").mkdir(parents=True)
            (root / "runtime").mkdir()
            python = root / ".venv/bin/python"
            python.write_text('#!/bin/sh\nprintf "%s\\n" "$@"\n')
            python.chmod(0o755)
            bridge = root / "pw-jack"
            bridge.write_text('#!/bin/sh\necho PIPEWIRE\nexec "$@"\n')
            bridge.chmod(0o755)
            env = dict(os.environ, DISPLAY=":99", PATH=str(root) + os.pathsep + os.environ["PATH"])
            env.pop("IMOL_AUDIO_BACKEND", None)
            (root / "runtime/ubuntu_audio_mode").write_text("pipewire\n")
            command = ["bash", str(root / "start_imol_light.sh")]
            result = subprocess.run(command + ["--audio-folder", "/a folder/with spaces"],
                                    env=env, cwd="/", capture_output=True, text=True, check=True)
            self.assertIn("PIPEWIRE\n", result.stdout)
            self.assertIn("/a folder/with spaces\n", result.stdout)
            result = subprocess.run(command + ["--check"], env=env, capture_output=True, text=True, check=True)
            self.assertNotIn("PIPEWIRE", result.stdout)
            (root / "runtime/ubuntu_audio_mode").write_text("jack\n")
            result = subprocess.run(command, env=env, capture_output=True, text=True, check=True)
            self.assertNotIn("PIPEWIRE", result.stdout)


if __name__ == "__main__":
    unittest.main()
