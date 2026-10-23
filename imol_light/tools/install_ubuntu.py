#!/usr/bin/env python3
"""Install IMOL Light on Ubuntu without changing the system Python or audio routing."""
import argparse
from datetime import datetime
import fcntl
import json
import os
from pathlib import Path
import platform
import re
import shlex
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
RELEASES = {"22.04": "jack", "24.04": "pipewire", "26.04": "pipewire"}
BASE_PACKAGES = [
    "python3", "python3-venv", "python3-pip", "supercollider",
    "libsndfile1", "ffmpeg", "v4l-utils", "libgl1", "libegl1",
    "libxkbcommon-x11-0", "libxcb-cursor0", "libxcb-icccm4",
    "libxcb-keysyms1", "libxcb-shape0", "libxcb-xinerama0",
    "libxcb-render-util0", "xwayland", "qtwayland5",
]
AUDIO_PACKAGES = {
    "pipewire": ["pipewire-jack", "pipewire-bin", "wireplumber", "qpwgraph"],
    "jack": ["jackd2", "qjackctl"],
}


def read_release(path=Path("/etc/os-release")):
    result = {}
    for line in path.read_text().splitlines():
        if "=" in line and not line.startswith("#"):
            key, value = line.split("=", 1)
            parts = shlex.split(value)
            result[key] = parts[0] if parts else ""
    return result


def validate_platform(info, system, machine):
    if system != "Linux" or info.get("ID") != "ubuntu":
        raise RuntimeError("Este instalador requiere Ubuntu; no modifica macOS ni otras distribuciones.")
    version = info.get("VERSION_ID", "")
    if version not in RELEASES:
        raise RuntimeError("Ubuntu %s no está contemplado. Usar Ubuntu Desktop 22.04, 24.04 o 26.04 LTS."
                           % (version or "desconocido"))
    if machine != "x86_64":
        raise RuntimeError("Arquitectura %s no contemplada; esta instalación requiere Intel/AMD de 64 bits."
                           % machine)
    return version


def choose_audio(version, requested, saved, jack_running):
    mode = requested if requested != "auto" else (
        saved if saved in AUDIO_PACKAGES else "jack" if jack_running else RELEASES[version])
    if mode == "pipewire" and version == "22.04":
        raise RuntimeError("La ruta PipeWire de este instalador requiere Ubuntu 24.04 o 26.04. "
                           "En 22.04 usar --audio jack; no se reemplaza PulseAudio automáticamente.")
    return mode


def linux_requirements(source):
    # Keep the shared dependency list authoritative, replacing only the Qt-less OpenCV variant.
    lines = source.splitlines()
    found = False
    for index, line in enumerate(lines):
        if re.match(r"^opencv-contrib-python(?=\s|[<>=!~;]|$)", line):
            lines[index] = line.replace("opencv-contrib-python", "opencv-contrib-python-headless", 1)
            found = True
    if not found:
        raise RuntimeError("requirements.txt no contiene la dependencia OpenCV esperada; revisar antes de instalar.")
    return "\n".join(lines) + "\n"


class Runner:
    def __init__(self, log):
        self.log = log

    def say(self, message):
        print(message, flush=True)
        self.log.write(message + "\n")
        self.log.flush()

    def run(self, command, required=True, env=None):
        command = [str(item) for item in command]
        self.say("\n> " + shlex.join(command))
        with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                              text=True, errors="replace", env=env) as process:
            for line in process.stdout:
                self.say(line.rstrip("\n"))
            code = process.wait()
        if code and required:
            raise RuntimeError("Falló el comando anterior (código %s). Corregir el error y repetir el instalador." % code)
        return code == 0


def quiet(command):
    try:
        return subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                              timeout=10).returncode == 0
    except (OSError, subprocess.TimeoutExpired):
        return False


def reusable_venv(folder):
    probe = "import json,sys,platform,pip; print(json.dumps([sys.platform,platform.machine(),sys.version_info[:2],sys.prefix]))"
    try:
        result = subprocess.run([str(folder / "bin/python"), "-I", "-c", probe],
                                capture_output=True, text=True, timeout=15, check=True)
        system, machine, version, prefix = json.loads(result.stdout)
        return (system == sys.platform and machine == platform.machine()
                and version == list(sys.version_info[:2])
                and Path(prefix).resolve() == folder.resolve())
    except (OSError, ValueError, subprocess.SubprocessError):
        return False


