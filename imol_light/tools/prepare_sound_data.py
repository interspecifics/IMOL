#!/usr/bin/env python3
"""Export Max scenes and spectral banks for every recording.

The original patches and analysis files are read, never modified. Spectral v0.1
uses amplitude-weighted mean frequencies and peak amplitudes, not trajectories.
"""
import argparse
import json
import soundfile as sf
from spectral_data import audio_id, convert_analysis, fft_banks, write_track, sc_literal
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read_presets(path):
    patch = json.loads(path.read_text())["patcher"]
    boxes = {item["box"]["id"]: item["box"] for item in patch["boxes"]}
    presets = next(b["preset_data"] for b in boxes.values() if b["maxclass"] == "preset")
    result = []
    for preset in presets:
        values, offset = {}, 0
        data = preset["data"]
        while offset < len(data):
            size = data[offset]
            if size < 5 or offset + size > len(data):
                raise ValueError(f"Invalid preset record in {path}")
            record = data[offset:offset + size]
            offset += size
            values.setdefault(record[1], {})[record[3]] = record[4:]
        result.append({"number": preset["number"], "objects": values})
    return result, boxes


def scenes(presets, granular):
    def scalar(v, key, default):
        obj = v.get(key, {})
        return next((obj[k][0] for k in ("float", "int") if k in obj), default)

    result = []
    for preset in presets:
        v = preset["objects"]
        row = {
            "sample": scalar(v, "obj-208" if granular else "obj-324", 0),
            "delay": scalar(v, "obj-197", 300) / 1000,
            "decay": scalar(v, "obj-200", 2000) / 1000,
            "wet": scalar(v, "obj-193", .4),
            "damp": scalar(v, "obj-201", .5),
        }
        if granular:
            start = sorted(v["obj-112"]["list"])
            dur = sorted(v["obj-113"]["list"])
            rate = sorted(v["obj-115"]["list"])
            row.update(startLo=start[0] / 1000, startHi=start[1] / 1000,
                       durLo=max(.005, dur[0] / 1000), durHi=max(.005, dur[1] / 1000),
                       rateLo=max(.125, rate[0]), rateHi=max(.125, rate[1]),
                       density=1000 / max(20, scalar(v, "obj-41", 185)))
        else:
            row.update(rateBase=scalar(v, "obj-24", .1),
                       rateStep=scalar(v, "obj-25", .05),
                       panBase=scalar(v, "obj-15", .2), panStep=scalar(v, "obj-17", .03))
        result.append(row)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--partials-folder", type=Path, default=ROOT / "sound/data/source_partials")
    parser.add_argument("--audio-folder", type=Path, default=ROOT / "assets/archives")
    args = parser.parse_args()
    reference = ROOT / "sound/max_reference"
    granular, boxes = read_presets(reference / "Sampler_md.maxpat")
    groove, _ = read_presets(reference / "granulStrig.maxpat")
    files = [name for name in boxes["obj-208"]["items"] if name != ","]
    tracks, banks, manifest_tracks = [], [], []
    recordings = sorted(p for p in args.audio_folder.iterdir()
                        if p.suffix.lower() in {".wav", ".aiff", ".aif", ".flac", ".ogg", ".mp3"})
    if not recordings:
        raise SystemExit("No audio recordings found")
    identifiers = [audio_id(p) for p in recordings]
    if len(set(identifiers)) != len(identifiers):
        raise SystemExit("Duplicate audio basenames; use a folder with one format per recording")
    for path in recordings:
        identifier = audio_id(path)
        candidates = [args.partials_folder / ("tan_" + path.stem + ".txt"),
                      args.partials_folder / "partials" / (path.stem + ".txt")]
        analysis = next((p for p in candidates if p.is_file()), None)
        with sf.SoundFile(str(path)) as audio:
            duration = len(audio) / audio.samplerate
            if analysis:
                method, converted = convert_analysis(analysis, duration)
                source = analysis.name
            else:
                def read(start, count):
                    audio.seek(start)
                    return audio.read(count, always_2d=True)
                converted = fft_banks(read, len(audio), audio.samplerate)
                method, source = "fft-peaks", path.name
        write_track(identifier, source, method, converted)
        indices = list(range(len(banks), len(banks) + len(converted)))
        banks.extend(converted)
        tracks.append(dict(id=identifier, bankIndices=indices))
        manifest_tracks.append(dict(id=identifier, audio=path.name, source=source, method=method,
                                    partials="partials/" + identifier + ".scd", banks=len(converted)))
        print(f"{identifier}: {method}, {len(converted)} banks", flush=True)
    output = ROOT / "sound/data"
    (output / "max_presets.json").write_text(json.dumps({"granular": granular, "groove": groove}, indent=2))
    data = {"files": files, "granular": scenes(granular, True),
            "groove": scenes(groove, False), "banks": banks, "recordings": tracks}
    (output / "sound_data.scd").write_text("// Generated by tools/prepare_sound_data.py; per-recording spectral summaries.\n" + sc_literal(data) + "\n")
    (output / "manifest.json").write_text(json.dumps({"files": files, "spectralBanks": len(banks),
        "voicesPerBank": 83, "spectralMode": "weighted mean frequency + normalized peak amplitude",
        "recordings": manifest_tracks}, indent=2))
    print(f"Exported {len(granular)} granular scenes, {len(groove)} groove scenes, {len(banks)} spectral banks.")


if __name__ == "__main__":
    main()
