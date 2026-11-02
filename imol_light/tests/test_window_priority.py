"""Window behavior without camera or audio; run with QT_QPA_PLATFORM=offscreen."""
import os
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "score"))
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication, QWidget
from window_priority import ScorePriority, select_display_backend


class WindowPriorityChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.app = QApplication.instance() or QApplication([])

    def test_fullscreen_priority_can_be_released_and_restored(self):
        window = QWidget()
        priority = ScorePriority(window)
        window.showFullScreen()
        self.assertTrue(window.windowFlags() & Qt.WindowStaysOnTopHint)
        self.assertEqual(priority.shortcut.key().toString(), "F10")
        priority.shortcut.activated.emit()
        self.assertFalse(window.windowFlags() & Qt.WindowStaysOnTopHint)
        self.assertTrue(window.isFullScreen())
        priority.shortcut.activated.emit()
        self.assertTrue(window.windowFlags() & Qt.WindowStaysOnTopHint)
        self.assertTrue(window.isFullScreen())
        window.close()

    def test_maintenance_mode_does_not_raise_window(self):
        window = QWidget()
        priority = ScorePriority(window, False)
        window.show()
        with patch.object(window, "raise_") as raise_window:
            priority.present()
            raise_window.assert_not_called()
        window.close()

    def test_score_cli_defaults_to_priority_and_supports_opt_out(self):
        from imol_score import parse_args
        self.assertTrue(parse_args([]).always_on_top)
        self.assertFalse(parse_args(["--no-always-on-top"]).always_on_top)
        self.assertTrue(parse_args(["--always-on-top"]).always_on_top)

    def test_xwayland_only_when_available_and_not_overridden(self):
        with patch("window_priority.sys.platform", "linux"), patch.dict(os.environ, {}, clear=True):
            select_display_backend(True)
            self.assertNotIn("QT_QPA_PLATFORM", os.environ)
            os.environ["DISPLAY"] = ":1"
            select_display_backend(False)
            self.assertNotIn("QT_QPA_PLATFORM", os.environ)
            select_display_backend(True)
            self.assertEqual(os.environ["QT_QPA_PLATFORM"], "xcb")
            os.environ["QT_QPA_PLATFORM"] = "wayland"
            select_display_backend(True)
            self.assertEqual(os.environ["QT_QPA_PLATFORM"], "wayland")


if __name__ == "__main__":
    unittest.main()
