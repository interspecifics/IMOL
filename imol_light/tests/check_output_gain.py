"""Measure the master, rather than infer audibility from moving meters."""
from pathlib import Path
import numpy as np
import soundfile as sf

audio, sr = sf.read(Path(__file__).resolve().parents[1] / "runtime/output_gain.wav")
assert sr == 48000 and audio.shape[1] == 6 and np.isfinite(audio).all()


def rms(start, stop):
    return np.sqrt(np.mean(audio[int(start*sr):int(stop*sr)] ** 2, axis=0))


steady = rms(5, 7)
gain = 10 ** (24 / 20)
assert np.allclose(steady[2:4] / steady[:2], gain, rtol=.002), steady
assert np.isclose(steady[2] / steady[3], steady[0] / steady[1], rtol=.002), "Stereo balance changed"
assert np.allclose(audio[5*sr:7*sr, 2:4], audio[5*sr:7*sr, :2] * gain,
                   rtol=.002, atol=1e-7), "Fixed gain changed the waveform"
quiet = rms(11, 11.8)
assert np.allclose(quiet[2:4] / quiet[:2], 10 ** (6 / 20), rtol=.005), quiet
peak = np.max(np.abs(audio[:, 4:6]))
assert .8 < peak <= .851, ("Output limiter", peak)
assert np.max(np.abs(audio[int(13*sr):])) < 1e-6, "Master zero must mute even with gain"
print(f"PASS: +24 dB, adjustable gain, stereo balance, limiter peak {peak:.4f}, master mute")
