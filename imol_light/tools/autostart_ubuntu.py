#!/usr/bin/env python3
"""Install or run IMOL Light at Ubuntu graphical login, without sudo."""
import argparse
from datetime import datetime
import fcntl
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import threading
import time

ROOT = Path(__file__).resolve().parents[1]
ENTRY = "imol-light.desktop"


def desktop_argument(value):
    value = str(value)
    if any(char in value for char in "\n\r\t"):
        raise ValueError("La ruta no puede contener saltos de línea ni tabuladores.")
    # Exec quoting followed by the desktop entry's general string escaping.
    value = "".join("\\" + c if c in '\\"`$' else c for c in value)
    return '"' + value.replace("\\", "\\\\").replace("%", "%%") + '"'


def desktop_entry(root, display):
    command = ["/usr/bin/python3", root / "tools/autostart_ubuntu.py", "--run", "--display", str(display)]
    return ("[Desktop Entry]\nType=Application\nVersion=1.0\nName=IMOL Light\n"
            "Comment=Score, cámara y sonido\nTerminal=false\nStartupNotify=false\n"
            "X-GNOME-Autostart-enabled=true\nExec="
            + " ".join(desktop_argument(arg) for arg in command) + "\n")


def entry_path():
    configured = os.environ.get("XDG_CONFIG_HOME", "")
    folder = Path(configured) if configured else Path.home() / ".config"
    if not folder.is_absolute():
        raise ValueError("XDG_CONFIG_HOME debe ser una ruta absoluta.")
    return folder / "autostart" / ENTRY


def install(root, path, display):
    # Complete the checks before replacing an existing autostart entry.
    subprocess.run(["/bin/bash", str(root / "start_imol_light.sh"), "--check"],
                   cwd=root, check=True, timeout=120)
    content = desktop_entry(root, display)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(".desktop.tmp")
    temporary.write_text(content, encoding="utf-8")
    temporary.replace(path)
    print(f"Inicio automático instalado: {path}")
    print("Se iniciará en el próximo acceso al escritorio. No hace falta sudo.")


def audio_commands(root):
    backend = os.environ.get("IMOL_AUDIO_BACKEND", "").strip()
    saved = root / "runtime/ubuntu_audio_mode"
    if not backend and saved.is_file():
        backend = saved.read_text().strip()
    backend = backend or "pipewire"
    if backend == "pipewire":
        return backend, [["pw-cli", "info", "0"], ["wpctl", "status"]]
    if backend == "jack":
        return backend, [["jack_lsp"]]
    raise ValueError("IMOL_AUDIO_BACKEND debe ser pipewire o jack.")


def wait_for_audio(root, stopped, timeout=90):
    backend, commands = audio_commands(root)
    for command in commands:
        if not shutil.which(command[0]):
            raise RuntimeError(f"Falta {command[0]}. Ejecutar bash install_ubuntu.sh.")
    print(f"Esperando audio {backend} (máximo {timeout} segundos)…", flush=True)
    deadline = time.monotonic() + timeout
    while not stopped.is_set() and time.monotonic() < deadline:
        ready = True
        for command in commands:
            try:
                result = subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                                        env={**os.environ, "JACK_NO_START_SERVER": "1"}, timeout=3)
                ready = ready and result.returncode == 0
            except subprocess.TimeoutExpired:
                ready = False
        if ready and not stopped.is_set():
            return True
        stopped.wait(2)
    if stopped.is_set():
        return False
    raise RuntimeError(f"El audio {backend} no está disponible. Revisar los servicios de audio; "
                       "si se usa JACK, configurar su inicio en QjackCtl.")


def run_session(root, display):
    runtime = root / "runtime"
    runtime.mkdir(exist_ok=True)
    # Keep the descriptor open for the entire session. Never unlink a held lock.
    with (runtime / "autostart.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            print("El inicio automático de IMOL ya está activo.")
            return 0
        log_path = runtime / "autostart.log"
        if log_path.exists():
            log_path.replace(runtime / "autostart.previous.log")
        with log_path.open("w", buffering=1) as log:
            # The score inherits these descriptors, including its error messages.
            sys.stdout.flush()
            sys.stderr.flush()
            saved_fds = [os.dup(1), os.dup(2)]
            try:
                os.dup2(log.fileno(), 1)
                os.dup2(log.fileno(), 2)
                return supervise(root, display)
            finally:
                sys.stdout.flush()
                sys.stderr.flush()
                for target, saved in zip((1, 2), saved_fds):
                    os.dup2(saved, target)
                    os.close(saved)


def supervise(root, display):
    print(f"{datetime.now().isoformat(timespec='seconds')} — IMOL Light: inicio de sesión", flush=True)
    stopped = threading.Event()
    previous = {}
    child = None
    for sig in (signal.SIGTERM, signal.SIGINT):
        previous[sig] = signal.signal(sig, lambda *_: stopped.set())
    try:
        if not (os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY")):
            raise RuntimeError("No hay sesión gráfica. Iniciar desde el escritorio de Ubuntu.")
        if not wait_for_audio(root, stopped):
            return 0
        if stopped.wait(5):
            return 0
        command = ["/bin/bash", str(root / "start_imol_light.sh"), "--display", str(display), "--always-on-top"]
        child = subprocess.Popen(command, cwd=root, start_new_session=True,
                                 env={**os.environ, "PYTHONUNBUFFERED": "1"})
        print(f"Iniciando score prioritario, cámara y SuperCollider; pantalla {display}.", flush=True)
        while child.poll() is None and not stopped.wait(.5):
            pass
        if not stopped.is_set():
            print(f"Sesión terminada (código {child.returncode}). Ver también runtime/supercollider.log.", flush=True)
        return child.returncode or 0
    except (OSError, ValueError, RuntimeError) as error:
        print(f"ERROR: {error}", file=sys.stderr, flush=True)
        return 1
    finally:
        if child is not None and child.poll() is None:
            # The launcher shuts down only its own score and sound processes.
            child.terminate()
            try:
                child.wait(timeout=20)
            except subprocess.TimeoutExpired:
                print("El cierre no respondió. Revisar runtime/supercollider.log.", file=sys.stderr, flush=True)
        for sig, handler in previous.items():
            signal.signal(sig, handler)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group()
    action.add_argument("--run", action="store_true", help="Probar el inicio ahora (desde el escritorio)")
    action.add_argument("--remove", action="store_true", help="Desactivar el inicio automático")
    action.add_argument("--status", action="store_true", help="Mostrar la configuración instalada")
    parser.add_argument("--display", type=int, default=0, help="Pantalla del score (0 por defecto; -1 = mayor)")
    args = parser.parse_args()
    if not sys.platform.startswith("linux"):
        parser.error("Este instalador es para Ubuntu Desktop.")
    if os.geteuid() == 0:
        parser.error("Ejecutar con la cuenta del escritorio, sin sudo.")
    if args.display < -1:
        parser.error("La pantalla debe ser -1 o un número mayor o igual a cero.")
    try:
        if args.run:
            return run_session(ROOT, args.display)
        path = entry_path()
        if args.remove:
            path.unlink(missing_ok=True)
            print("Inicio automático desactivado. La sesión actual continúa hasta cerrar el score.")
        elif args.status:
            print(path.read_text() if path.exists() else "Inicio automático no instalado.")
        else:
            install(ROOT, path, args.display)
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
