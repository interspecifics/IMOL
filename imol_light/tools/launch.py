#!/usr/bin/env python3
"""Run only the IMOL Light score and/or SuperCollider. Ctrl-C stops this run."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import signal
import socket
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]


def stop_message(port):
    def padded(value):
        value = value.encode() + b"\0"
        return value + b"\0" * (-len(value) % 4)
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sender:
        sender.sendto(padded("/imol/stop") + padded(","), ("127.0.0.1", port))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("both", "score", "sound"), default="both")
    parser.add_argument("--python", help="Python interpreter with requirements.txt installed")
    parser.add_argument("--sclang", help="Path to the SuperCollider language executable")
    parser.add_argument("--check", action="store_true", help="Check dependencies and paths without camera or audio")
    args, score_args = parser.parse_known_args()
    candidates = [ROOT / ".venv/bin/python", Path(sys.executable)]
    python = args.python or str(next(p for p in candidates if p.exists()))
    sclang = args.sclang or shutil.which("sclang") or "/Applications/SuperCollider.app/Contents/MacOS/sclang"
    config = (ROOT / "sound/supercollider/config.scd").read_text()
    port = int(re.search(r"oscPort:\s*(\d+)", config).group(1))
    folder_text = json.loads(re.search(r'audioFolder:\s*("[^"\n]*")', config).group(1))
    audio_folder = (ROOT / Path(folder_text).expanduser()).resolve()
    (ROOT / "runtime").mkdir(exist_ok=True)
    manifest = json.loads((ROOT / "sound/data/manifest.json").read_text())
    if args.mode != "sound":
        subprocess.run([python, "-c", "import PySide6, cv2, numpy, librosa, soundfile, pythonosc, sklearn"], check=True,
                       env={**os.environ, "MPLCONFIGDIR": str(ROOT / "runtime/matplotlib")})
    if args.mode != "score":
        if not Path(sclang).is_file():
            parser.error("SuperCollider not found. Set --sclang PATH.")
        missing = [name for name in manifest["files"] if not (audio_folder / name).is_file()]
        if missing:
            parser.error(f"Missing {len(missing)} WAV files in {audio_folder}. Run .venv/bin/python tools/prepare_audio.py first.")
    if args.check:
        print(f"OK: mode={args.mode}; Python={python}; SuperCollider={sclang}; OSC={port}; WAVs={audio_folder}")
        return
    processes = []
    sound = None
    sound_ready = False
    handles = []
    def interrupted(*_):
        raise KeyboardInterrupt
    signal.signal(signal.SIGTERM, interrupted)
    try:
        if args.mode != "score":
            # Fail before boot if another OSC receiver is already on this port.
            for required_port in (port, 57130):
                with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as probe:
                    probe.bind(("0.0.0.0", required_port))
            log_path = ROOT / "runtime/supercollider.log"
            log = log_path.open("w")
            handles.append(log)
            sound = subprocess.Popen([sclang, "-D", str(ROOT / "sound/supercollider/main.scd")],
                                     cwd=ROOT, stdout=log, stderr=subprocess.STDOUT,
                                     env={**os.environ, "IMOL_LAUNCHER": "1"}, start_new_session=True)
            processes.append(sound)
            deadline = time.monotonic() + 45
            while time.monotonic() < deadline:
                if sound.poll() is not None:
                    raise RuntimeError(f"SuperCollider stopped; see {log_path}")
                if "IMOL Light v0.1 ready." in log_path.read_text(errors="replace"):
                    sound_ready = True
                    break
                time.sleep(.2)
            if not sound_ready:
                raise RuntimeError(f"SuperCollider did not become ready; see {log_path}")
        if args.mode != "sound":
            archive = ROOT / "assets/archives"
            command = [python, str(ROOT / "score/imol_score.py"), "--osc-track-port", str(port)]
            if archive.is_dir() and not any(x.startswith("--audio-folder") for x in score_args):
                command += ["--audio-folder", str(archive)]
            processes.append(subprocess.Popen(command + score_args, cwd=ROOT,
                env={**os.environ, "MPLCONFIGDIR": str(ROOT / "runtime/matplotlib")}, start_new_session=True))
        print("IMOL Light running. Ctrl-C stops this run.", flush=True)
        while all(p.poll() is None for p in processes):
            time.sleep(.3)
    except KeyboardInterrupt:
        print("Stopping IMOL Light…")
    finally:
        if sound_ready and sound is not None and sound.poll() is None:
            stop_message(port)
            try:
                sound.wait(timeout=3)
            except subprocess.TimeoutExpired:
                pass
        # Only the process groups created by this launcher are terminated.
        for process in processes:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGTERM)
                try:
                    process.wait(timeout=3)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
        for handle in handles:
            handle.close()


if __name__ == "__main__":
    main()
