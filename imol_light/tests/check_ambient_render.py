"""Check four post-effect stems, spectral retuning gaps and a quiet ending."""
from pathlib import Path
import json
import numpy as np
import soundfile as sf
from scipy.signal import welch

root = Path(__file__).resolve().parents[1] / "runtime"
audio, sr = sf.read(root / "ambient_after.wav")
assert sr == 48000 and audio.shape[1] == 12
assert 100 <= len(audio) / sr < 100.01
assert np.isfinite(audio).all()
stats = {}
for i, name in enumerate(("mix", "spectral", "granular", "groove", "reflection")):
    signal = audio[5 * sr:80 * sr, 2 * i:2 * i + 2]
    rms = float(np.sqrt(np.mean(signal ** 2)))
    peak = float(np.max(np.abs(signal)))
    freq, power = welch(signal, sr, nperseg=4096, axis=0)
    high_fraction = float(power[freq > 3000].sum() / max(power.sum(), 1e-20))
    assert rms > 1e-5, (name, "inaudible/missing signal", rms)
    assert peak < 0.2, (name, "excessive peak", peak)
    assert high_fraction < 0.02, (name, "excessive high-frequency energy", high_fraction)
    stats[name] = dict(rms=rms, peak=peak, high_frequency_fraction=high_fraction)
    print(f"PASS {name}: RMS={rms:.6f}, peak={peak:.6f}, energy above 3 kHz={high_fraction:.3%}")

# This fixture previously passed at -59.5 dBFS RMS despite being nearly inaudible.
mix_db = 20 * np.log10(stats["mix"]["rms"])
assert -40 < mix_db < -25, ("Ambient output calibration", mix_db)

# The reverb is meant to continue during retuning. Check the dry source only.
spectral = audio[:, 10:12]
for change in (20, 40, 60):
    before = np.sqrt(np.mean(spectral[(change-1)*sr:change*sr] ** 2))
    retune = spectral[int((change+1.42)*sr):int((change+1.48)*sr)]
    assert np.sqrt(np.mean(retune ** 2)) < max(1e-8, before * .03), "Retuning is exposed instead of faded"
assert np.max(np.abs(audio[98 * sr:])) < 1e-6, "Voices/tails did not stop"
(root / "ambient_metrics.json").write_text(json.dumps(stats, indent=2) + "\n")

# Constant gain only for preview listening; production levels stay unchanged.
preview = audio[:94 * sr, :2].copy()
gain = min(.025 / stats["mix"]["rms"], .7 / np.max(np.abs(preview)))
sf.write(root / "ambient_preview.wav", preview * gain, sr, subtype="PCM_24")
print(f"PASS: retuning fades and shutdown. Listening preview gain: {20*np.log10(gain):.1f} dB")
