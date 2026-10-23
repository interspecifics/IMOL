"""Portable audio must restore exact PCM, preserve local files and reject corruption."""
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest

import numpy as np
import soundfile as sf

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from prepare_audio import prepare


class PortableAudioTests(unittest.TestCase):
    def fixture(self, root):
        (root / "assets/samples").mkdir(parents=True)
        (root / "sound/data").mkdir(parents=True)
        pcm = np.arange(-1000, 1000, dtype=np.int16)
        flac = root / "assets/samples/test.flac"
        sf.write(flac, pcm, 48000, subtype="PCM_16")
        row = dict(wav="test.wav", flac="test.flac", frames=len(pcm), sample_rate=48000,
                   channels=1, sha256=hashlib.sha256(flac.read_bytes()).hexdigest())
        (flac.parent / "manifest.json").write_text(json.dumps({"files": [row]}))
        (root / "sound/data/manifest.json").write_text(json.dumps({"files": ["test.wav"]}))
        return pcm, flac

    def test_lossless_restore_and_preservation(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            pcm, _ = self.fixture(root)
            self.assertEqual(prepare(root), 1)
            target = root / "assets/audio/test.wav"
            decoded, rate = sf.read(target, dtype="int16")
            np.testing.assert_array_equal(pcm, decoded)
            self.assertEqual(rate, 48000)
            sf.write(target, pcm[::-1], rate, subtype="PCM_16")
            original = target.read_bytes()
            self.assertEqual(prepare(root), 0)
            self.assertEqual(target.read_bytes(), original)

    def test_corruption_stops_before_writing(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            _, flac = self.fixture(root)
            flac.write_bytes(b"broken")
            with self.assertRaises(ValueError):
                prepare(root)
            self.assertFalse((root / "assets/audio").exists())


if __name__ == "__main__":
    unittest.main()
