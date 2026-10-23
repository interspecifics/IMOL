"""Measure actual rendered isolation and restoration, rather than only OSC commands."""
from pathlib import Path
import numpy as np
import soundfile as sf

audio, sr = sf.read(Path(__file__).resolve().parents[1] / "runtime/routing_check.wav")
assert sr == 48000 and np.isfinite(audio).all() and np.max(np.abs(audio)) < .86
frequencies = [220, 440, 880, 1760]


def amplitudes(start):
    samples = audio[int((start + .4) * sr):int((start + .9) * sr), 0]
    spectrum = np.abs(np.fft.rfft(samples * np.hanning(len(samples))))
    return np.array([spectrum[round(f * len(samples) / sr)] for f in frequencies])


for i in range(4):
    values = amplitudes(i + 1)
    assert values[i] > 1, (i, values)
    assert np.max(np.delete(values, i)) < values[i] * .001, ("leakage", i, values)
assert max(amplitudes(5)) < 1e-5, "Mute did not silence the output"
assert min(amplitudes(6)) > 1, "Unsolo did not restore every voice"
print("PASS: four separate audio paths, Solo isolation, Mute, restored mix and finite output")
