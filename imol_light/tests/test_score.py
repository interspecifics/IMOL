"""Headless score checks. No camera and no lighting hardware are opened."""
import ast
import os
import sys
import tempfile
import unittest
from unittest.mock import patch
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
os.environ.setdefault("MPLCONFIGDIR", str(ROOT / "runtime/matplotlib"))
sys.path.insert(0, str(ROOT / "score"))
import imol_score as score
from PySide6.QtWidgets import QApplication
import numpy as np


class Capture:
    def __init__(self):
        self.messages = []

    def send_message(self, address, payload):
        self.messages.append((address, payload))

    def send_bundle(self, messages):
        self.messages.extend(messages)


class ScoreChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.app = QApplication.instance() or QApplication([])

    def test_no_lighting_transport_or_memory(self):
        tree = ast.parse((ROOT / "score/imol_score.py").read_text())
        constants = [n.value for n in ast.walk(tree) if isinstance(n, ast.Constant)]
        for forbidden in ("/pattern", "/set", "set_state_memory.json", 9000):
            self.assertNotIn(forbidden, constants)
        args = score.parse_args([])
        self.assertEqual(args.osc_track_port, 9001)
        self.assertFalse(hasattr(args, "osc_out_port"))
        self.assertTrue(str(args.cv_state_model).startswith(str(ROOT / "runtime")))

    def test_camera_states_send_without_feature_playback(self):
        viewer = score.AudioViewerWidget(640, 360)
        capture = Capture()
        viewer.set_osc(True, client_track=capture)
        viewer.monitor_button.click()
        self.assertIn(("/imol/monitor", []), capture.messages)
        viewer.update_cv_state(6, .5)
        viewer._send_cv_states_continuously()
        self.assertFalse(viewer.is_playing)
        addresses = [a for a, _ in capture.messages]
        self.assertIn("/system/state", addresses)
        self.assertIn("/system/stateB", addresses)
        self.assertIn("/state/6", addresses)
        count = len(capture.messages)
        viewer.set_osc(False, client_track=capture)
        self.assertFalse(viewer.monitor_button.isEnabled())
        viewer._send_cv_states_continuously()
        self.assertEqual(len(capture.messages), count)
        viewer.cv_state_sender_timer.stop()
        viewer.play_timer.stop()
        viewer.close()

    def test_audio_selection_success_failure_and_paused_heartbeat(self):
        viewer = score.AudioViewerWidget(640, 360)
        capture = Capture()
        viewer.set_osc(True, client_track=capture)
        viewer.autoplay_cb.setChecked(False)
        try:
            path = Path("a-protest-in-bogota-colombia.mp3")
            with patch.object(score.librosa, "load", return_value=(np.zeros(22050), 22050)), \
                    patch.object(viewer, "_extract_features"), patch.object(viewer, "update_display"), \
                    patch.object(score, "ensure_audio_partials", return_value=path.stem) as prepare:
                viewer._load_audio_file(path)
                prepare.assert_called_once()
            selection = [v for a, v in capture.messages if a == "/score/audio"]
            self.assertEqual(selection, ["", path.stem])
            self.assertEqual(viewer.current_file, path)
            self.assertFalse(viewer.is_playing)
            capture.messages.clear()
            viewer._osc_audio_last_sent = float("-inf")
            viewer._send_cv_states_continuously()
            self.assertIn(("/score/audio", path.stem), capture.messages)
            # Failure clears selection and never announces the failed filename.
            capture.messages.clear()
            with patch.object(score.librosa, "load", side_effect=ValueError("bad audio")):
                viewer._load_audio_file(Path("unreadable.wav"))
            self.assertEqual([v for a, v in capture.messages if a == "/score/audio"], [""])
            self.assertEqual(viewer._osc_audio_id, "")
            self.assertIsNone(viewer.current_file)
        finally:
            viewer.cv_state_sender_timer.stop()
            viewer.play_timer.stop()
            viewer.close()

    def test_tracker_contract_and_no_camera_open(self):
        with tempfile.TemporaryDirectory() as tmp:
            args = score.parse_args(["--cv-state-use-rules", "--cv-state-model", str(Path(tmp) / "model.json")])
            capture = Capture()
            worker = score.CvScoreWorker(args=args, panel_width=320, cv_display_height=180,
                                         score_height=100, osc_track_sender=capture)
            detections = [dict(bbox=(i * 10, 10, 40-i, 30-i), area=1000-i,
                               center=(i * 10 + 20, 25)) for i in range(6)]
            worker._maybe_send_cv_tracks(detections, 320, 180)
            self.assertIsNone(worker._cap)
            tracks = [(a, p) for a, p in capture.messages if a.startswith("/track/")]
            self.assertEqual([a for a, _ in tracks], ["/track/A", "/track/B", "/track/C", "/track/E"])
            self.assertEqual(tracks[-1][1][0], 4)
            for _, values in tracks:
                self.assertEqual(len(values), 8)
                self.assertTrue(all(np.isfinite(values)))
                self.assertTrue(all(0 <= x <= 1 for x in values[1:6]))

    def test_reflection_five_values_motion_heartbeat_and_loss(self):
        with tempfile.TemporaryDirectory() as tmp:
            args = score.parse_args(["--cv-state-use-rules", "--cv-state-model", str(Path(tmp) / "model.json")])
            capture = Capture()
            worker = score.CvScoreWorker(args=args, panel_width=320, cv_display_height=180,
                                         score_height=100, osc_track_sender=capture)
            region = dict(bbox=(40, 25, 40, 40), area=1600, center=(80, 45), intensity=204)
            smaller = dict(bbox=(1, 1, 10, 10), area=100, center=(5, 5), intensity=255)
            with patch.object(score.time, "monotonic", side_effect=[10, 10.2, 10.4, 10.6, 10.8, 11]):
                worker._maybe_send_cv_tracks([smaller, region], 320, 180)
                worker._maybe_send_cv_tracks([region], 320, 180)  # stationary heartbeat
                moved = dict(region, center=(112, 45), intensity=153)
                worker._maybe_send_cv_tracks([moved], 320, 180)
                worker._maybe_send_cv_tracks([], 320, 180)  # also when send_empty=False
                worker._maybe_send_cv_tracks([moved], 320, 180)
                worker._maybe_send_cv_tracks([dict(region, intensity=float("nan"))], 320, 180)
            values = [p for a, p in capture.messages if a == "/reflection/1"]
            self.assertEqual(len(values), 6)
            np.testing.assert_allclose(values[0], [.25, .75, .8, np.sqrt(1600 / (320 * 180)), 0])
            np.testing.assert_allclose(values[1], values[0])
            self.assertAlmostEqual(values[2][4], .5)  # normalized widths per second
            self.assertAlmostEqual(values[2][2], .6)
            self.assertEqual(values[3][3], 0)
            self.assertEqual(values[4][4], 0)  # no velocity spike on reacquisition
            self.assertEqual(values[5][3], 0)  # non-finite data is never sent

    def test_window_builds_without_controller(self):
        args = score.parse_args(["--window-width", "960", "--window-height", "640", "--top-panel-height", "360"])
        args.osc_out_enable = False
        original = score.IMOLGraphicScoreWindow._start_worker
        score.IMOLGraphicScoreWindow._start_worker = lambda self: None
        try:
            window = score.IMOLGraphicScoreWindow(args)
            self.assertIsNone(window.osc_track_client)
            self.assertFalse(hasattr(window, "osc_client"))
            window.audio_viewer.cv_state_sender_timer.stop()
            window.audio_viewer.play_timer.stop()
            window.close()
        finally:
            score.IMOLGraphicScoreWindow._start_worker = original


if __name__ == "__main__":
    unittest.main()
