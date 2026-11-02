"""The launcher must report child failures without opening camera or audio."""
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import unittest

TOOLS = Path(__file__).resolve().parents[1] / "tools"


class LaunchExitChecks(unittest.TestCase):
    def run_score(self, body):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / "score").mkdir()
            (root / "sound/supercollider").mkdir(parents=True)
            (root / "sound/data").mkdir()
            (root / "score/imol_score.py").write_text(body)
            (root / "sound/supercollider/config.scd").write_text('oscPort: 9001, audioFolder: "assets/audio"')
            (root / "sound/data/manifest.json").write_text('{"files": []}')
            code = '''
import sys
from pathlib import Path
sys.path.insert(0, sys.argv[1])
import launch
launch.ROOT = Path(sys.argv[2])
# Skip only the dependency import check; run a real child process.
launch.subprocess.run = lambda *a, **k: None
sys.argv = ['launch.py', '--mode', 'score', '--python', sys.executable]
sys.exit(launch.main())
'''
            return subprocess.run([sys.executable, "-c", code, str(TOOLS), str(root)],
                                  capture_output=True, text=True, timeout=15)

    def test_score_error_is_propagated(self):
        result = self.run_score("import sys\nsys.exit(23)\n")
        self.assertEqual(result.returncode, 23, result.stderr)
        self.assertIn("ERROR: Score terminó con código 23", result.stderr)

    def test_signal_failure_is_not_success(self):
        result = self.run_score("import os, signal\nos.kill(os.getpid(), signal.SIGTERM)\n")
        self.assertEqual(result.returncode, 128 + signal.SIGTERM, result.stderr)

    def test_normal_window_close_remains_success(self):
        result = self.run_score("pass\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("ERROR:", result.stderr)


if __name__ == "__main__":
    unittest.main()
