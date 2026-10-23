"""Verify conversion semantics, fallback analysis, and complete collection coverage."""
import json
import sys
import tempfile
import unittest
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from spectral_data import audio_id, convert_analysis, fft_banks, ensure_audio_partials, sc_literal


class SpectralChecks(unittest.TestCase):
    def test_three_formats_produce_same_regions_and_partial_means(self):
        fixtures = {
            "coll": "3,0 440 0.5 0.5 460 0.5 5.5 880 1;\n",
            "partials": "3 3 0 5.5\n0 440 0.5 0.5 460 0.5 5.5 880 1\n",
            "frames": "0 1 3 440 0.5\n0.5 1 3 460 0.5\n5.5 1 3 880 1\n",
        }
        with tempfile.TemporaryDirectory() as tmp:
            results = []
            for name, text in fixtures.items():
                path = Path(tmp) / name
                path.write_text(text)
                _, banks = convert_analysis(path, 6)
                results.append(banks)
            self.assertEqual(results[0], results[1])
            self.assertEqual(results[0], results[2])
            first = results[0][0]
            self.assertEqual(first["freqs"][first["amps"].index(1)], 450)
            last = results[0][5]
            self.assertEqual(last["freqs"][last["amps"].index(1)], 880)
            self.assertEqual(max(results[0][2]["amps"]), 0)

    def test_fft_pitch_and_antiphase_stereo(self):
        sr = 48000
        sine = np.sin(2 * np.pi * 440 * np.arange(sr * 2) / sr)
        stereo = np.stack([sine, -sine], axis=1)
        banks = fft_banks(lambda start, size: stereo[start:start+size], len(stereo), sr)
        for bank in banks:
            dominant = bank["freqs"][bank["amps"].index(1)]
            self.assertAlmostEqual(dominant, 440, delta=1)
            self.assertEqual(len(bank["freqs"]), 83)
        self.assertNotIn("np.", sc_literal(banks))
        silent = fft_banks(lambda start, size: np.zeros(size), sr, sr)
        self.assertTrue(all(max(bank["amps"]) == 0 for bank in silent))

    def test_new_recording_generated_once_and_safe_identity(self):
        self.assertEqual(audio_id("Test.WAV"), audio_id("Test.mp3"))
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp)
            name = "áudio nuevo.wav"
            identifier = ensure_audio_partials(name, np.zeros(22050), 22050, output)
            self.assertRegex(identifier, r"^[a-z0-9_-]+$")
            path = output / (identifier + ".scd")
            before = path.stat().st_mtime_ns
            self.assertEqual(ensure_audio_partials(name, None, 0, output), identifier)
            self.assertEqual(before, path.stat().st_mtime_ns)
            self.assertEqual(json.loads(path.with_suffix('.json').read_text())["id"], identifier)

    def test_all_collection_files_have_valid_banks(self):
        manifest = json.loads((ROOT / "sound/data/manifest.json").read_text())
        tracks = manifest["recordings"]
        self.assertEqual({audio_id(f) for f in manifest["files"]}, {t["id"] for t in tracks})
        self.assertEqual(len(tracks), 19)
        self.assertEqual(manifest["spectralBanks"], 114)
        missing = {t["id"] for t in tracks if t["method"] == "fft-peaks"}
        self.assertEqual(missing, {"protest-in-tahrir-square-cairo", "the-value-of-noise"})
        for track in tracks:
            path = ROOT / "sound/data" / track["partials"]
            data = json.loads(path.with_suffix('.json').read_text())
            self.assertTrue(path.is_file())
            self.assertEqual(data["id"], track["id"])
            self.assertEqual(len(data["banks"]), 6)
            self.assertTrue(any(max(b["amps"]) > 0 for b in data["banks"]))
            for bank in data["banks"]:
                self.assertEqual(len(bank["freqs"]), 83)
                self.assertEqual(len(bank["amps"]), 83)
                self.assertTrue(all(np.isfinite(f) and 20 <= f <= 18000 for f in bank["freqs"]))
                self.assertTrue(all(np.isfinite(a) and 0 <= a <= 1 for a in bank["amps"]))


if __name__ == "__main__":
    unittest.main()
