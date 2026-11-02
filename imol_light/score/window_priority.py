"""Keep the exhibition score above ordinary desktop windows."""
import os
import sys

from PySide6.QtCore import QObject, QTimer, Qt
from PySide6.QtGui import QKeySequence, QShortcut


def select_display_backend(enabled):
    # GNOME Wayland does not expose the above-window hint. XWayland can apply
    # it when DISPLAY is present; never invent a display or override a chosen backend.
    if enabled and sys.platform.startswith("linux") and os.environ.get("DISPLAY"):
        os.environ.setdefault("QT_QPA_PLATFORM", "xcb")
    if enabled and sys.platform.startswith("linux"):
        if os.environ.get("QT_QPA_PLATFORM", "").startswith("wayland") or (
                os.environ.get("WAYLAND_DISPLAY") and not os.environ.get("DISPLAY")):
            print("[DISPLAY] Wayland puede ignorar la prioridad de ventana; usar X11/XWayland para la exhibición.", flush=True)


class ScorePriority(QObject):
    def __init__(self, window, enabled=True):
        super().__init__(window)
        self.window = window
        self.enabled = enabled
        window.setWindowFlag(Qt.WindowStaysOnTopHint, enabled)
        self.shortcut = QShortcut(QKeySequence("F10"), window)
        self.shortcut.setContext(Qt.WindowShortcut)
        self.shortcut.activated.connect(self.toggle)

    def present(self):
        if self.enabled and self.window.isVisible():
            self.window.raise_()
            self.window.activateWindow()

    def after_show(self):
        # Allow the initial screen placement and the audio monitor to settle.
        # No permanent focus-stealing loop: file dialogs and controls stay usable.
        for delay in (0, 1500, 4000):
            QTimer.singleShot(delay, self.present)

    def toggle(self):
        self.enabled = not self.enabled
        screen = self.window.screen()
        fullscreen = self.window.isFullScreen()
        self.window.setWindowFlag(Qt.WindowStaysOnTopHint, self.enabled)
        if screen and self.window.windowHandle():
            self.window.windowHandle().setScreen(screen)
        if fullscreen:
            self.window.showFullScreen()
        else:
            self.window.show()
        self.present()
        print("[DISPLAY] Prioridad del score: " + ("activa" if self.enabled else "libre (F10 para volver)"), flush=True)
