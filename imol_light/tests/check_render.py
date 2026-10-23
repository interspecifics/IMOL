"""Inspect the offline SC render for finite, non-silent output in each layer."""
from pathlib import Path
import numpy as np
import soundfile as sf

path = Path(__file__).resolve().parents[1] / "runtime/sound_check.wav"
audio, sample_rate = sf.read(path)
assert audio.ndim == 2 and audio.shape[1] == 2
assert sample_rate == 48000 and 25 <= len(audio) / sample_rate < 25.01
assert np.isfinite(audio).all()
for name, start, end in (("spectral", 1, 3), ("granular", 7, 15), ("groove", 21, 23)):
    segment = audio[int(start * sample_rate):int(end * sample_rate)]
    rms = float(np.sqrt(np.mean(segment ** 2)))
    peak = float(np.max(np.abs(segment)))
    assert rms > 1e-5, (name, "silent", rms)
    assert peak < .86, (name, "excessive peak", peak)
    print(f"PASS {name}: RMS={rms:.6f}, peak={peak:.6f}")
