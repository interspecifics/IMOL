"""Verify rendered reflection output, stereo mapping, and camera-loss fades."""
from pathlib import Path
import numpy as np
import soundfile as sf

audio, sr = sf.read(Path(__file__).resolve().parents[1] / "runtime/reflection_check.wav")
assert sr == 48000 and audio.shape[1] == 2 and 17 <= len(audio) / sr < 17.01
assert np.isfinite(audio).all() and np.max(np.abs(audio)) < .86


def rms(start, end):
    return np.sqrt(np.mean(audio[int(start * sr):int(end * sr)] ** 2, axis=0))


assert max(rms(.2, .9)) < 1e-8, "Voice audible before first detection"
left, right = rms(2, 4), rms(6, 8)
assert left[0] > max(1e-5, left[1] * 1.3), ("left pan", left)
assert right[1] > max(1e-5, right[0] * 1.3), ("right pan", right)
assert max(rms(12, 12.8)) < max(right) * .001, "OSC timeout did not fade"
assert max(rms(13.5, 14)) > 1e-5, "No recovery after fresh OSC"
assert max(rms(16, 16.8)) < max(right) * .001, "Missing detection did not fade"
print("PASS: reflection audio, stereo position, silent startup, OSC timeout, recovery and detection loss")
