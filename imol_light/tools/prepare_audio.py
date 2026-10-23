#!/usr/bin/env python3
"""Restore the portable lossless sample bank. Existing WAV files are preserved."""
import hashlib
import json
import os
from pathlib import Path
import tempfile

import soundfile as sf

ROOT = Path(__file__).resolve().parents[1]


def prepare(root=ROOT):
    source = root / "assets/samples"
    destination = root / "assets/audio"
    rows = json.loads((source / "manifest.json").read_text())["files"]
    expected = json.loads((root / "sound/data/manifest.json").read_text())["files"]
    if sorted(row["wav"] for row in rows) != sorted(expected):
        raise ValueError("El banco portátil no coincide con las muestras del motor.")
    # Validate the whole source bank before creating any output.
    for row in rows:
        for key in ("wav", "flac"):
            if Path(row[key]).name != row[key]:
                raise ValueError("Nombre de archivo inválido en el manifiesto.")
        path = source / row["flac"]
        if hashlib.sha256(path.read_bytes()).hexdigest() != row["sha256"]:
            raise ValueError(f"Archivo incompleto o alterado: {path}")
        info = sf.info(path)
        if (info.frames, info.samplerate, info.channels, info.subtype) != (
                row["frames"], row["sample_rate"], 1, "PCM_16"):
            raise ValueError(f"Formato inesperado: {path}")
    destination.mkdir(parents=True, exist_ok=True)
    created = 0
    for row in rows:
        target = destination / row["wav"]
        if target.exists():
            info = sf.info(target)
            if info.frames < 1 or info.channels < 1:
                raise ValueError(f"WAV existente inválido: {target}")
            continue
        fd, temporary = tempfile.mkstemp(prefix=".imol-", suffix=".wav", dir=destination)
        os.close(fd)
        try:
            samples, rate = sf.read(source / row["flac"], dtype="int16", always_2d=True)
            sf.write(temporary, samples, rate, format="WAV", subtype="PCM_16")
            os.replace(temporary, target)
        finally:
            if os.path.exists(temporary):
                os.unlink(temporary)
        created += 1
    print(f"Audio preparado: {len(rows)} muestras disponibles; {created} WAV creados en {destination}")
    return created


if __name__ == "__main__":
    prepare()
