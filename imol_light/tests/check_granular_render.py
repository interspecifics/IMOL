"""Controlled tone checks spacing, score contrast, release and bounded wet output."""
import sys
from pathlib import Path

import numpy as np
import soundfile as sf

runtime = Path(__file__).resolve().parents[1] / "runtime"
if "--prepare" in sys.argv:
    t = np.arange(48000 * 4) / 48000
    fixture = sum(np.sin(2 * np.pi * hz * t) for hz in (220, 660, 1760)) * 0.12
    sf.write(runtime / "granular_fixture.wav", fixture, 48000, subtype="FLOAT")
    sys.exit(0)

audio, sr = sf.read(runtime / "granular_check.wav")
assert audio.shape[1] == 4 and sr == 48000
assert np.isfinite(audio).all() and np.max(np.abs(audio)) < 0.85
occupancy = []
for name, start, end in (("sparse", 4, 29), ("moving", 37, 62)):
    dry = audio[start * sr:end * sr, 2:]
    wet = audio[start * sr:end * sr, :2]
    assert np.sqrt(np.mean(wet ** 2)) > 1e-5, (name, "silent wet output")
    # Quarter-second windows: dry silence is intentional breathing room.
    windows = dry.reshape(-1, sr // 4, 2)
    rms = np.sqrt(np.mean(windows ** 2, axis=(1, 2)))
    occupied = float(np.mean(rms > 0.0005))
    occupancy.append(occupied)
    print(f"{name}: active windows={occupied:.0%}, wet RMS={np.sqrt(np.mean(wet ** 2)):.6f}")
assert occupancy[0] < 0.65, ("sparse score should leave gaps", occupancy)
assert occupancy[1] > occupancy[0] + 0.15, ("score activity should be audible", occupancy)
assert np.max(np.abs(audio[67 * sr:, 2:])) < 1e-7, "Source did not release"
assert np.sqrt(np.mean(audio[71 * sr:, :2] ** 2)) < 1e-5, "Reverb did not decay"
print("PASS: finite audio, breathing room, score contrast, source release and reverb decay")
