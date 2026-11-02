"""Window behavior without camera or audio; run with QT_QPA_PLATFORM=offscreen."""
import os
from pathlib import Path
import sys
import subprocess
import unittest
from unittest.mock import patch

os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "score"))
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication, QWidget
from window_priority import ScorePriority, create_score_application, select_display_backend


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

    def test_monitor_index_is_not_passed_to_qt(self):
        with patch("window_priority.sys.argv", ["imol_score.py", "--display", "0", "--always-on-top"]), \
             patch("window_priority.QApplication") as application:
            create_score_application(True)
            application.assert_called_once_with(["imol_score.py"])

    def test_opencv_paths_removed_but_desktop_preserved(self):
        import cv2
        root = str(Path(cv2.__file__).resolve().parent / "qt")
        values = {"QT_QPA_PLATFORM_PLUGIN_PATH": root + "/plugins", "QT_QPA_FONTDIR": root + "/fonts",
                  "DISPLAY": ":7", "XAUTHORITY": "/tmp/session-authority", "QT_QPA_PLATFORM": "offscreen"}
        with patch.dict(os.environ, values), patch("window_priority.QApplication"):
            create_score_application(True)
            self.assertNotIn("QT_QPA_PLATFORM_PLUGIN_PATH", os.environ)
            self.assertNotIn("QT_QPA_FONTDIR", os.environ)
            self.assertEqual(os.environ["DISPLAY"], ":7")
            self.assertEqual(os.environ["XAUTHORITY"], "/tmp/session-authority")
        with patch.dict(os.environ, {"QT_QPA_PLATFORM_PLUGIN_PATH": "/opt/custom/plugins"}), \
             patch("window_priority.QApplication"):
            create_score_application(False)
            self.assertEqual(os.environ["QT_QPA_PLATFORM_PLUGIN_PATH"], "/opt/custom/plugins")

    def test_application_and_fullscreen_start_with_monitor_argument(self):
        code = '''
import sys
from pathlib import Path
sys.path.insert(0, sys.argv.pop(1))
import cv2
import os
os.environ['QT_QPA_PLATFORM_PLUGIN_PATH'] = str(Path(cv2.__file__).resolve().parent / 'qt/plugins')
from window_priority import create_score_application, ScorePriority
from PySide6.QtWidgets import QWidget
app = create_score_application(True)
assert app.arguments() == [sys.argv[0]], app.arguments()
assert os.environ['DISPLAY'] == ':7'
window = QWidget()
priority = ScorePriority(window)
window.showFullScreen()
app.processEvents()
assert window.isVisible() and window.isFullScreen()
window.close()
'''
        result = subprocess.run([sys.executable, "-c", code, str(Path(__file__).resolve().parents[1] / "score"),
                                 "--display", "0", "--always-on-top"], capture_output=True, text=True,
                                env={**os.environ, "QT_QPA_PLATFORM": "offscreen", "DISPLAY": ":7"}, timeout=20)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

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
