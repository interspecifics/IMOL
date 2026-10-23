"""Bounded, approximate spectral banks shared by the exporter and score.

SPEAR trajectories are reduced to six temporal regions, with up to 83 partials
per region. Missing analyses use FFT peaks; these are not tracked trajectories.
"""
import hashlib
import json
import re
from pathlib import Path

import numpy as np

DATA = Path(__file__).resolve().parents[1] / "sound/data/partials"
VERSION = 2
COUNT, VOICES = 6, 83


def audio_id(path):
    stem = Path(path).stem.lower()
    if re.fullmatch(r"[a-z0-9_-]{1,160}", stem):
        return stem
    readable = re.sub(r"[^a-z0-9_-]+", "-", stem).strip("-")[:100] or "audio"
    return readable + "-" + hashlib.sha256(stem.encode()).hexdigest()[:16]


def sc_literal(value):
    if isinstance(value, np.generic):
        value = value.item()
    if isinstance(value, dict):
        return "(" + ", ".join(f"{k}: {sc_literal(v)}" for k, v in value.items()) + ")"
    if isinstance(value, list):
        return "[" + ", ".join(map(sc_literal, value)) + "]"
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    return repr(value)


def make_bank(partials, start, end):
    partials = sorted(partials, key=lambda p: p[1], reverse=True)[:VOICES]
    partials = sorted(partials)  # Stable pitch ordering reduces arbitrary voice jumps.
    peak = max((a for _, a in partials), default=0)
    partials += [(440.0, 0.0)] * (VOICES - len(partials))
    return dict(start=round(float(start), 6), end=round(float(end), 6),
                freqs=[round(float(f), 5) for f, _ in partials],
                amps=[round(float(a / max(peak, 1e-12)), 7) for _, a in partials])


def analysis_format(path):
    with path.open() as source:
        first = next(line.strip() for line in source if line.strip())
    if "," in first:
        return "max-coll"
    return "spear-partials" if len(first.split()) == 4 else "spear-frames"


def convert_analysis(path, duration):
    """Stream all three original formats, preserving partial identity per region."""
    mode = analysis_format(path)
    regions = [{} for _ in range(COUNT)]
    width = max(duration / COUNT, 1e-6)

    def accumulate(region, identity, frequencies, amplitudes):
        weight = float(amplitudes.sum())
        if weight <= 0:
            return
        weighted = float(np.dot(frequencies, amplitudes))
        peak = float(amplitudes.max())
        old = regions[region].get(identity, (0.0, 0.0, 0.0))
        regions[region][identity] = (old[0] + weighted, old[1] + weight, max(old[2], peak))

    def trajectory(identity, values):
        if values.size % 3:
            raise ValueError(f"Incomplete trajectory in {path}")
        rows = values.reshape(-1, 3)
        rows = rows[np.isfinite(rows).all(axis=1) & (rows[:, 0] >= 0)
                    & (rows[:, 1] >= 20) & (rows[:, 1] <= 18000) & (rows[:, 2] > 0)]
        bins = np.minimum((rows[:, 0] / width).astype(int), COUNT - 1)
        for region in np.unique(bins):
            selected = rows[bins == region]
            accumulate(region, identity, selected[:, 1], selected[:, 2])

    with path.open() as source:
        lines = (line.strip() for line in source if line.strip())
        for line in lines:
            if mode == "max-coll":
                key, text = line.split(",", 1)
                trajectory(int(key), np.fromstring(text.rstrip("; "), sep=" "))
            elif mode == "spear-partials":
                header = line.split()
                if len(header) != 4:
                    raise ValueError(f"Invalid partial header in {path}")
                expected = int(header[1]) * 3
                values = np.fromstring(next(lines), sep=" ")
                if values.size != expected:
                    raise ValueError(f"Wrong point count in {path}: {header[0]}")
                trajectory(int(header[0]), values)
            else:
                values = np.fromstring(line, sep=" ")
                if values.size < 2 or values.size != 2 + 3 * int(values[1]):
                    raise ValueError(f"Invalid frame in {path}")
                region = min(COUNT - 1, max(0, int(values[0] / width)))
                rows = values[2:].reshape(-1, 3)
                rows = rows[np.isfinite(rows).all(axis=1) & (rows[:, 1] >= 20)
                            & (rows[:, 1] <= 18000) & (rows[:, 2] > 0)]
                dest = regions[region]
                for identity, frequency, amplitude in rows:
                    old = dest.get(int(identity), (0.0, 0.0, 0.0))
                    dest[int(identity)] = (old[0] + frequency * amplitude,
                                           old[1] + amplitude, max(old[2], amplitude))
    banks = [make_bank([(f / weight, peak) for f, weight, peak in region.values()],
                       i * width, (i + 1) * width) for i, region in enumerate(regions)]
    return mode, banks


