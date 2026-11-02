"""Autostart lifecycle checks without opening camera, desktop or audio."""
import fcntl
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from unittest.mock import Mock, patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import autostart_ubuntu as startup


class AutostartChecks(unittest.TestCase):
    def test_install_is_idempotent_and_uses_actual_checkout(self):
        with tempfile.TemporaryDirectory(prefix="imol space ") as folder:
            root = Path(folder)
            path = root / "config/autostart/imol-light.desktop"
            with patch.object(startup.subprocess, "run") as check:
                startup.install(root, path, 1)
                startup.install(root, path, 0)
            self.assertEqual(len(list(path.parent.iterdir())), 1)
            self.assertIn(startup.desktop_argument(root / "tools/autostart_ubuntu.py"), path.read_text())
            self.assertIn('"--run" "--display" "0"', path.read_text())
            self.assertIn("Terminal=false", path.read_text())
            self.assertIn("--check", check.call_args.args[0])

    def test_failed_preflight_preserves_existing_entry(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "imol-light.desktop"
            path.write_text("previous entry")
            with patch.object(startup.subprocess, "run", side_effect=subprocess.CalledProcessError(1, "check")):
                with self.assertRaises(subprocess.CalledProcessError):
                    startup.install(Path(folder), path, 0)
            self.assertEqual(path.read_text(), "previous entry")

    def test_desktop_escaping(self):
        value = '/tmp/a b/"$`\\100%'
        encoded = startup.desktop_argument(value)
        # Undo the general desktop string escapes, then Exec argument quoting.
        general = encoded.replace("\\\\", "\\")
        import shlex
        decoded = shlex.split(general)[0].replace("\\$", "$").replace("\\`", "`").replace("%%", "%")
        self.assertEqual(decoded, value)
        with self.assertRaises(ValueError):
            startup.desktop_argument("path\nExec=another")

    def test_configuration_home(self):
        with patch.dict(os.environ, {"XDG_CONFIG_HOME": "/tmp/imol-config"}):
            self.assertEqual(startup.entry_path(), Path("/tmp/imol-config/autostart/imol-light.desktop"))
        with patch.dict(os.environ, {"XDG_CONFIG_HOME": "relative"}):
            with self.assertRaises(ValueError):
                startup.entry_path()

    def test_audio_backend_saved_and_overridden(self):
        with tempfile.TemporaryDirectory() as folder, patch.dict(os.environ, {"IMOL_AUDIO_BACKEND": ""}):
            root = Path(folder)
            (root / "runtime").mkdir()
            self.assertEqual(startup.audio_commands(root)[0], "pipewire")
            (root / "runtime/ubuntu_audio_mode").write_text("jack\n")
            self.assertEqual(startup.audio_commands(root), ("jack", [["jack_lsp"]]))
            with patch.dict(os.environ, {"IMOL_AUDIO_BACKEND": "pipewire"}):
                self.assertEqual(startup.audio_commands(root)[0], "pipewire")

    def test_waits_for_audio_and_never_starts_jack_server(self):
        stopped = Mock()
        stopped.is_set.return_value = False
        with patch.object(startup, "audio_commands", return_value=("jack", [["jack_lsp"]])), \
             patch.object(startup.shutil, "which", return_value="/usr/bin/jack_lsp"), \
             patch.object(startup.subprocess, "run", side_effect=[Mock(returncode=1), Mock(returncode=0)]) as run:
            self.assertTrue(startup.wait_for_audio(Path("/tmp"), stopped))
            stopped.wait.assert_called_once_with(2)
            self.assertEqual(run.call_args.kwargs["env"]["JACK_NO_START_SERVER"], "1")

    def test_unavailable_audio_times_out_without_launch(self):
        with patch.object(startup, "audio_commands", return_value=("jack", [["jack_lsp"]])), \
             patch.object(startup.shutil, "which", return_value="/usr/bin/jack_lsp"):
            with self.assertRaisesRegex(RuntimeError, "no está disponible"):
                startup.wait_for_audio(Path("/tmp"), threading.Event(), timeout=0)

    def test_duplicate_does_not_launch_or_truncate_log(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            runtime = root / "runtime"
            runtime.mkdir()
            (runtime / "autostart.log").write_text("current session")
            with (runtime / "autostart.lock").open("a") as lock, patch.object(startup, "supervise") as run:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
                self.assertEqual(startup.run_session(root, 0), 0)
                run.assert_not_called()
            self.assertEqual((runtime / "autostart.log").read_text(), "current session")

    def test_no_desktop_fails_without_starting_process(self):
        with patch.dict(os.environ, {"DISPLAY": "", "WAYLAND_DISPLAY": ""}), \
             patch.object(startup.subprocess, "Popen") as spawn:
            self.assertEqual(startup.supervise(Path("/tmp"), 0), 1)
            spawn.assert_not_called()

    def test_logout_signal_stops_only_launched_session(self):
        handlers = {}
        child = Mock()
        child.returncode = None
        child.poll.return_value = None

        def start(*args, **kwargs):
            handlers[signal.SIGTERM](signal.SIGTERM, None)
            return child

        with patch.dict(os.environ, {"DISPLAY": ":99"}), \
             patch.object(startup, "wait_for_audio", return_value=True), \
             patch.object(startup.signal, "signal", side_effect=lambda s, h: handlers.setdefault(s, h)), \
             patch.object(startup.subprocess, "Popen", side_effect=start) as spawn, \
             patch.object(startup.threading.Event, "wait", autospec=True, side_effect=lambda event, timeout: event.is_set()):
            self.assertEqual(startup.supervise(Path("/tmp/project with spaces"), 1), 0)
            child.terminate.assert_called_once()
            child.wait.assert_called_once_with(timeout=20)
            command = spawn.call_args.args[0]
            self.assertEqual(command[-3:], ["--display", "1", "--always-on-top"])
            self.assertTrue(spawn.call_args.kwargs["start_new_session"])

    def test_real_wrapper_logs_and_forwards_termination(self):
        with tempfile.TemporaryDirectory(prefix="imol lifecycle ") as folder:
            root = Path(folder)
            runtime = root / "runtime"
            runtime.mkdir()
            (runtime / "autostart.log").write_text("previous run")
            (root / "fake.py").write_text(
                "import signal, sys, time\nfrom pathlib import Path\n"
                "def stop(*args):\n"
                "    Path('stopped').write_text('closed')\n"
                "    print('child stopped', flush=True)\n"
                "    sys.exit(0)\n"
                "signal.signal(signal.SIGTERM, stop)\n"
                "print('score diagnostic', file=sys.stderr, flush=True)\n"
                "Path('started').write_text('ready')\n"
                "while True: time.sleep(.05)\n")
            import shlex
            (root / "start_imol_light.sh").write_text(
                "#!/bin/bash\nexec " + shlex.quote(sys.executable) + " fake.py\n")
            script = (
                "import sys\nfrom pathlib import Path\n"
                "sys.path.insert(0, sys.argv[1])\nimport autostart_ubuntu as a\n"
                "a.wait_for_audio = lambda *args: True\n"
                "sys.exit(a.run_session(Path(sys.argv[2]), 0))\n")
            worker = subprocess.Popen([sys.executable, "-c", script, str(Path(startup.__file__).parent), str(root)],
                                      env={**os.environ, "DISPLAY": ":99"})
            try:
                deadline = time.monotonic() + 12
                while not (root / "started").exists() and time.monotonic() < deadline and worker.poll() is None:
                    time.sleep(.05)
                self.assertTrue((root / "started").exists(), (runtime / "autostart.log").read_text())
                worker.terminate()
                self.assertEqual(worker.wait(timeout=5), 0)
                self.assertTrue((root / "stopped").exists())
                self.assertEqual((runtime / "autostart.previous.log").read_text(), "previous run")
                self.assertIn("score diagnostic", (runtime / "autostart.log").read_text())
                self.assertIn("child stopped", (runtime / "autostart.log").read_text())
            finally:
                if worker.poll() is None:
                    worker.terminate()
                    worker.wait(timeout=25)


if __name__ == "__main__":
    unittest.main()