def prepare_venv(root, runner):
    folder = root / ".venv"
    # A symlink can point outside the project: preserve it but never install through it.
    if folder.is_symlink() or (folder.exists() and not reusable_venv(folder)):
        backup = root / (".venv.backup-" + datetime.now().strftime("%Y%m%d-%H%M%S-%f"))
        folder.rename(backup)
        runner.say("Entorno anterior conservado en: " + str(backup))
    if not folder.exists():
        runner.run([sys.executable, "-m", "venv", folder])
    return folder / "bin/python"


def install(root, version, audio, runner):
    warnings = []
    runner.say("Ubuntu %s · %s · audio %s" % (version, platform.machine(), audio))
    runner.say("Se necesitan internet y contraseña sudo para los paquetes del sistema.")
    # --no-remove makes apt stop if resolving dependencies would remove existing packages.
    apt_install = ["sudo", "apt-get", "--no-remove", "install", "-y"]
    runner.run(["sudo", "apt-get", "update"])
    runner.run(apt_install + ["software-properties-common"])
    runner.run(["sudo", "add-apt-repository", "-y", "universe"])
    runner.run(["sudo", "apt-get", "update"])
    runner.run(apt_install + BASE_PACKAGES + AUDIO_PACKAGES[audio])

    python = prepare_venv(root, runner)
    pip = [python, "-m", "pip"]
    runner.run(pip + ["install", "--upgrade", "pip"])
    requirements = root / "runtime/requirements-ubuntu.txt"
    requirements.write_text(linux_requirements((root / "requirements.txt").read_text()))
    # All OpenCV wheels share cv2. Remove conflicting variants before installing one.
    runner.run(pip + ["uninstall", "-y", "opencv-python", "opencv-contrib-python",
                      "opencv-python-headless", "opencv-contrib-python-headless"])
    runner.run(pip + ["install", "--only-binary=:all:", "-r", requirements])
    runner.run(pip + ["check"])
    runner.run([python, root / "tools/prepare_audio.py"])
    runner.run([python, "-c", "import cv2, numpy, librosa, soundfile, pythonosc, sklearn; "
                "from PySide6 import QtWidgets; print('Dependencias Python: OK')"])
    for executable in ("sclang", "scsynth", "pw-jack" if audio == "pipewire" else "jackd"):
        if not shutil.which(executable):
            raise RuntimeError("No se encontró el ejecutable instalado: " + executable)
    runner.run(["sclang", "-v"])
    (root / "runtime/ubuntu_audio_mode").write_text(audio + "\n")

    if not runner.run([python, root / "tools/launch.py", "--python", python, "--check"], required=False):
        warnings.append("La comprobación de IMOL falló: revisar arriba los WAV o archivos que faltan. "
                        "Copiarlos y repetir bash start_imol_light.sh --check.")

    graphical = bool(os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY"))
    if graphical:
        # This checks Qt's actual platform plugin without capturing video or producing sound.
        if not runner.run([python, "-c", "import cv2; from PySide6.QtWidgets import QApplication; "
                           "app = QApplication([]); print('Interfaz Qt: OK')"], required=False):
            warnings.append("Qt no pudo inicializar la interfaz. Revisar el apartado Qt de la guía Ubuntu.")
    else:
        warnings.append("No hay sesión gráfica: falta comprobar Qt desde el escritorio de Ubuntu.")

    if audio == "pipewire":
        if graphical:
            runner.run(["systemctl", "--user", "start", "pipewire", "wireplumber"], required=False)
        if not all(quiet(["systemctl", "--user", "is-active", "--quiet", service])
                   for service in ("pipewire", "wireplumber")):
            warnings.append("PipeWire/WirePlumber no están activos. Iniciar sesión en Ubuntu y revisar el paso de audio.")
        if not runner.run(["wpctl", "status"], required=False):
            warnings.append("No se pudo consultar la salida de audio. Revisar Configuración → Sonido.")
        elif not runner.run(["wpctl", "inspect", "@DEFAULT_AUDIO_SINK@"], required=False):
            warnings.append("PipeWire no tiene una salida predeterminada disponible. Elegirla en Configuración → Sonido.")
    else:
        jack_env = dict(os.environ, JACK_NO_START_SERVER="1")
        if not runner.run(["jack_lsp"], required=False, env=jack_env):
            warnings.append("JACK está instalado pero no responde. Abrir QjackCtl, seleccionar la interfaz "
                            "y arrancar JACK antes de IMOL. Consultar INSTALACION_UBUNTU_ES.txt.")

    cameras = sorted(Path("/dev").glob("video*"))
    if not cameras:
        warnings.append("No se detectó una cámara /dev/video*. Conectarla antes de arrancar.")
    elif not any(os.access(camera, os.R_OK | os.W_OK) for camera in cameras):
        warnings.append("No hay permiso de acceso a los dispositivos de cámara. Revisar la guía Ubuntu.")
    else:
        runner.run(["v4l2-ctl", "--list-devices"], required=False)
    runner.say("\nSoftware instalado. " + ("Hay comprobaciones pendientes:" if warnings else "Comprobaciones automáticas: OK."))
    for warning in warnings:
        runner.say("PENDIENTE: " + warning)
    runner.say("\nArranque: bash " + shlex.quote(str(root / "start_imol_light.sh")))
    runner.say("Falta la prueba física: elegir la salida, ver la cámara y escuchar las cuatro voces.")
    runner.say("No se ha abierto la cámara ni generado sonido durante la instalación.")
    return 2 if warnings else 0


def main(argv=None):
    parser = argparse.ArgumentParser(description="Instalar IMOL Light en Ubuntu Desktop (Intel/AMD 64 bits).")
    parser.add_argument("--audio", choices=("auto", "pipewire", "jack"), default="auto",
                        help="auto conserva la elección anterior o JACK activo; si no, usa la ruta de la versión")
    parser.add_argument("--dry-run", action="store_true", help="mostrar el plan sin instalar ni escribir archivos")
    args = parser.parse_args(argv)
    try:
        info = read_release() if Path("/etc/os-release").exists() else {}
        version = validate_platform(info, platform.system(), platform.machine())
        if os.geteuid() == 0:
            raise RuntimeError("Ejecutar como usuario normal: bash install_ubuntu.sh (sin sudo).")
        required = ("requirements.txt", "tools/launch.py", "tools/prepare_audio.py", "start_imol_light.sh",
                    "assets/samples/manifest.json",
                    "sound/supercollider/config.scd", "sound/data/manifest.json")
        for name in required:
            if not (ROOT / name).is_file():
                raise RuntimeError("La copia del proyecto está incompleta: falta " + name)
        linux_requirements((ROOT / "requirements.txt").read_text())
        saved_path = ROOT / "runtime/ubuntu_audio_mode"
        saved = saved_path.read_text().strip() if saved_path.is_file() else ""
        jack_running = quiet(["pgrep", "-u", str(os.getuid()), "-x", "jackd"])
        if not jack_running and quiet(["pgrep", "-u", str(os.getuid()), "-x", "jackdbus"]):
            jack_running = quiet(["jack_control", "status"])
        audio = choose_audio(version, args.audio, saved, jack_running)
        if args.dry_run:
            print("Ubuntu %s · %s · audio %s" % (version, platform.machine(), audio))
            print("Paquetes: " + " ".join(BASE_PACKAGES + AUDIO_PACKAGES[audio]))
            print("Se habilitará universe y se usará sudo solo para apt y add-apt-repository.")
            print("Se creará/reutilizará .venv; los entornos incompatibles se guardarán como .venv.backup-*.")
            print("Se instalarán las dependencias con OpenCV headless y se comprobarán Qt, audio, cámara y WAV.")
            print("No se ha cambiado ningún archivo ni servicio.")
            return 0
        if not shutil.which("sudo") or not shutil.which("apt-get"):
            raise RuntimeError("Se requieren sudo y apt-get en este equipo.")
        (ROOT / "runtime").mkdir(exist_ok=True)
        (ROOT / "sound/data/partials").mkdir(exist_ok=True)
        for folder in (ROOT, ROOT / "runtime", ROOT / "sound/data/partials"):
            if not os.access(folder, os.W_OK):
                raise RuntimeError("Sin permiso de escritura: " + str(folder))
        with (ROOT / "runtime/ubuntu-install.lock").open("a") as lock:
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                raise RuntimeError("Ya hay otro instalador de IMOL ejecutándose.")
            log_path = ROOT / ("runtime/ubuntu-install-" + datetime.now().strftime("%Y%m%d-%H%M%S") + ".log")
            with log_path.open("a") as log:
                runner = Runner(log)
                runner.say("Registro: " + str(log_path))
                try:
                    return install(ROOT, version, audio, runner)
                except Exception as error:
                    runner.say("ERROR: " + str(error))
                    runner.say("La instalación no terminó. Registro: " + str(log_path))
                    return 1
    except (OSError, RuntimeError, ValueError) as error:
        print("ERROR: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\nInstalación interrumpida. Se puede volver a ejecutar.", file=sys.stderr)
        sys.exit(130)