def fft_banks(read_segment, frames, sample_rate):
    """Six one-second snapshots spanning the whole recording, channel-power averaged."""
    if frames <= 0 or sample_rate <= 0:
        raise ValueError("Cannot derive partials from an empty recording")
    nfft = 8192
    duration = frames / sample_rate
    window = np.hanning(nfft)
    segment_size = min(frames, int(sample_rate))
    banks = []
    for start in np.linspace(0, max(0, frames - segment_size), COUNT).astype(int):
        samples = np.asarray(read_segment(int(start), segment_size), dtype=float)
        if samples.ndim == 1:
            samples = samples[:, None]
        samples = np.nan_to_num(samples)
        if len(samples) < nfft:
            samples = np.pad(samples, ((0, nfft - len(samples)), (0, 0)))
        power = np.zeros(nfft // 2 + 1)
        windows = 0
        for offset in range(0, len(samples) - nfft + 1, nfft // 4):
            spectrum = np.fft.rfft(samples[offset:offset+nfft] * window[:, None], axis=0)
            power += np.mean(np.abs(spectrum) ** 2, axis=1)
            windows += 1
        magnitude = np.sqrt(power / max(1, windows))
        peaks = np.where((magnitude[1:-1] > magnitude[:-2])
                         & (magnitude[1:-1] >= magnitude[2:]))[0] + 1
        peaks = peaks[(peaks * sample_rate / nfft >= 20)
                      & (peaks * sample_rate / nfft <= min(18000, sample_rate / 2))
                      & (magnitude[peaks] > magnitude.max() * .001)]
        partials = []
        for k in peaks:
            left, center, right = np.log(np.maximum(magnitude[k-1:k+2], 1e-12))
            denom = left - 2 * center + right
            delta = np.clip(.5 * (left - right) / denom, -.5, .5) if denom else 0
            frequency = (k + delta) * sample_rate / nfft
            if 20 <= frequency <= min(18000, sample_rate / 2):
                partials.append((frequency, magnitude[k]))
        banks.append(make_bank(partials, start / sample_rate,
                               min(duration, (start + segment_size) / sample_rate)))
    return banks


def write_track(identifier, source, method, banks, output=DATA):
    output.mkdir(parents=True, exist_ok=True)
    track = dict(version=VERSION, id=identifier, source=source, method=method, banks=banks)
    # Replace complete files so a running receiver cannot read a half-written bank.
    for suffix, text in ((".json", json.dumps(track, indent=2)), (".scd", sc_literal(track) + "\n")):
        target = output / (identifier + suffix)
        temporary = target.with_suffix(suffix + ".tmp")
        temporary.write_text(text, encoding="utf-8")
        temporary.replace(target)
    return track


def ensure_audio_partials(path, samples, sample_rate, output=DATA):
    """Use a prepared bank, or derive one for a new audio loaded by the score."""
    identifier = audio_id(path)
    if not (output / (identifier + ".scd")).is_file():
        banks = fft_banks(lambda start, count: samples[start:start+count], len(samples), sample_rate)
        write_track(identifier, Path(path).name, "fft-peaks-score", banks, output)
        print(f"[PARTIALS] Generated FFT banks for {Path(path).name}")
    return identifier
