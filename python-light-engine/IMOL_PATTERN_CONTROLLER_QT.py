"""
IMOL_PATTERN_CONTROLLER_QT
--------------------------

Qt-based controller for An Instrument Made of Light.


Status:
- First iteration: layout + core wiring for universe, fixture addresses,
  per-channel controls, patterns and pattern sets.
- Behaviour model (min/max/ctl/mode/rate) and DMX tick loop are compatible
  with the Tk controller.
"""

from __future__ import annotations

import math
import os
import random
import sys
import time
import threading
import subprocess
import webbrowser
import json
from pathlib import Path
from collections import deque
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple, Any

import cv2
import numpy as np
import yaml
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import ThreadingOSCUDPServer
from ola.ClientWrapper import ClientWrapper
from ola.OlaClient import OLADNotRunningException
from PySide6.QtCore import Qt, QTimer, Signal, QObject, QThread, Slot
from PySide6.QtGui import QPalette, QColor, QImage, QPixmap
from PySide6.QtWidgets import (
    QApplication,
    QButtonGroup,
    QCheckBox,
    QComboBox,
    QGridLayout,
    QGroupBox,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QMainWindow,
    QMessageBox,
    QPushButton,
    QSlider,
    QSpinBox,
    QDoubleSpinBox,
    QScrollArea,
    QSplitter,
    QSizePolicy,
    QVBoxLayout,
    QWidget,
)

from main import DmxByteArray, _start_olad_if_needed
from camera_roles import DEFAULT_ROLES_PATH, dhash_hex_from_bgr, probe_best_index_for_role, save_role


BASE_DIR = Path(__file__).resolve().parent
FIXTURES_FILE = str(BASE_DIR / "fixtures.yml")
MOVING_HEAD_KEY = "moving_head_14ch"
HERO_KEY = "varytec_hero_mirror_8ch"
MBM_KEY = "mbm40d_mirror_motor_1ch"
FOG_KEY = "af150_fog_1ch"
MOVING_HEAD_COUNT = 4
HERO_COUNT = 2
MBM_COUNT = 2
FOG_COUNT = 1
FIXTURE_COUNT = MOVING_HEAD_COUNT + HERO_COUNT + MBM_COUNT + FOG_COUNT
# Patterns/sets only control fixtures 1-8 (not fog).
PATTERN_FIXTURE_COUNT = MOVING_HEAD_COUNT + HERO_COUNT + MBM_COUNT
DEFAULT_OSC_PORT = 9000
PATTERN_SETS_FILE = str(BASE_DIR / "pattern_sets.json")
DEFAULT_PATTERN_SLOTS = 7
MOTOR_HOMING_FILE = str(BASE_DIR / "motor_homing.json")
FOG_TIMER_FILE = str(BASE_DIR / "fog_timer_config.json")


class MotorCamWorker(QObject):
    """
    Background camera capture worker for the Pattern Controller.
    Shows a second camera feed used to align/zero the continuous-rotation motors.
    """

    frame_ready = Signal(object)  # QImage
    status = Signal(str)
    metrics_ready = Signal(object)  # dict with per-motor detection

    def __init__(self, *, camera_index: int, width: int, height: int, fps: float = 15.0):
        super().__init__()
        self.camera_index = int(camera_index)
        self.width = int(width)
        self.height = int(height)
        self.fps = float(max(1.0, fps))
        self._cap = None
        self._running = False
        self._fail_count = 0
        self._reconnect_blocked_until = 0.0
        self._timer: Optional[QTimer] = None

        # Orientation controls (keep simple; defaults are no transform)
        self.rotate_deg: int = 0  # 0/90/180/270 clockwise
        self.flip: str = "none"   # none|h|v|hv
        # Digital zoom (center crop + scale), 1.0 = no zoom
        self.zoom: float = 1.0
        # Pan inside the zoom crop, normalized -1..1 in each axis (0 = center).
        self.pan_x: float = 0.0
        self.pan_y: float = 0.0

        # Per-motor detection config in DISPLAY coordinates (after zoom/letterbox).
        # Each ROI is (x0,y0,x1,y1) where x1/y1 are exclusive.
        self.roi_a: Optional[Tuple[int, int, int, int]] = None  # motor 7
        self.roi_b: Optional[Tuple[int, int, int, int]] = None  # motor 8
        self.center_a: Optional[Tuple[int, int]] = None
        self.center_b: Optional[Tuple[int, int]] = None
        # Optional calibration points (in BASE coords). Purely for overlay/UX.
        self.roi_pts_a: List[Tuple[int, int]] = []
        self.roi_pts_b: List[Tuple[int, int]] = []
        self.zero_pts_a: List[Tuple[int, int]] = []
        self.zero_pts_b: List[Tuple[int, int]] = []

        # Marker color threshold (HSV). Hue is 0..179 in OpenCV.
        # Defaults target "green", but can be calibrated via a click.
        self.marker_h: int = 60
        self.marker_tol: int = 25
        self.marker_s_min: int = 60
        self.marker_v_min: int = 60
        self._marker_pick_pt: Optional[Tuple[int, int]] = None  # in BASE coords

    def _apply_transform(self, frame_bgr: np.ndarray) -> np.ndarray:
        out = frame_bgr
        try:
            if self.rotate_deg == 90:
                out = cv2.rotate(out, cv2.ROTATE_90_CLOCKWISE)
            elif self.rotate_deg == 180:
                out = cv2.rotate(out, cv2.ROTATE_180)
            elif self.rotate_deg == 270:
                out = cv2.rotate(out, cv2.ROTATE_90_COUNTERCLOCKWISE)
        except Exception:
            pass
        try:
            if self.flip == "h":
                out = cv2.flip(out, 1)
            elif self.flip == "v":
                out = cv2.flip(out, 0)
            elif self.flip == "hv":
                out = cv2.flip(out, -1)
        except Exception:
            pass
        return out

    def _apply_zoom(self, frame_bgr: np.ndarray) -> np.ndarray:
        """
        Digital zoom by center-cropping then scaling back to output size.
        Supports pan offsets (normalized -1..1) to shift the crop window.
        """
        try:
            z = float(self.zoom)
        except Exception:
            z = 1.0
        if z <= 1.001:
            return frame_bgr
        z = float(max(1.0, min(8.0, z)))
        h, w = frame_bgr.shape[:2]
        if h <= 4 or w <= 4:
            return frame_bgr
        crop_w = int(max(4, round(w / z)))
        crop_h = int(max(4, round(h / z)))
        # Available pan range in pixels after zoom
        max_dx = max(0.0, (float(w) - float(crop_w)) / 2.0)
        max_dy = max(0.0, (float(h) - float(crop_h)) / 2.0)
        try:
            px = float(max(-1.0, min(1.0, float(self.pan_x))))
        except Exception:
            px = 0.0
        try:
            py = float(max(-1.0, min(1.0, float(self.pan_y))))
        except Exception:
            py = 0.0
        cx = int(round(float(w) / 2.0 + px * max_dx))
        cy = int(round(float(h) / 2.0 + py * max_dy))
        x0 = max(0, min(w - crop_w, cx - crop_w // 2))
        y0 = max(0, min(h - crop_h, cy - crop_h // 2))
        x1 = min(w, x0 + crop_w)
        y1 = min(h, y0 + crop_h)
        if x1 <= x0 or y1 <= y0:
            return frame_bgr
        cropped = frame_bgr[y0:y1, x0:x1]
        return cropped

    def _compute_zoom_crop_rect(self, w: int, h: int) -> Tuple[int, int, int, int]:
        """
        Compute zoom crop rect in BASE coords (after rotate/flip, before letterbox).
        Returns (x0, y0, cw, ch).
        """
        try:
            z = float(self.zoom)
        except Exception:
            z = 1.0
        if z <= 1.001:
            return (0, 0, int(w), int(h))
        z = float(max(1.0, min(8.0, z)))
        cw = int(max(4, round(float(w) / z)))
        ch = int(max(4, round(float(h) / z)))
        max_dx = max(0.0, (float(w) - float(cw)) / 2.0)
        max_dy = max(0.0, (float(h) - float(ch)) / 2.0)
        try:
            px = float(max(-1.0, min(1.0, float(self.pan_x))))
        except Exception:
            px = 0.0
        try:
            py = float(max(-1.0, min(1.0, float(self.pan_y))))
        except Exception:
            py = 0.0
        cx = int(round(float(w) / 2.0 + px * max_dx))
        cy = int(round(float(h) / 2.0 + py * max_dy))
        x0 = int(max(0, min(int(w) - int(cw), cx - cw // 2)))
        y0 = int(max(0, min(int(h) - int(ch), cy - ch // 2)))
        return (x0, y0, int(cw), int(ch))

    def _resize_letterbox(self, frame_bgr: np.ndarray) -> np.ndarray:
        """
        Resize to (self.width, self.height) preserving aspect ratio.
        Pads with black bars (letterbox) instead of stretching.
        """
        out_w = int(max(2, self.width))
        out_h = int(max(2, self.height))
        h, w = frame_bgr.shape[:2]
        if h <= 0 or w <= 0:
            return np.zeros((out_h, out_w, 3), dtype=np.uint8)

        scale = min(out_w / float(w), out_h / float(h))
        new_w = int(max(1, round(w * scale)))
        new_h = int(max(1, round(h * scale)))
        resized = cv2.resize(frame_bgr, (new_w, new_h), interpolation=cv2.INTER_AREA)

        canvas = np.zeros((out_h, out_w, 3), dtype=np.uint8)
        x0 = (out_w - new_w) // 2
        y0 = (out_h - new_h) // 2
        canvas[y0:y0 + new_h, x0:x0 + new_w] = resized
        return canvas

    def _resize_letterbox_with_map(self, frame_bgr: np.ndarray) -> Tuple[np.ndarray, Dict[str, Any]]:
        """
        Same as _resize_letterbox but returns a mapping dict for coordinate transforms.
        """
        out_w = int(max(2, self.width))
        out_h = int(max(2, self.height))
        h, w = frame_bgr.shape[:2]
        if h <= 0 or w <= 0:
            blank = np.zeros((out_h, out_w, 3), dtype=np.uint8)
            return blank, {"out_w": out_w, "out_h": out_h, "scale": 1.0, "pad_x": 0, "pad_y": 0, "scaled_w": out_w, "scaled_h": out_h}

        scale = float(min(out_w / float(w), out_h / float(h)))
        new_w = int(max(1, round(w * scale)))
        new_h = int(max(1, round(h * scale)))
        resized = cv2.resize(frame_bgr, (new_w, new_h), interpolation=cv2.INTER_AREA)

        canvas = np.zeros((out_h, out_w, 3), dtype=np.uint8)
        pad_x = int((out_w - new_w) // 2)
        pad_y = int((out_h - new_h) // 2)
        canvas[pad_y:pad_y + new_h, pad_x:pad_x + new_w] = resized
        m = {
            "out_w": out_w,
            "out_h": out_h,
            "scale": scale,
            "pad_x": pad_x,
            "pad_y": pad_y,
            "scaled_w": new_w,
            "scaled_h": new_h,
        }
        return canvas, m

    def _open(self) -> None:
        try:
            self._cap = cv2.VideoCapture(self.camera_index, cv2.CAP_ANY)
            if self._cap is None or not self._cap.isOpened():
                self._cap = None
                self.status.emit(f"[MOTOR CAM] open failed (index={self.camera_index})")
                return
            try:
                self._cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
            except Exception:
                pass
            self._fail_count = 0
            self.status.emit(f"[MOTOR CAM] opened (index={self.camera_index})")
        except Exception as exc:
            self._cap = None
            self.status.emit(f"[MOTOR CAM] open exception: {exc}")

    def _close(self) -> None:
        try:
            if self._cap is not None:
                self._cap.release()
        except Exception:
            pass
        self._cap = None

    def _maybe_reconnect(self, reason: str) -> None:
        now = time.monotonic()
        if now < float(self._reconnect_blocked_until):
            return
        self._reconnect_blocked_until = now + 0.8
        self.status.emit(f"[MOTOR CAM] reconnect: {reason}")
        self._close()
        self._open()

    @Slot()
    def start(self) -> None:
        self._running = True
        self._open()
        self._timer = QTimer()
        self._timer.setInterval(int(1000.0 / self.fps))
        self._timer.timeout.connect(self._tick)
        self._timer.start()

    @Slot()
    def stop(self) -> None:
        self._running = False
        try:
            if self._timer is not None:
                self._timer.stop()
        except Exception:
            pass
        self._close()
        self.status.emit("[MOTOR CAM] stopped")

    def _tick(self) -> None:
        if not self._running:
            return
        if self._cap is None or not self._cap.isOpened():
            self._maybe_reconnect("not opened")
            return
        ret, frame = self._cap.read()
        if not ret or frame is None:
            self._fail_count += 1
            if self._fail_count >= 8:
                self._maybe_reconnect(f"read failed x{self._fail_count}")
            return
        self._fail_count = 0

        base = self._apply_transform(frame)
        base_h, base_w = base.shape[:2]
        # Optional: auto-pick marker HSV from a user click (BASE coords).
        try:
            if self._marker_pick_pt is not None:
                px, py = int(self._marker_pick_pt[0]), int(self._marker_pick_pt[1])
                if 0 <= px < int(base_w) and 0 <= py < int(base_h):
                    bgr = base[py:py + 1, px:px + 1]
                    hsv = cv2.cvtColor(bgr, cv2.COLOR_BGR2HSV)[0, 0]
                    self.marker_h = int(hsv[0])
                    # Keep tol reasonable; user can re-pick if needed.
                    self.marker_tol = int(max(8, min(45, int(self.marker_tol))))
                    self.marker_s_min = int(max(20, min(220, int(hsv[1]) - 20)))
                    self.marker_v_min = int(max(20, min(220, int(hsv[2]) - 20)))
                    self.status.emit(
                        f"[MOTOR CAM] marker picked: H={self.marker_h} tol={self.marker_tol} S>={self.marker_s_min} V>={self.marker_v_min}"
                    )
                self._marker_pick_pt = None
        except Exception:
            self._marker_pick_pt = None
        crop_x, crop_y, crop_w, crop_h = self._compute_zoom_crop_rect(int(base_w), int(base_h))
        cropped = base[crop_y:crop_y + crop_h, crop_x:crop_x + crop_w] if crop_w > 0 and crop_h > 0 else base
        disp, lmap = self._resize_letterbox_with_map(cropped)

        metrics = self._analyze_markers(base)
        metrics["map"] = {
            "base_w": int(base_w),
            "base_h": int(base_h),
            "crop_x": int(crop_x),
            "crop_y": int(crop_y),
            "crop_w": int(crop_w),
            "crop_h": int(crop_h),
            **lmap,
        }
        # Draw overlay (ROI, centers, marker centroids)
        try:
            disp = self._draw_overlay(disp, metrics)
        except Exception:
            pass

        rgb = cv2.cvtColor(disp, cv2.COLOR_BGR2RGB)
        h, w, ch = rgb.shape
        bytes_per_line = ch * w
        qimg = QImage(rgb.data, w, h, bytes_per_line, QImage.Format_RGB888).copy()
        self.frame_ready.emit(qimg)
        try:
            self.metrics_ready.emit(metrics)
        except Exception:
            pass

    def _sanitize_roi(self, roi: Optional[Tuple[int, int, int, int]], w: int, h: int) -> Optional[Tuple[int, int, int, int]]:
        if roi is None:
            return None
        try:
            x0, y0, x1, y1 = [int(v) for v in roi]
        except Exception:
            return None
        x0 = max(0, min(w - 1, x0))
        y0 = max(0, min(h - 1, y0))
        x1 = max(1, min(w, x1))
        y1 = max(1, min(h, y1))
        if x1 - x0 < 6 or y1 - y0 < 6:
            return None
        if x1 <= x0 or y1 <= y0:
            return None
        return (x0, y0, x1, y1)

    def _detect_green_centroid(self, img_bgr: np.ndarray, roi: Tuple[int, int, int, int]) -> Tuple[Optional[Tuple[int, int]], float]:
        x0, y0, x1, y1 = roi
        patch = img_bgr[y0:y1, x0:x1]
        if patch.size == 0:
            return None, 0.0
        hsv = cv2.cvtColor(patch, cv2.COLOR_BGR2HSV)
        h0 = int(max(0, min(179, int(self.marker_h))))
        tol = int(max(1, min(90, int(self.marker_tol))))
        smin = int(max(0, min(255, int(self.marker_s_min))))
        vmin = int(max(0, min(255, int(self.marker_v_min))))
        h_low = h0 - tol
        h_high = h0 + tol
        if h_low < 0:
            m1 = cv2.inRange(hsv, (0, smin, vmin), (h_high, 255, 255))
            m2 = cv2.inRange(hsv, (179 + h_low, smin, vmin), (179, 255, 255))
            mask = cv2.bitwise_or(m1, m2)
        elif h_high > 179:
            m1 = cv2.inRange(hsv, (h_low, smin, vmin), (179, 255, 255))
            m2 = cv2.inRange(hsv, (0, smin, vmin), (h_high - 179, 255, 255))
            mask = cv2.bitwise_or(m1, m2)
        else:
            mask = cv2.inRange(hsv, (h_low, smin, vmin), (h_high, 255, 255))
        # Clean small noise
        try:
            kernel = np.ones((3, 3), np.uint8)
            mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel, iterations=1)
            mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel, iterations=1)
        except Exception:
            pass
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        if not contours:
            return None, 0.0
        best = max(contours, key=cv2.contourArea)
        area = float(cv2.contourArea(best))
        if area < 8.0:
            return None, area
        m = cv2.moments(best)
        if abs(float(m.get("m00", 0.0))) < 1e-9:
            return None, area
        cx = int(round(float(m["m10"]) / float(m["m00"]))) + x0
        cy = int(round(float(m["m01"]) / float(m["m00"]))) + y0
        return (cx, cy), area

    def _angle_deg(self, center: Tuple[int, int], pt: Tuple[int, int]) -> float:
        cx, cy = center
        x, y = pt
        return float(math.degrees(math.atan2(float(y - cy), float(x - cx))))

    def _analyze_markers(self, base_bgr: np.ndarray) -> Dict[str, Any]:
        h, w = base_bgr.shape[:2]
        roi_a = self._sanitize_roi(self.roi_a, w, h)
        roi_b = self._sanitize_roi(self.roi_b, w, h)
        out: Dict[str, Any] = {
            "base_w": w,
            "base_h": h,
            "a": {},
            "b": {},
            "marker": {
                "h": int(self.marker_h),
                "tol": int(self.marker_tol),
                "smin": int(self.marker_s_min),
                "vmin": int(self.marker_v_min),
            },
        }

        def _one(roi, center):
            res: Dict[str, Any] = {"roi": roi, "center": center, "found": False, "pt": None, "area": 0.0, "angle": None}
            if roi is None:
                return res
            pt, area = self._detect_green_centroid(base_bgr, roi)
            res["area"] = float(area)
            if pt is None:
                return res
            res["pt"] = pt
            if center is not None:
                res["angle"] = self._angle_deg(center, pt)
            res["found"] = True
            return res

        out["a"] = _one(roi_a, self.center_a)
        out["b"] = _one(roi_b, self.center_b)
        return out

    def _draw_overlay(self, disp_bgr: np.ndarray, metrics: Dict[str, Any]) -> np.ndarray:
        out = disp_bgr
        m = metrics.get("map", {}) if isinstance(metrics, dict) else {}
        try:
            crop_x = int(m.get("crop_x", 0))
            crop_y = int(m.get("crop_y", 0))
            scale = float(m.get("scale", 1.0))
            pad_x = int(m.get("pad_x", 0))
            pad_y = int(m.get("pad_y", 0))
        except Exception:
            crop_x = crop_y = pad_x = pad_y = 0
            scale = 1.0

        def _proj(pt: Optional[Tuple[int, int]]) -> Optional[Tuple[int, int]]:
            if pt is None:
                return None
            x, y = int(pt[0]), int(pt[1])
            x = x - crop_x
            y = y - crop_y
            if x < 0 or y < 0:
                return None
            dx = int(round(float(x) * scale)) + pad_x
            dy = int(round(float(y) * scale)) + pad_y
            return (dx, dy)

        def _proj_rect(roi: Optional[Tuple[int, int, int, int]]) -> Optional[Tuple[int, int, int, int]]:
            if roi is None:
                return None
            x0, y0, x1, y1 = roi
            p0 = _proj((x0, y0))
            p1 = _proj((x1, y1))
            if p0 is None or p1 is None:
                return None
            return (p0[0], p0[1], p1[0], p1[1])

        # ROI rectangles + points
        for key, color in (("a", (0, 255, 0)), ("b", (0, 200, 255))):
            mm = metrics.get(key, {}) if isinstance(metrics, dict) else {}
            roi = _proj_rect(mm.get("roi"))
            if roi is not None:
                x0, y0, x1, y1 = roi
                cv2.rectangle(out, (x0, y0), (x1 - 1, y1 - 1), color, 1)
            c = _proj(mm.get("center"))
            if c is not None:
                # Center crosshair
                cx, cy = int(c[0]), int(c[1])
                cv2.drawMarker(out, (cx, cy), (255, 255, 255), markerType=cv2.MARKER_CROSS, markerSize=10, thickness=1)
            pt = _proj(mm.get("pt"))
            if pt is not None:
                cv2.circle(out, (int(pt[0]), int(pt[1])), 4, color, -1)

            # Calibration points (if present)
            if key == "a":
                roi_pts = list(self.roi_pts_a or [])
                zero_pts = list(self.zero_pts_a or [])
            else:
                roi_pts = list(self.roi_pts_b or [])
                zero_pts = list(self.zero_pts_b or [])
            for i, p in enumerate(roi_pts[:3], start=1):
                pp = _proj(p)
                if pp is not None:
                    cv2.circle(out, (int(pp[0]), int(pp[1])), 6, color, 2)
                    cv2.putText(out, str(i), (int(pp[0]) + 6, int(pp[1]) - 6), cv2.FONT_HERSHEY_SIMPLEX, 0.4, color, 1, cv2.LINE_AA)
            for i, p in enumerate(zero_pts[:3], start=1):
                pp = _proj(p)
                if pp is not None:
                    # Zero points in magenta so they're clearly distinct from ROI points.
                    cv2.circle(out, (int(pp[0]), int(pp[1])), 6, (255, 0, 255), 2)
                    cv2.putText(out, str(i), (int(pp[0]) + 6, int(pp[1]) - 6), cv2.FONT_HERSHEY_SIMPLEX, 0.4, (255, 0, 255), 1, cv2.LINE_AA)
        return out


class MotorCamView(QLabel):
    """
    QLabel that supports click-drag panning (for the motor cam preview).
    Emits normalized pan deltas; MainWindow owns the state and forwards it to the worker.
    """

    pan_delta = Signal(float, float)  # dx_norm, dy_norm (normalized)
    pan_reset = Signal()
    rect_defined = Signal(int, int, int, int)  # x0,y0,x1,y1 in widget coords
    point_clicked = Signal(int, int)  # x,y in widget coords

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._dragging = False
        self._last_pos = None
        self.interaction_mode: str = "pan"  # pan|roi|center
        self._press_pos = None

    def mousePressEvent(self, event) -> None:
        try:
            if event.button() == Qt.LeftButton:
                self._dragging = True
                p = event.position().toPoint() if hasattr(event, "position") else event.pos()
                self._last_pos = p
                self._press_pos = p
        except Exception:
            pass
        super().mousePressEvent(event)

    def mouseMoveEvent(self, event) -> None:
        try:
            if not self._dragging or self._last_pos is None:
                super().mouseMoveEvent(event)
                return
            p = event.position().toPoint() if hasattr(event, "position") else event.pos()
            if str(self.interaction_mode) == "pan":
                dx = int(p.x() - self._last_pos.x())
                dy = int(p.y() - self._last_pos.y())
                self._last_pos = p
                w = max(1, int(self.width()))
                h = max(1, int(self.height()))
                # Dragging right should move the view right (pan content left), so invert.
                dx_norm = float(-dx) / float(w) * 2.0
                dy_norm = float(-dy) / float(h) * 2.0
                self.pan_delta.emit(dx_norm, dy_norm)
        except Exception:
            pass
        super().mouseMoveEvent(event)

    def mouseReleaseEvent(self, event) -> None:
        try:
            if event.button() == Qt.LeftButton:
                p = event.position().toPoint() if hasattr(event, "position") else event.pos()
                mode = str(self.interaction_mode)
                if mode == "roi" and self._press_pos is not None:
                    x0 = int(min(self._press_pos.x(), p.x()))
                    y0 = int(min(self._press_pos.y(), p.y()))
                    x1 = int(max(self._press_pos.x(), p.x()))
                    y1 = int(max(self._press_pos.y(), p.y()))
                    # Ignore tiny drags (treat as click)
                    if (x1 - x0) >= 6 and (y1 - y0) >= 6:
                        self.rect_defined.emit(x0, y0, x1, y1)
                    else:
                        self.point_clicked.emit(int(p.x()), int(p.y()))
                elif mode == "center":
                    self.point_clicked.emit(int(p.x()), int(p.y()))
                self._dragging = False
                self._last_pos = None
                self._press_pos = None
        except Exception:
            pass
        super().mouseReleaseEvent(event)

    def mouseDoubleClickEvent(self, event) -> None:
        try:
            if event.button() == Qt.LeftButton:
                self.pan_reset.emit()
        except Exception:
            pass
        super().mouseDoubleClickEvent(event)


def _coerce_int_key_dict(raw: dict, *, value_type=int) -> dict:
    """
    JSON stores dict keys as strings; convert back to int keys.
    value_type: int or float or str coercion function.
    """
    if not isinstance(raw, dict):
        return {}
    out = {}
    for k, v in raw.items():
        try:
            kk = int(k)
        except Exception:
            continue
        try:
            out[kk] = value_type(v)
        except Exception:
            # Fallback: keep original
            out[kk] = v
    return out


def load_fixture(path: str, key: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data["fixtures"][key]


@dataclass
class FixtureState:
    start_address: int
    channel_count: int
    min_values: Dict[int, int] = field(default_factory=dict)
    max_values: Dict[int, int] = field(default_factory=dict)
    slider_values: Dict[int, int] = field(default_factory=dict)
    modes: Dict[int, str] = field(default_factory=dict)  # "off", "static", "sine"
    rates: Dict[int, float] = field(default_factory=dict)  # Hz
    phases: Dict[int, float] = field(default_factory=dict)  # 0–1

    def ensure_defaults(self) -> None:
        for ch in range(1, self.channel_count + 1):
            self.min_values.setdefault(ch, 0)
            self.max_values.setdefault(ch, 255)
            self.slider_values.setdefault(ch, 0)
            self.modes.setdefault(ch, "static")
            self.rates.setdefault(ch, 0.0)
            self.phases.setdefault(ch, 0.0)

    def build_channels(self, t: float) -> List[int]:
        """
        Compute DMX values for this fixture at time t, using the per-channel
        behaviour parameters (min/max/slider/mode/rate/phase).
        Supported modes:
        - "off": always 0
        - "static": slider mapped linearly between min/max
        - "sine": sine LFO between min/max
        - "square": square LFO between min/max
        - "saw": sawtooth LFO between min/max
        """
        self.ensure_defaults()
        values = [0] * self.channel_count
        for ch in range(1, self.channel_count + 1):
            slider = self.slider_values.get(ch, 0)
            min_v = max(0, min(255, int(self.min_values.get(ch, 0))))
            max_v = max(0, min(255, int(self.max_values.get(ch, 255))))
            if max_v < min_v:
                max_v, min_v = min_v, max_v

            mode = self.modes.get(ch, "static")
            if mode == "off":
                actual = 0
            elif max_v == min_v:
                actual = min_v
            elif mode in ("sine", "square", "saw"):
                rate = float(self.rates.get(ch, 0.2))
                phase = float(self.phases.get(ch, 0.0))
                base = rate * t + phase  # unwrapped phase in cycles
                if mode == "sine":
                    angle = 2.0 * math.pi * base
                    norm = 0.5 + 0.5 * math.sin(angle)
                elif mode == "square":
                    angle = 2.0 * math.pi * base
                    norm = 1.0 if math.sin(angle) >= 0.0 else 0.0
                else:  # "saw"
                    frac = base - math.floor(base)
                    norm = frac  # 0..1 ramp
                actual = int(round(min_v + norm * (max_v - min_v)))
            else:
                ratio = slider / 255.0
                actual = int(round(min_v + ratio * (max_v - min_v)))
            values[ch - 1] = actual
        return values


@dataclass
class PatternSlot:
    name: str
    fixtures_state: Optional[List[FixtureState]] = None
    active_fixtures: List[bool] = field(
        default_factory=lambda: [True for _ in range(PATTERN_FIXTURE_COUNT)]
    )

    def is_defined(self) -> bool:
        return self.fixtures_state is not None


@dataclass
class PatternSet:
    """
    Named bank of patterns (same idea as the Tk controller).
    """

    name: str
    patterns: List[PatternSlot]


class MainWindow(QMainWindow):
    # Signals to safely handle OSC events coming from a non-Qt thread
    osc_pattern_received = Signal(int)  # pattern number (1-based)
    osc_set_received = Signal(int)      # set number (1-based)
    osc_stop_received = Signal()
    osc_blackout_received = Signal()

    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("IMOL Pattern Controller (Qt)")
        # Size to fit the current screen better (avoid "can't see all the window").
        try:
            screen = QApplication.primaryScreen()
            if screen is not None:
                avail = screen.availableGeometry()
                w = int(min(1400, avail.width()))
                h = int(min(880, int(avail.height() * 0.92)))
                self.resize(max(900, w), max(700, h))
            else:
                self.resize(1400, 880)
        except Exception:
            self.resize(1400, 880)

        # Dark theme palette.
        palette = self.palette()
        palette.setColor(QPalette.Window, QColor("#111111"))
        palette.setColor(QPalette.WindowText, QColor("#e0e0e0"))
        palette.setColor(QPalette.Base, QColor("#222222"))
        palette.setColor(QPalette.Text, QColor("#d0d0d0"))
        palette.setColor(QPalette.Button, QColor("#333333"))
        palette.setColor(QPalette.ButtonText, QColor("#f0f0f0"))
        # Use a green accent instead of the default blue, while keeping the
        # native widget shapes/styles.
        accent = QColor("#35c759")
        palette.setColor(QPalette.Highlight, accent)
        palette.setColor(QPalette.Link, accent)
        palette.setColor(QPalette.LinkVisited, accent.darker(110))
        self.setPalette(palette)

        self.moving_head_def = load_fixture(FIXTURES_FILE, MOVING_HEAD_KEY)
        self.hero_def = load_fixture(FIXTURES_FILE, HERO_KEY)
        self.mbm_def = load_fixture(FIXTURES_FILE, MBM_KEY)
        self.fog_def = load_fixture(FIXTURES_FILE, FOG_KEY)
        self.mh_channel_count = len(self.moving_head_def["channels"])
        self.hero_channel_count = len(self.hero_def["channels"])
        self.mbm_channel_count = len(self.mbm_def["channels"])
        self.fog_channel_count = len(self.fog_def["channels"])

        self.universe = self.moving_head_def.get("default_universe", 0)
        self.osc_port = DEFAULT_OSC_PORT
        self.external_osc_enabled: bool = True

        # Ableton Link-style sync (driven via OSC from Max or a Link bridge).
        self.link_enabled: bool = False
        self.link_tempo_bpm: float = 120.0
        self.link_beat: float = 0.0
        self._link_last_update_monotonic: Optional[float] = None

        # Fixture states.
        self.fixtures: List[FixtureState] = []
        for i in range(FIXTURE_COUNT):
            if i < MOVING_HEAD_COUNT:
                start = self.moving_head_def.get("default_address", 1) + i * self.mh_channel_count
                ch_count = self.mh_channel_count
            elif i < MOVING_HEAD_COUNT + HERO_COUNT:
                hero_index = i - MOVING_HEAD_COUNT
                start = self.hero_def.get("default_address", 1) + hero_index * self.hero_channel_count
                ch_count = self.hero_channel_count
            elif i < MOVING_HEAD_COUNT + HERO_COUNT + MBM_COUNT:
                mbm_index = i - MOVING_HEAD_COUNT - HERO_COUNT
                start = self.mbm_def.get("default_address", 1) + mbm_index * self.mbm_channel_count
                ch_count = self.mbm_channel_count
            else:
                fog_index = i - MOVING_HEAD_COUNT - HERO_COUNT - MBM_COUNT
                start = self.fog_def.get("default_address", 1) + fog_index * self.fog_channel_count
                ch_count = self.fog_channel_count
            fs = FixtureState(start_address=start, channel_count=ch_count)
            fs.ensure_defaults()
            self.fixtures.append(fs)

        # Patterns and sets (only control fixtures 1-8, not fog).
        self.patterns: List[PatternSlot] = [
            PatternSlot(name=f"Pattern {i+1}") for i in range(DEFAULT_PATTERN_SLOTS)
        ]
        self.pattern_sets: List[PatternSet] = self._load_sets_from_disk()
        self.active_pattern_index: Optional[int] = None
        self.patterns_locked: bool = True  # Global lock to prevent overwriting patterns (default: locked)

        # Fog timer (independent of patterns).
        self.fog_enabled: bool = False
        self.fog_burst_duration_s: float = 3.0
        self.fog_interval_s: float = 120.0
        self.fog_last_burst_time: Optional[float] = None
        self._load_fog_timer_config()

        # Pattern UI references (set in _build_patterns_block / _rebuild_patterns_ui).
        self.patterns_group: Optional[QGroupBox] = None
        self.patterns_layout: Optional[QVBoxLayout] = None
        self.set_name_edit: Optional[QLineEdit] = None
        self.set_combo: Optional[QComboBox] = None
        self._last_selected_set_name: str = ""
        self.patterns_lock_btn: Optional[QPushButton] = None

        # OSC server placeholder.
        self._osc_server: Optional[ThreadingOSCUDPServer] = None

        # DMX timing diagnostics.
        self._last_tick_time: Optional[float] = None
        self._fps_smooth: Optional[float] = None
        self.fps_value_label: Optional[QLabel] = None

        # DMX sender thread (avoid repeated ClientWrapper creation / fd leaks on macOS)
        self._dmx_thread: Optional[threading.Thread] = None
        self._dmx_running: bool = True
        self._dmx_queue: deque = deque(maxlen=1)  # stores (universe:int, frame:List[int])
        self._dmx_cv = threading.Condition()

        # OSC diagnostics (incoming messages)
        self.osc_pattern_last_label: Optional[QLabel] = None
        self.osc_set_last_label: Optional[QLabel] = None
        self._osc_rx_count: int = 0
        self._osc_rx_pattern_count: int = 0
        self._osc_rx_set_count: int = 0

        # Motor camera preview (2nd camera for MBM alignment / zeroing)
        self.motor_cam_enabled: bool = True
        self.motor_cam_index: int = 1
        self.motor_cam_rotate: int = 0
        self.motor_cam_flip: str = "none"
        self.motor_cam_zoom: float = 1.0
        self.motor_cam_pan_x: float = 0.0
        self.motor_cam_pan_y: float = 0.0
        self.motor_cam_role: str = "motor"
        self.camera_roles_file: str = str(DEFAULT_ROLES_PATH)
        self._motor_cam_thread: Optional[QThread] = None
        self._motor_cam_worker: Optional[MotorCamWorker] = None
        self._motor_cam_label: Optional[QLabel] = None
        self._motor_cam_enable_cb: Optional[QCheckBox] = None
        self._motor_cam_index_spin: Optional[QSpinBox] = None
        self._motor_cam_rotate_combo: Optional[QComboBox] = None
        self._motor_cam_flip_combo: Optional[QComboBox] = None  # kept for compatibility; not shown in GUI
        self._motor_cam_zoom_slider: Optional[QSlider] = None
        self._motor_cam_zoom_label: Optional[QLabel] = None
        self._motor_cam_cal_btn: Optional[QPushButton] = None
        self._motor_cam_status_label: Optional[QLabel] = None

        # Motor CV + homing state (for MBM fixtures, typically fixtures 7 and 8).
        # Stored in DISPLAY coords of the motor cam preview (320x180).
        self.motor_roi_a: Optional[Tuple[int, int, int, int]] = None
        self.motor_roi_b: Optional[Tuple[int, int, int, int]] = None
        self.motor_center_a: Optional[Tuple[int, int]] = None
        self.motor_center_b: Optional[Tuple[int, int]] = None
        self.motor_zero_a: Optional[float] = None
        self.motor_zero_b: Optional[float] = None
        # Optional 3-point calibration (stored in BASE coords) for UX/precision.
        self.motor_roi_pts_a: List[Tuple[int, int]] = []
        self.motor_roi_pts_b: List[Tuple[int, int]] = []
        self.motor_zero_pts_a: List[Tuple[int, int]] = []
        self.motor_zero_pts_b: List[Tuple[int, int]] = []
        self.motor_invert_a: bool = False
        self.motor_invert_b: bool = False
        # Your tests show the low range (1..127) has reversed speed response:
        # e.g. 14 = fast, 67 = slow. High range (129..255) behaves normal (255 fast).
        self.motor_low_range_speed_reversed: bool = True
        self.motor_tol_deg: float = 2.5
        # Marker threshold (HSV). Can be auto-calibrated by clicking the marker.
        self.motor_marker_h: int = 60
        self.motor_marker_tol: int = 25
        self.motor_marker_smin: int = 60
        self.motor_marker_vmin: int = 60
        self._motor_angle_a: Optional[float] = None
        self._motor_angle_b: Optional[float] = None
        self._motor_found_a: bool = False
        self._motor_found_b: bool = False
        self._motor_homing_a: bool = False
        self._motor_homing_b: bool = False
        # Last valid angles (helps Set Zero even if detection drops for a frame)
        self._motor_angle_a_last: Optional[float] = None
        self._motor_angle_b_last: Optional[float] = None
        # Smoothed angles for stable homing (reduces jitter / chatter near target)
        self._motor_angle_a_filt: Optional[float] = None
        self._motor_angle_b_filt: Optional[float] = None
        # Hysteresis counters + stop hold (prevents "shaking" at target)
        self._motor_within_a: int = 0
        self._motor_within_b: int = 0
        self._motor_stop_hold_until_a: float = 0.0
        self._motor_stop_hold_until_b: float = 0.0
        # Direction change protection (continuous rotation motors can "freeze" on fast reversals)
        self._motor_last_dir_a: int = 0  # -1=CCW, 0=stop/unknown, +1=CW (in controller sign space)
        self._motor_last_dir_b: int = 0
        self._motor_reverse_block_until_a: float = 0.0
        self._motor_reverse_block_until_b: float = 0.0
        self.motor_reverse_stop_dwell_s: float = 0.25
        # If a reversal would be within this many degrees, prefer taking the long way around (same direction).
        self.motor_wrap_prefer_deg: float = 70.0
        self._motor_last_map: Optional[Dict[str, Any]] = None
        self._motor_legacy_converted: bool = False

        # 3-point capture buffers (in BASE coords)
        self._pts_roi_a: List[Tuple[int, int]] = []
        self._pts_roi_b: List[Tuple[int, int]] = []
        self._pts_zero_a: List[Tuple[int, int]] = []
        self._pts_zero_b: List[Tuple[int, int]] = []

        self._motor_cam_mode_combo: Optional[QComboBox] = None
        self._motor_cam_hint_label: Optional[QLabel] = None
        self._motor_cam_cancel_btn: Optional[QPushButton] = None
        self._motor_cam_mode: str = "pan"  # pan|roi_drag_a|roi_drag_b|roi_pts_a|roi_pts_b|center_a|center_b|zero_pts_a|zero_pts_b
        self._motor_angle_label_a: Optional[QLabel] = None
        self._motor_angle_label_b: Optional[QLabel] = None
        self._motor_go_btn_a: Optional[QPushButton] = None
        self._motor_go_btn_b: Optional[QPushButton] = None
        self._motor_stop_btn: Optional[QPushButton] = None

        # Load persisted motor calibration (ROI/center/zero/etc).
        self._load_motor_homing_config()

        self._build_ui()

        # Wire OSC signals (queued to GUI thread automatically when emitted from OSC thread)
        self.osc_pattern_received.connect(self._on_osc_pattern_received)
        self.osc_set_received.connect(self._on_osc_set_received)
        self.osc_stop_received.connect(self._on_osc_stop_received)
        self.osc_blackout_received.connect(self._on_osc_blackout_received)

        # Start DMX thread + tick timer immediately (needed for fog timer to work).
        self._ensure_dmx_thread()

        # If we have saved sets, auto-load one so /pattern works immediately.
        QTimer.singleShot(0, self._maybe_autoload_initial_set)

    def _load_motor_homing_config(self) -> None:
        try:
            if not os.path.exists(MOTOR_HOMING_FILE):
                return
            with open(MOTOR_HOMING_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
            # Motor cam view (so the preview comes back exactly as you left it).
            view = data.get("motor_cam_view", {}) if isinstance(data, dict) else {}
            if isinstance(view, dict):
                try:
                    self.motor_cam_enabled = bool(view.get("enabled", self.motor_cam_enabled))
                except Exception:
                    pass
                try:
                    self.motor_cam_index = int(view.get("index", self.motor_cam_index))
                except Exception:
                    pass
                try:
                    self.motor_cam_rotate = int(view.get("rotate", self.motor_cam_rotate))
                except Exception:
                    pass
                try:
                    self.motor_cam_flip = str(view.get("flip", self.motor_cam_flip))
                except Exception:
                    pass
                try:
                    self.motor_cam_zoom = float(view.get("zoom", self.motor_cam_zoom))
                except Exception:
                    pass
                try:
                    self.motor_cam_pan_x = float(view.get("pan_x", self.motor_cam_pan_x))
                    self.motor_cam_pan_y = float(view.get("pan_y", self.motor_cam_pan_y))
                except Exception:
                    pass

            self.motor_roi_a = tuple(data.get("roi_a")) if data.get("roi_a") else None
            self.motor_roi_b = tuple(data.get("roi_b")) if data.get("roi_b") else None
            self.motor_center_a = tuple(data.get("center_a")) if data.get("center_a") else None
            self.motor_center_b = tuple(data.get("center_b")) if data.get("center_b") else None
            self.motor_zero_a = float(data["zero_a"]) if data.get("zero_a") is not None else None
            self.motor_zero_b = float(data["zero_b"]) if data.get("zero_b") is not None else None
            self.motor_roi_pts_a = [tuple(p) for p in (data.get("roi_pts_a") or [])][:3]
            self.motor_roi_pts_b = [tuple(p) for p in (data.get("roi_pts_b") or [])][:3]
            self.motor_zero_pts_a = [tuple(p) for p in (data.get("zero_pts_a") or [])][:3]
            self.motor_zero_pts_b = [tuple(p) for p in (data.get("zero_pts_b") or [])][:3]
            self.motor_invert_a = bool(data.get("invert_a", False))
            self.motor_invert_b = bool(data.get("invert_b", False))
            self.motor_low_range_speed_reversed = bool(data.get("low_range_speed_reversed", True))
            marker = data.get("marker") if isinstance(data.get("marker"), dict) else {}
            if isinstance(marker, dict):
                try:
                    self.motor_marker_h = int(marker.get("h", self.motor_marker_h))
                    self.motor_marker_tol = int(marker.get("tol", self.motor_marker_tol))
                    self.motor_marker_smin = int(marker.get("smin", self.motor_marker_smin))
                    self.motor_marker_vmin = int(marker.get("vmin", self.motor_marker_vmin))
                except Exception:
                    pass
            self.motor_tol_deg = float(data.get("tol_deg", 2.5))
        except Exception:
            return

    def _load_fog_timer_config(self) -> None:
        """Load fog timer config from disk (separate from patterns/sets)."""
        try:
            if not os.path.exists(FOG_TIMER_FILE):
                return
            with open(FOG_TIMER_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
            self.fog_enabled = bool(data.get("enabled", False))
            self.fog_burst_duration_s = float(data.get("burst_duration_s", 3.0))
            self.fog_interval_s = float(data.get("interval_s", 120.0))
        except Exception:
            return

    def _save_fog_timer_config(self) -> None:
        """Save fog timer config to disk."""
        try:
            data = {
                "enabled": bool(self.fog_enabled),
                "burst_duration_s": float(self.fog_burst_duration_s),
                "interval_s": float(self.fog_interval_s),
            }
            with open(FOG_TIMER_FILE, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2)
        except Exception:
            return

    def _save_motor_homing_config(self) -> None:
        try:
            data = {
                "motor_cam_view": {
                    "enabled": bool(self.motor_cam_enabled),
                    "index": int(self.motor_cam_index),
                    "rotate": int(self.motor_cam_rotate),
                    "flip": str(self.motor_cam_flip),
                    "zoom": float(self.motor_cam_zoom),
                    "pan_x": float(self.motor_cam_pan_x),
                    "pan_y": float(self.motor_cam_pan_y),
                },
                "roi_a": list(self.motor_roi_a) if self.motor_roi_a else None,
                "roi_b": list(self.motor_roi_b) if self.motor_roi_b else None,
                "roi_pts_a": [list(p) for p in (self.motor_roi_pts_a or [])][:3],
                "roi_pts_b": [list(p) for p in (self.motor_roi_pts_b or [])][:3],
                "center_a": list(self.motor_center_a) if self.motor_center_a else None,
                "center_b": list(self.motor_center_b) if self.motor_center_b else None,
                "zero_a": self.motor_zero_a,
                "zero_b": self.motor_zero_b,
                "zero_pts_a": [list(p) for p in (self.motor_zero_pts_a or [])][:3],
                "zero_pts_b": [list(p) for p in (self.motor_zero_pts_b or [])][:3],
                "invert_a": bool(self.motor_invert_a),
                "invert_b": bool(self.motor_invert_b),
                "low_range_speed_reversed": bool(self.motor_low_range_speed_reversed),
                "marker": {
                    "h": int(self.motor_marker_h),
                    "tol": int(self.motor_marker_tol),
                    "smin": int(self.motor_marker_smin),
                    "vmin": int(self.motor_marker_vmin),
                },
                "tol_deg": float(self.motor_tol_deg),
            }
            with open(MOTOR_HOMING_FILE, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, sort_keys=True)
        except Exception:
            return

    def _maybe_autoload_initial_set(self) -> None:
        """
        If there are saved pattern sets on disk, load the first one automatically
        so external OSC (/pattern) doesn't get ignored due to undefined slots.
        """
        try:
            if not self.pattern_sets:
                return
            if any(p.is_defined() for p in self.patterns):
                return
            if self.set_combo is None or self.set_combo.count() <= 0:
                return
            # Prefer last-selected name if present; otherwise first set.
            target = self._last_selected_set_name or self.pattern_sets[0].name
            self.set_combo.setCurrentText(target)
            self._on_load_set()
        except Exception:
            return

    def closeEvent(self, event) -> None:
        """Stop background threads cleanly."""
        self._dmx_running = False
        try:
            with self._dmx_cv:
                self._dmx_cv.notify_all()
        except Exception:
            pass
        # Persist motor cam view + calibration on exit (best effort).
        self._save_motor_homing_config()
        self._stop_motor_cam()
        super().closeEvent(event)

    def _ensure_dmx_thread(self) -> None:
        """Start the DMX sender thread on first use."""
        if self._dmx_thread is not None:
            return

        def worker() -> None:
            wrapper = None
            client = None
            while self._dmx_running:
                with self._dmx_cv:
                    while self._dmx_running and not self._dmx_queue:
                        self._dmx_cv.wait(timeout=0.5)
                    if not self._dmx_running:
                        break
                    universe, frame = self._dmx_queue.pop()

                # Ensure OLA client exists (persistent wrapper to keep fd stable)
                try:
                    if wrapper is None:
                        wrapper = ClientWrapper()
                        client = wrapper.Client()
                except OLADNotRunningException:
                    _start_olad_if_needed()
                    try:
                        wrapper = ClientWrapper()
                        client = wrapper.Client()
                    except Exception as exc:
                        print(f"[DMX] Failed to connect to OLAD: {exc}")
                        wrapper = None
                        client = None
                        continue
                except Exception as exc:
                    print(f"[DMX] OLA init error: {exc}")
                    wrapper = None
                    client = None
                    continue

                if wrapper is None or client is None:
                    continue

                def dmx_sent(_state) -> None:
                    try:
                        wrapper.Stop()
                    except Exception:
                        pass

                try:
                    client.SendDmx(int(universe), DmxByteArray(frame), dmx_sent)
                    wrapper.Run()
                except Exception as exc:
                    # Reset wrapper so we recover on next send
                    print(f"[DMX] send error: {exc}")
                    wrapper = None
                    client = None
                    continue

        self._dmx_thread = threading.Thread(target=worker, daemon=True)
        self._dmx_thread.start()

        # DMX tick timer.
        self.timer = QTimer(self)
        self.timer.setInterval(50)  # ~20 FPS.
        self.timer.timeout.connect(self._tick)
        self.timer.start()

    # --------------------------- UI construction ---------------------------

    def _build_ui(self) -> None:
        root = QWidget()
        self.setCentralWidget(root)
        main_layout = QVBoxLayout(root)
        main_layout.setContentsMargins(12, 12, 12, 12)
        main_layout.setSpacing(10)

        # Vertical splitter so the UI can adapt to different screen heights.
        splitter = QSplitter(Qt.Vertical)
        splitter.setChildrenCollapsible(False)
        main_layout.addWidget(splitter, 1)

        # --- Top area (4 boxes)
        top_container = QWidget()
        # Don't let the top area eat the whole window; bottom panels need the space.
        try:
            top_container.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Maximum)
            top_container.setMaximumHeight(330)
        except Exception:
            pass
        top_layout = QVBoxLayout(top_container)
        top_layout.setContentsMargins(0, 0, 0, 0)
        top_layout.setSpacing(0)

        # [ OLA ] [ FIXTURES ADD ] [ ENGINE / EXTERNAL CONTROL ] [ MOTOR CAM ]
        top_row = QHBoxLayout()
        top_row.setSpacing(12)
        top_layout.addLayout(top_row)

        ola_group = self._build_ola_block()
        fixtures_group = self._build_fixtures_block()
        engine_group = self._build_engine_block()
        motor_cam_group = self._build_motor_cam_block()

        top_row.addWidget(ola_group, 2)
        top_row.addWidget(fixtures_group, 2)
        top_row.addWidget(engine_group, 2)
        top_row.addWidget(motor_cam_group, 2)

        splitter.addWidget(top_container)

        # --- Bottom area (fixture editor + patterns)
        bottom_container = QWidget()
        try:
            bottom_container.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        except Exception:
            pass
        mid_layout = QHBoxLayout(bottom_container)
        mid_layout.setContentsMargins(0, 0, 0, 0)
        mid_layout.setSpacing(12)

        left_panel = QVBoxLayout()
        right_panel = QVBoxLayout()
        mid_layout.addLayout(left_panel, 1)
        mid_layout.addLayout(right_panel, 1)

        self._build_fixture_editor(left_panel)
        self._build_patterns_block(right_panel)
        splitter.addWidget(bottom_container)

        # Prefer giving the bottom (editor/patterns) more space by default.
        try:
            splitter.setStretchFactor(0, 0)
            splitter.setStretchFactor(1, 1)
            screen = QApplication.primaryScreen()
            if screen is not None:
                avail_h = int(screen.availableGeometry().height())
                top_h = int(min(320, max(220, avail_h * 0.28)))
                splitter.setSizes([top_h, max(400, avail_h - top_h)])
            else:
                splitter.setSizes([260, 900])
        except Exception:
            pass

    def _build_ola_block(self) -> QGroupBox:
        """
        OLA block (single top-row box): contains universe/osc selectors and OLA services controls.
        """
        group = QGroupBox("OLA")
        layout = QVBoxLayout(group)
        layout.setContentsMargins(8, 8, 8, 8)
        layout.setSpacing(10)
        self._build_universe_osc_block(layout)
        self._build_ola_services_block(layout)
        return group

    def _build_universe_osc_block(self, parent_layout: QVBoxLayout) -> None:
        row = QHBoxLayout()
        parent_layout.addLayout(row)

        # Universe box.
        u_box = QGroupBox("u:")
        u_layout = QHBoxLayout(u_box)
        self.universe_edit = QSpinBox()
        self.universe_edit.setRange(0, 512)
        self.universe_edit.setValue(self.universe)
        self.universe_edit.valueChanged.connect(self._on_universe_changed)
        u_layout.addWidget(self.universe_edit)
        row.addWidget(u_box)

        # OSC box.
        osc_box = QGroupBox("osc:")
        osc_layout = QHBoxLayout(osc_box)
        self.osc_edit = QSpinBox()
        self.osc_edit.setRange(1, 65535)
        self.osc_edit.setValue(self.osc_port)
        self.osc_edit.valueChanged.connect(self._on_osc_port_changed)
        osc_layout.addWidget(self.osc_edit)
        row.addWidget(osc_box)

        start_osc_btn = QPushButton("START OSC")
        # Wiring of OSC start is left as a TODO; we keep behaviour parity later.
        start_osc_btn.clicked.connect(self._on_start_osc_clicked)
        row.addWidget(start_osc_btn)

    def _build_ola_services_block(self, parent_layout: QVBoxLayout) -> None:
        group = QGroupBox("OLA SERVICES")
        parent_layout.addWidget(group)
        layout = QGridLayout(group)

        self.ola_status_label = QLabel("Status: unknown")
        layout.addWidget(self.ola_status_label, 0, 0, 1, 3)

        check_btn = QPushButton("CHECK")
        open_btn = QPushButton("OPEN UI")
        stop_btn = QPushButton("STOP")
        restart_btn = QPushButton("RESTART")
        start_btn = QPushButton("START")

        check_btn.clicked.connect(self._on_check_ola)
        open_btn.clicked.connect(self._on_open_ola_ui)
        stop_btn.clicked.connect(self._on_stop_ola)
        restart_btn.clicked.connect(self._on_restart_ola)
        start_btn.clicked.connect(self._on_start_ola)

        layout.addWidget(check_btn, 1, 0)
        layout.addWidget(open_btn, 1, 1)
        layout.addWidget(stop_btn, 2, 0)
        layout.addWidget(restart_btn, 2, 1)
        layout.addWidget(start_btn, 2, 2)

    def _build_fixtures_block(self) -> QGroupBox:
        group = QGroupBox("FIXTURES ADD")
        layout = QGridLayout(group)
        layout.setHorizontalSpacing(12)
        layout.setContentsMargins(8, 8, 8, 8)

        self.fixture_addr_edits: List[QSpinBox] = []
        for i in range(FIXTURE_COUNT):
            label = QLabel(f"f{i+1}:")
            label.setAlignment(Qt.AlignRight | Qt.AlignVCenter)

            edit = QSpinBox()
            edit.setRange(1, 512)
            edit.setValue(self.fixtures[i].start_address)
            edit.valueChanged.connect(self._make_fixture_addr_callback(i))

            # Pack label + spinbox tightly together in a small row layout,
            # then place that as a single cell in the grid. This keeps the
            # fixture name visually close to its value.
            row_widget = QWidget()
            row_layout = QHBoxLayout(row_widget)
            row_layout.setContentsMargins(0, 0, 0, 0)
            row_layout.setSpacing(4)
            row_layout.addWidget(label)
            row_layout.addWidget(edit)

            r = i // 2
            c = i % 2
            layout.addWidget(row_widget, r, c)

            self.fixture_addr_edits.append(edit)

        # Validate address ranges once UI is built (helps catch overlaps immediately).
        QTimer.singleShot(0, self._validate_fixture_address_ranges)
        return group

    def _build_engine_block(self) -> QGroupBox:
        """
        Small diagnostics / external control block: shows DMX frame rate and
        lets you enable/disable external OSC control (from Max, etc.).
        Also includes independent fog timer control.
        """
        group = QGroupBox("ENGINE / EXTERNAL CONTROL")
        layout = QGridLayout(group)

        # DMX frame rate display (smoothed).
        layout.addWidget(QLabel("DMX FPS"), 0, 0, Qt.AlignLeft)
        self.fps_value_label = QLabel("—")
        layout.addWidget(self.fps_value_label, 0, 1, Qt.AlignLeft)

        # OSC RX monitor (shows last incoming message)
        layout.addWidget(QLabel("OSC pattern"), 1, 0, Qt.AlignLeft)
        self.osc_pattern_last_label = QLabel("—")
        self.osc_pattern_last_label.setTextInteractionFlags(Qt.TextSelectableByMouse)
        layout.addWidget(self.osc_pattern_last_label, 1, 1, 1, 1, Qt.AlignLeft)

        layout.addWidget(QLabel("OSC set"), 2, 0, Qt.AlignLeft)
        self.osc_set_last_label = QLabel("—")
        self.osc_set_last_label.setTextInteractionFlags(Qt.TextSelectableByMouse)
        layout.addWidget(self.osc_set_last_label, 2, 1, 1, 1, Qt.AlignLeft)

        # External OSC enable toggle.
        osc_cb = QCheckBox("Enable OSC control (pattern + set)")
        osc_cb.setChecked(True)

        def _on_osc_toggle(state: int) -> None:
            self.external_osc_enabled = state == Qt.Checked

        osc_cb.stateChanged.connect(_on_osc_toggle)
        layout.addWidget(osc_cb, 3, 0, 1, 2, Qt.AlignLeft)

        # Hard reset: immediately stop all behaviours and send DMX = 0.
        reset_btn = QPushButton("Hard reset (all fixtures off)")
        reset_btn.clicked.connect(self._on_hard_reset_all)
        layout.addWidget(reset_btn, 4, 0, 1, 2, Qt.AlignLeft)

        # Fog timer (independent of patterns).
        layout.addWidget(QLabel("Fog (F9) Timer"), 5, 0, 1, 2, Qt.AlignLeft)
        fog_enable_cb = QCheckBox("Enable auto fog")
        fog_enable_cb.setChecked(bool(self.fog_enabled))
        print(f"[FOG DEBUG] Checkbox created, initial state: {self.fog_enabled}")
        fog_enable_cb.stateChanged.connect(self._on_fog_enable_changed)
        print(f"[FOG DEBUG] Checkbox signal connected to _on_fog_enable_changed")
        layout.addWidget(fog_enable_cb, 6, 0, 1, 2, Qt.AlignLeft)

        layout.addWidget(QLabel("Burst (s)"), 7, 0, Qt.AlignLeft)
        self.fog_burst_spin = QDoubleSpinBox()
        self.fog_burst_spin.setRange(0.5, 30.0)
        self.fog_burst_spin.setSingleStep(0.5)
        self.fog_burst_spin.setValue(float(self.fog_burst_duration_s))
        self.fog_burst_spin.valueChanged.connect(self._on_fog_burst_changed)
        layout.addWidget(self.fog_burst_spin, 7, 1, Qt.AlignLeft)

        layout.addWidget(QLabel("Interval (s)"), 8, 0, Qt.AlignLeft)
        self.fog_interval_spin = QDoubleSpinBox()
        self.fog_interval_spin.setRange(10.0, 3600.0)
        self.fog_interval_spin.setSingleStep(10.0)
        self.fog_interval_spin.setValue(float(self.fog_interval_s))
        self.fog_interval_spin.valueChanged.connect(self._on_fog_interval_changed)
        layout.addWidget(self.fog_interval_spin, 8, 1, Qt.AlignLeft)

        fog_manual_btn = QPushButton("Manual Fog Burst")
        fog_manual_btn.clicked.connect(self._on_fog_manual_burst)
        layout.addWidget(fog_manual_btn, 9, 0, 1, 2, Qt.AlignLeft)

        # Placeholder for Ableton Link (not implemented yet, but reserved).
        link_label = QLabel("Ableton Link: driven via /link/* OSC")
        link_label.setEnabled(False)
        layout.addWidget(link_label, 10, 0, 1, 2, Qt.AlignLeft)

        return group

    def _build_motor_cam_block(self) -> QGroupBox:
        """
        Motor cam block as a dedicated top-row box (so it doesn't change the engine block dimensions).
        """
        motor_group = QGroupBox("MOTOR CAM")
        mg = QGridLayout(motor_group)
        mg.setContentsMargins(6, 6, 6, 6)
        mg.setHorizontalSpacing(8)
        mg.setVerticalSpacing(6)

        self._motor_cam_enable_cb = QCheckBox("Enable")
        self._motor_cam_enable_cb.setChecked(bool(self.motor_cam_enabled))
        self._motor_cam_enable_cb.stateChanged.connect(self._on_motor_cam_enable_changed)
        mg.addWidget(self._motor_cam_enable_cb, 0, 0, 1, 4, Qt.AlignLeft)

        mg.addWidget(QLabel("Index"), 1, 0, Qt.AlignLeft)
        self._motor_cam_index_spin = QSpinBox()
        self._motor_cam_index_spin.setRange(0, 16)
        self._motor_cam_index_spin.setValue(int(self.motor_cam_index))
        self._motor_cam_index_spin.valueChanged.connect(self._on_motor_cam_index_changed)
        mg.addWidget(self._motor_cam_index_spin, 1, 1)

        mg.addWidget(QLabel("Rotate"), 1, 2, Qt.AlignLeft)
        self._motor_cam_rotate_combo = QComboBox()
        self._motor_cam_rotate_combo.addItems(["0", "90", "180", "270"])
        self._motor_cam_rotate_combo.setCurrentText(str(int(self.motor_cam_rotate)))
        self._motor_cam_rotate_combo.currentTextChanged.connect(self._on_motor_cam_rotate_changed)
        mg.addWidget(self._motor_cam_rotate_combo, 1, 3)

        # Flip removed from GUI (keep internal support, but simplify UI).

        mg.addWidget(QLabel("Zoom"), 2, 0, Qt.AlignLeft)
        zoom_row = QWidget()
        zoom_l = QHBoxLayout(zoom_row)
        zoom_l.setContentsMargins(0, 0, 0, 0)
        zoom_l.setSpacing(8)
        self._motor_cam_zoom_slider = QSlider(Qt.Horizontal)
        self._motor_cam_zoom_slider.setRange(100, 400)  # 1.00x .. 4.00x
        self._motor_cam_zoom_slider.setValue(int(round(float(self.motor_cam_zoom) * 100.0)))
        self._motor_cam_zoom_slider.valueChanged.connect(self._on_motor_cam_zoom_changed)
        self._motor_cam_zoom_label = QLabel(f"{float(self.motor_cam_zoom):0.2f}x")
        self._motor_cam_zoom_label.setStyleSheet("color: #9a9a9a; font-size: 11px;")
        zoom_l.addWidget(self._motor_cam_zoom_slider, 1)
        zoom_l.addWidget(self._motor_cam_zoom_label, 0, Qt.AlignRight)
        mg.addWidget(zoom_row, 2, 1)

        # Interaction mode (pan vs calibration clicks)
        mg.addWidget(QLabel("Mouse"), 2, 2, Qt.AlignLeft)
        self._motor_cam_mode_combo = QComboBox()
        self._motor_cam_mode_combo.addItems(
            [
                "View: Pan / Drag",
                "Calibrate M7: ROI (drag rectangle)",
                "Calibrate M8: ROI (drag rectangle)",
                "Calibrate M7: ROI (3 clicks)",
                "Calibrate M8: ROI (3 clicks)",
                "Calibrate M7: Center (1 click)",
                "Calibrate M8: Center (1 click)",
                "Calibrate M7: Zero (3 clicks)",
                "Calibrate M8: Zero (3 clicks)",
                "Calibrate: Marker Color (1 click)",
            ]
        )
        self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")
        self._motor_cam_mode_combo.currentTextChanged.connect(self._on_motor_cam_mode_changed)
        mouse_row = QWidget()
        mouse_l = QHBoxLayout(mouse_row)
        mouse_l.setContentsMargins(0, 0, 0, 0)
        mouse_l.setSpacing(6)
        self._motor_cam_cancel_btn = QPushButton("Cancel")
        self._motor_cam_cancel_btn.setFixedWidth(72)
        self._motor_cam_cancel_btn.clicked.connect(self._on_motor_cam_cancel)
        mouse_l.addWidget(self._motor_cam_mode_combo, 1)
        mouse_l.addWidget(self._motor_cam_cancel_btn, 0)
        mg.addWidget(mouse_row, 2, 3)

        self._motor_cam_hint_label = QLabel("View mode: drag to pan. Double-click to re-center pan.")
        self._motor_cam_hint_label.setStyleSheet("color: #9a9a9a; font-size: 11px;")
        mg.addWidget(self._motor_cam_hint_label, 3, 0, 1, 4)

        self._motor_cam_label = MotorCamView("—")
        # Slightly smaller preview to fit more comfortably on shorter screens.
        self._motor_cam_label.setFixedSize(320, 150)
        self._motor_cam_label.setAlignment(Qt.AlignCenter)
        self._motor_cam_label.setStyleSheet("background-color: #000; border: 1px solid #333; color: #9a9a9a;")
        self._motor_cam_label.pan_delta.connect(self._on_motor_cam_pan_delta)
        self._motor_cam_label.pan_reset.connect(self._on_motor_cam_pan_reset)
        self._motor_cam_label.rect_defined.connect(self._on_motor_cam_rect_defined)
        self._motor_cam_label.point_clicked.connect(self._on_motor_cam_point_clicked)
        mg.addWidget(self._motor_cam_label, 4, 0, 1, 4)

        # Angle readouts + homing controls
        self._motor_angle_label_a = QLabel("M7: —")
        self._motor_angle_label_b = QLabel("M8: —")
        self._motor_angle_label_a.setStyleSheet("color: #9a9a9a; font-size: 11px;")
        self._motor_angle_label_b.setStyleSheet("color: #9a9a9a; font-size: 11px;")
        # Prevent layout jitter/resizing when the text changes (e.g. "no marker" vs "+123.4°")
        try:
            self._motor_angle_label_a.setFixedWidth(170)
            self._motor_angle_label_b.setFixedWidth(170)
            self._motor_angle_label_a.setAlignment(Qt.AlignLeft | Qt.AlignVCenter)
            self._motor_angle_label_b.setAlignment(Qt.AlignLeft | Qt.AlignVCenter)
        except Exception:
            pass
        mg.addWidget(self._motor_angle_label_a, 5, 0, 1, 2, Qt.AlignLeft)
        mg.addWidget(self._motor_angle_label_b, 5, 2, 1, 2, Qt.AlignLeft)

        btn_row = QWidget()
        btn_l = QHBoxLayout(btn_row)
        btn_l.setContentsMargins(0, 0, 0, 0)
        btn_l.setSpacing(8)
        set_zero_a = QPushButton("Set Zero 7")
        set_zero_b = QPushButton("Set Zero 8")
        self._motor_go_btn_a = QPushButton("Go Zero 7")
        self._motor_go_btn_b = QPushButton("Go Zero 8")
        self._motor_stop_btn = QPushButton("STOP")
        set_zero_a.clicked.connect(lambda: self._on_motor_set_zero("a"))
        set_zero_b.clicked.connect(lambda: self._on_motor_set_zero("b"))
        self._motor_go_btn_a.clicked.connect(lambda: self._on_motor_go_zero("a"))
        self._motor_go_btn_b.clicked.connect(lambda: self._on_motor_go_zero("b"))
        self._motor_stop_btn.clicked.connect(self._on_motor_stop_homing)
        btn_l.addWidget(set_zero_a)
        btn_l.addWidget(self._motor_go_btn_a)
        btn_l.addWidget(set_zero_b)
        btn_l.addWidget(self._motor_go_btn_b)
        btn_l.addWidget(self._motor_stop_btn)
        mg.addWidget(btn_row, 6, 0, 1, 4)

        self._motor_cam_cal_btn = QPushButton("Calibrate role 'motor'")
        self._motor_cam_cal_btn.clicked.connect(self._on_motor_cam_calibrate_clicked)
        mg.addWidget(self._motor_cam_cal_btn, 7, 0, 1, 4)

        self._motor_cam_status_label = QLabel("roles: —")
        self._motor_cam_status_label.setStyleSheet("color: #9a9a9a; font-size: 11px;")
        mg.addWidget(self._motor_cam_status_label, 8, 0, 1, 4)

        # Start motor cam after UI exists
        QTimer.singleShot(0, self._maybe_start_motor_cam)
        return motor_group

    # --------------------------- Fog timer callbacks ---------------------------

    def _on_fog_enable_changed(self, state: int) -> None:
        print(f"[FOG DEBUG] _on_fog_enable_changed called! state={state}")
        was_enabled = self.fog_enabled
        # PySide6: state is int, Qt.Checked is enum - compare values
        self.fog_enabled = (state == Qt.Checked.value) if hasattr(Qt.Checked, 'value') else (state == 2)
        
        print(f"[FOG DEBUG] was_enabled={was_enabled}, now fog_enabled={self.fog_enabled}")
        
        if self.fog_enabled and not was_enabled:
            # Turning ON
            print(f"[FOG] ✓ AUTO FOG ENABLED - burst:{self.fog_burst_duration_s}s interval:{self.fog_interval_s}s")
            self.fog_last_burst_time = None  # Reset so first burst starts immediately
            print(f"[FOG]   First burst will start on next tick")
            self._set_status(f"Auto fog enabled: {self.fog_burst_duration_s}s burst every {self.fog_interval_s}s")
        elif not self.fog_enabled and was_enabled:
            # Turning OFF
            print(f"[FOG] ✗ AUTO FOG DISABLED")
            self._set_status("Auto fog disabled")
        
        self._save_fog_timer_config()

    def _on_fog_burst_changed(self, value: float) -> None:
        self.fog_burst_duration_s = float(value)
        self._save_fog_timer_config()

    def _on_fog_interval_changed(self, value: float) -> None:
        self.fog_interval_s = float(value)
        self._save_fog_timer_config()

    def _on_fog_manual_burst(self) -> None:
        """Trigger a manual fog burst (resets the automatic timer)."""
        self.fog_last_burst_time = time.monotonic()
        self._set_status(f"Manual fog burst ({self.fog_burst_duration_s:.1f}s).")

    # --------------------------- Motor camera ---------------------------

    def _maybe_start_motor_cam(self) -> None:
        if not self.motor_cam_enabled:
            return
        # Try to auto-pick index by role fingerprint (best effort).
        try:
            idx = probe_best_index_for_role(self.motor_cam_role, max_index=8, path=Path(self.camera_roles_file))
            if idx is not None and int(idx) != int(self.motor_cam_index):
                self.motor_cam_index = int(idx)
                if self._motor_cam_index_spin is not None:
                    self._motor_cam_index_spin.setValue(int(idx))
                if self._motor_cam_status_label is not None:
                    self._motor_cam_status_label.setText(f"roles: motor->index {int(idx)}")
        except Exception:
            pass
        self._start_motor_cam()

    def _start_motor_cam(self) -> None:
        if self._motor_cam_thread is not None:
            return
        if self._motor_cam_label is None:
            return

        w = int(self._motor_cam_label.width())
        h = int(self._motor_cam_label.height())
        self._motor_cam_thread = QThread(self)
        self._motor_cam_worker = MotorCamWorker(camera_index=int(self.motor_cam_index), width=w, height=h, fps=15.0)
        self._motor_cam_worker.rotate_deg = int(self.motor_cam_rotate)
        self._motor_cam_worker.flip = str(self.motor_cam_flip)
        self._motor_cam_worker.zoom = float(self.motor_cam_zoom)
        self._motor_cam_worker.pan_x = float(self.motor_cam_pan_x)
        self._motor_cam_worker.pan_y = float(self.motor_cam_pan_y)
        # These are stored in BASE coords (zoom/pan independent).
        self._motor_cam_worker.roi_a = self.motor_roi_a
        self._motor_cam_worker.roi_b = self.motor_roi_b
        self._motor_cam_worker.center_a = self.motor_center_a
        self._motor_cam_worker.center_b = self.motor_center_b
        self._motor_cam_worker.roi_pts_a = list(self.motor_roi_pts_a or [])
        self._motor_cam_worker.roi_pts_b = list(self.motor_roi_pts_b or [])
        self._motor_cam_worker.zero_pts_a = list(self.motor_zero_pts_a or [])
        self._motor_cam_worker.zero_pts_b = list(self.motor_zero_pts_b or [])
        self._motor_cam_worker.marker_h = int(self.motor_marker_h)
        self._motor_cam_worker.marker_tol = int(self.motor_marker_tol)
        self._motor_cam_worker.marker_s_min = int(self.motor_marker_smin)
        self._motor_cam_worker.marker_v_min = int(self.motor_marker_vmin)
        self._motor_cam_worker.moveToThread(self._motor_cam_thread)
        self._motor_cam_thread.started.connect(self._motor_cam_worker.start)
        self._motor_cam_thread.finished.connect(self._motor_cam_worker.deleteLater)
        self._motor_cam_worker.frame_ready.connect(self._on_motor_cam_frame)
        self._motor_cam_worker.metrics_ready.connect(self._on_motor_cam_metrics)
        self._motor_cam_worker.status.connect(self._on_motor_cam_status)
        self._motor_cam_thread.start()

    def _stop_motor_cam(self) -> None:
        try:
            if self._motor_cam_worker is not None:
                QTimer.singleShot(0, self._motor_cam_worker.stop)
        except Exception:
            pass
        try:
            if self._motor_cam_thread is not None:
                self._motor_cam_thread.quit()
                self._motor_cam_thread.wait(1200)
        except Exception:
            pass
        self._motor_cam_thread = None
        self._motor_cam_worker = None

    @Slot(object)
    def _on_motor_cam_frame(self, qimg) -> None:
        if self._motor_cam_label is None:
            return
        try:
            self._motor_cam_label.setPixmap(QPixmap.fromImage(qimg))
        except Exception:
            pass

    @Slot(str)
    def _on_motor_cam_status(self, s: str) -> None:
        # Keep printing for debugging, but also surface key info in the UI.
        try:
            print(str(s))
        except Exception:
            pass
        if self._motor_cam_hint_label is not None and isinstance(s, str) and "marker picked" in s.lower():
            self._motor_cam_hint_label.setText("Marker picked. If detection still says 'no marker', click again (different marker / lighting).")

    @Slot(object)
    def _on_motor_cam_metrics(self, metrics: object) -> None:
        if not isinstance(metrics, dict):
            return
        # Save latest mapping for disp<->base conversion.
        try:
            self._motor_last_map = metrics.get("map") if isinstance(metrics.get("map"), dict) else None
        except Exception:
            self._motor_last_map = None

        # One-time: if config was stored in old preview coords (320x180), convert to base coords now.
        try:
            if (not self._motor_legacy_converted) and self._motor_last_map is not None:
                m = self._motor_last_map
                out_w = int(m.get("out_w", 0))
                out_h = int(m.get("out_h", 0))
                base_w = int(m.get("base_w", 0))
                base_h = int(m.get("base_h", 0))
                if out_w > 0 and out_h > 0 and base_w > out_w + 20 and base_h > out_h + 20:
                    def _looks_disp_roi(roi):
                        if roi is None:
                            return False
                        x0, y0, x1, y1 = roi
                        return max(x0, x1) <= out_w and max(y0, y1) <= out_h

                    def _looks_disp_pt(pt):
                        if pt is None:
                            return False
                        x, y = pt
                        return x <= out_w and y <= out_h

                    changed = False
                    if _looks_disp_roi(self.motor_roi_a):
                        b = self._disp_rect_to_base(self.motor_roi_a)
                        if b is not None:
                            self.motor_roi_a = b
                            changed = True
                    if _looks_disp_roi(self.motor_roi_b):
                        b = self._disp_rect_to_base(self.motor_roi_b)
                        if b is not None:
                            self.motor_roi_b = b
                            changed = True
                    if _looks_disp_pt(self.motor_center_a):
                        p = self._disp_point_to_base(int(self.motor_center_a[0]), int(self.motor_center_a[1]))
                        if p is not None:
                            self.motor_center_a = p
                            changed = True
                    if _looks_disp_pt(self.motor_center_b):
                        p = self._disp_point_to_base(int(self.motor_center_b[0]), int(self.motor_center_b[1]))
                        if p is not None:
                            self.motor_center_b = p
                            changed = True
                    if changed and self._motor_cam_worker is not None:
                        self._motor_cam_worker.roi_a = self.motor_roi_a
                        self._motor_cam_worker.roi_b = self.motor_roi_b
                        self._motor_cam_worker.center_a = self.motor_center_a
                        self._motor_cam_worker.center_b = self.motor_center_b
                        self._save_motor_homing_config()
                self._motor_legacy_converted = True
        except Exception:
            self._motor_legacy_converted = True
        try:
            ma = metrics.get("a", {}) or {}
            mb = metrics.get("b", {}) or {}
            self._motor_found_a = bool(ma.get("found", False))
            self._motor_found_b = bool(mb.get("found", False))
            self._motor_angle_a = float(ma["angle"]) if ma.get("angle") is not None else None
            self._motor_angle_b = float(mb["angle"]) if mb.get("angle") is not None else None
            mk = metrics.get("marker") if isinstance(metrics.get("marker"), dict) else None
            if isinstance(mk, dict):
                mh = int(mk.get("h", self.motor_marker_h))
                mt = int(mk.get("tol", self.motor_marker_tol))
                ms = int(mk.get("smin", self.motor_marker_smin))
                mv = int(mk.get("vmin", self.motor_marker_vmin))
                if (mh, mt, ms, mv) != (self.motor_marker_h, self.motor_marker_tol, self.motor_marker_smin, self.motor_marker_vmin):
                    self.motor_marker_h, self.motor_marker_tol, self.motor_marker_smin, self.motor_marker_vmin = mh, mt, ms, mv
                    self._save_motor_homing_config()
            if self._motor_found_a and self._motor_angle_a is not None:
                self._motor_angle_a_last = float(self._motor_angle_a)
            if self._motor_found_b and self._motor_angle_b is not None:
                self._motor_angle_b_last = float(self._motor_angle_b)

            # Smooth angles (wrap-aware) to stabilize homing near the target.
            alpha = 0.25
            if self._motor_angle_a is not None:
                if self._motor_angle_a_filt is None:
                    self._motor_angle_a_filt = float(self._motor_angle_a)
                else:
                    d = self._wrap_deg180(float(self._motor_angle_a) - float(self._motor_angle_a_filt))
                    self._motor_angle_a_filt = float(self._wrap_deg180(float(self._motor_angle_a_filt) + alpha * d))
            if self._motor_angle_b is not None:
                if self._motor_angle_b_filt is None:
                    self._motor_angle_b_filt = float(self._motor_angle_b)
                else:
                    d = self._wrap_deg180(float(self._motor_angle_b) - float(self._motor_angle_b_filt))
                    self._motor_angle_b_filt = float(self._wrap_deg180(float(self._motor_angle_b_filt) + alpha * d))
        except Exception:
            self._motor_found_a = False
            self._motor_found_b = False
            self._motor_angle_a = None
            self._motor_angle_b = None

        if self._motor_angle_label_a is not None:
            if self._motor_found_a and self._motor_angle_a is not None:
                self._motor_angle_label_a.setText(f"M7: {self._motor_angle_a:+.1f}°")
            elif self._motor_found_a and self.motor_center_a is None:
                self._motor_angle_label_a.setText("M7: marker OK (set Center)")
            elif self._motor_found_a and self._motor_angle_a is None:
                self._motor_angle_label_a.setText("M7: marker OK (no angle)")
            else:
                self._motor_angle_label_a.setText("M7: no marker")
        if self._motor_angle_label_b is not None:
            if self._motor_found_b and self._motor_angle_b is not None:
                self._motor_angle_label_b.setText(f"M8: {self._motor_angle_b:+.1f}°")
            elif self._motor_found_b and self.motor_center_b is None:
                self._motor_angle_label_b.setText("M8: marker OK (set Center)")
            elif self._motor_found_b and self._motor_angle_b is None:
                self._motor_angle_label_b.setText("M8: marker OK (no angle)")
            else:
                self._motor_angle_label_b.setText("M8: no marker")

    def _restart_motor_cam(self) -> None:
        self._stop_motor_cam()
        if self.motor_cam_enabled:
            QTimer.singleShot(0, self._start_motor_cam)

    def _on_motor_cam_enable_changed(self, state: int) -> None:
        self.motor_cam_enabled = state == Qt.Checked
        self._save_motor_homing_config()
        self._restart_motor_cam()

    def _on_motor_cam_index_changed(self, value: int) -> None:
        self.motor_cam_index = int(value)
        self._save_motor_homing_config()
        self._restart_motor_cam()

    def _on_motor_cam_rotate_changed(self, text: str) -> None:
        try:
            self.motor_cam_rotate = int(str(text).strip())
        except Exception:
            self.motor_cam_rotate = 0
        if self._motor_cam_worker is not None:
            self._motor_cam_worker.rotate_deg = int(self.motor_cam_rotate)
        self._save_motor_homing_config()

    def _on_motor_cam_flip_changed(self, text: str) -> None:
        self.motor_cam_flip = str(text).strip().lower()
        if self._motor_cam_worker is not None:
            self._motor_cam_worker.flip = str(self.motor_cam_flip)
        self._save_motor_homing_config()

    def _on_motor_cam_zoom_changed(self, value: int) -> None:
        # value is 100..400 -> 1.0x..4.0x
        z = float(max(1.0, min(4.0, float(value) / 100.0)))
        self.motor_cam_zoom = z
        if self._motor_cam_zoom_label is not None:
            self._motor_cam_zoom_label.setText(f"{z:0.2f}x")
        if self._motor_cam_worker is not None:
            self._motor_cam_worker.zoom = float(z)
        self._save_motor_homing_config()

    def _on_motor_cam_pan_delta(self, dx_norm: float, dy_norm: float) -> None:
        # Accumulate normalized pan deltas and clamp to [-1, 1].
        try:
            self.motor_cam_pan_x = float(max(-1.0, min(1.0, float(self.motor_cam_pan_x) + float(dx_norm))))
            self.motor_cam_pan_y = float(max(-1.0, min(1.0, float(self.motor_cam_pan_y) + float(dy_norm))))
        except Exception:
            self.motor_cam_pan_x = 0.0
            self.motor_cam_pan_y = 0.0
        if self._motor_cam_worker is not None:
            self._motor_cam_worker.pan_x = float(self.motor_cam_pan_x)
            self._motor_cam_worker.pan_y = float(self.motor_cam_pan_y)
        self._save_motor_homing_config()

    def _on_motor_cam_pan_reset(self) -> None:
        self.motor_cam_pan_x = 0.0
        self.motor_cam_pan_y = 0.0
        if self._motor_cam_worker is not None:
            self._motor_cam_worker.pan_x = 0.0
            self._motor_cam_worker.pan_y = 0.0
        self._save_motor_homing_config()

    def _on_motor_cam_mode_changed(self, text: str) -> None:
        self._set_motor_cam_mode_from_text(text)

    def _set_motor_cam_mode_from_text(self, text: str) -> None:
        if self._motor_cam_label is None:
            return
        t = str(text).strip().lower()
        # Clear in-progress point captures when switching modes (avoid confusion).
        self._pts_roi_a = []
        self._pts_roi_b = []
        self._pts_zero_a = []
        self._pts_zero_b = []

        if t.startswith("view:"):
            self._motor_cam_mode = "pan"
            self._motor_cam_label.interaction_mode = "pan"
            try:
                self._motor_cam_label.setCursor(Qt.OpenHandCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("View mode: drag to pan. Double-click to re-center pan.")
            return

        if "m7" in t and "roi (drag" in t:
            self._motor_cam_mode = "roi_drag_a"
            self._motor_cam_label.interaction_mode = "roi"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M7 ROI: click-and-drag a rectangle around the green marker area, then release.")
            return
        if "m8" in t and "roi (drag" in t:
            self._motor_cam_mode = "roi_drag_b"
            self._motor_cam_label.interaction_mode = "roi"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M8 ROI: click-and-drag a rectangle around the green marker area, then release.")
            return

        if "m7" in t and "roi (3 click" in t:
            self._motor_cam_mode = "roi_pts_a"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M7 ROI: click 3 points around the green marker area.")
            return
        if "m8" in t and "roi (3 click" in t:
            self._motor_cam_mode = "roi_pts_b"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M8 ROI: click 3 points around the green marker area.")
            return

        if "m7" in t and "center" in t:
            self._motor_cam_mode = "center_a"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M7 center: click the motor rotation center point.")
            return
        if "m8" in t and "center" in t:
            self._motor_cam_mode = "center_b"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M8 center: click the motor rotation center point.")
            return

        if "m7" in t and "zero (3 click" in t:
            self._motor_cam_mode = "zero_pts_a"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M7 zero: move arm to home position, then click the green marker 3 times.")
            return
        if "m8" in t and "zero (3 click" in t:
            self._motor_cam_mode = "zero_pts_b"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M8 zero: move arm to home position, then click the green marker 3 times.")
            return

        if "marker color" in t:
            self._motor_cam_mode = "marker_pick"
            self._motor_cam_label.interaction_mode = "center"
            try:
                self._motor_cam_label.setCursor(Qt.CrossCursor)
            except Exception:
                pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("Marker color: click directly on the marker. This will auto-tune detection.")
            return

        # Fallback
        self._motor_cam_mode = "pan"
        self._motor_cam_label.interaction_mode = "pan"
        try:
            self._motor_cam_label.setCursor(Qt.OpenHandCursor)
        except Exception:
            pass

    def _on_motor_cam_cancel(self) -> None:
        # Clear any in-progress picks and return to Pan.
        self._pts_roi_a = []
        self._pts_roi_b = []
        self._pts_zero_a = []
        self._pts_zero_b = []
        if self._motor_cam_hint_label is not None:
            self._motor_cam_hint_label.setText("Cancelled. View mode: drag to pan.")
        if self._motor_cam_mode_combo is not None:
            self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")

    def _disp_point_to_base(self, x: int, y: int) -> Optional[Tuple[int, int]]:
        m = self._motor_last_map
        if not isinstance(m, dict):
            return None
        try:
            pad_x = int(m["pad_x"])
            pad_y = int(m["pad_y"])
            scaled_w = int(m["scaled_w"])
            scaled_h = int(m["scaled_h"])
            scale = float(m["scale"])
            crop_x = int(m["crop_x"])
            crop_y = int(m["crop_y"])
        except Exception:
            return None
        # Ignore clicks in the letterbox bars
        if x < pad_x or y < pad_y or x >= pad_x + scaled_w or y >= pad_y + scaled_h:
            return None
        cx = float(x - pad_x) / float(scale)
        cy = float(y - pad_y) / float(scale)
        bx = int(round(cx)) + crop_x
        by = int(round(cy)) + crop_y
        return (bx, by)

    def _disp_rect_to_base(self, roi: Tuple[int, int, int, int]) -> Optional[Tuple[int, int, int, int]]:
        x0, y0, x1, y1 = [int(v) for v in roi]
        p0 = self._disp_point_to_base(x0, y0)
        p1 = self._disp_point_to_base(x1, y1)
        if p0 is None or p1 is None:
            return None
        bx0 = int(min(p0[0], p1[0]))
        by0 = int(min(p0[1], p1[1]))
        bx1 = int(max(p0[0], p1[0]))
        by1 = int(max(p0[1], p1[1]))
        return (bx0, by0, bx1, by1)

    def _on_motor_cam_rect_defined(self, x0: int, y0: int, x1: int, y1: int) -> None:
        # Only applies in ROI drag modes.
        if self._motor_cam_mode not in ("roi_drag_a", "roi_drag_b"):
            return
        which = "a" if self._motor_cam_mode == "roi_drag_a" else "b"
        # Convert from preview coords -> base coords so it stays correct across zoom/pan.
        roi = self._disp_rect_to_base((int(x0), int(y0), int(x1), int(y1))) or (int(x0), int(y0), int(x1), int(y1))
        if which == "a":
            self.motor_roi_a = roi
            self.motor_roi_pts_a = []
            if self._motor_cam_worker is not None:
                self._motor_cam_worker.roi_a = roi
                self._motor_cam_worker.roi_pts_a = []
        else:
            self.motor_roi_b = roi
            self.motor_roi_pts_b = []
            if self._motor_cam_worker is not None:
                self._motor_cam_worker.roi_b = roi
                self._motor_cam_worker.roi_pts_b = []
        self._save_motor_homing_config()
        if self._motor_cam_hint_label is not None:
            self._motor_cam_hint_label.setText("ROI saved. Returning to View mode.")
        if self._motor_cam_mode_combo is not None:
            self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")

    def _on_motor_cam_point_clicked(self, x: int, y: int) -> None:
        base_pt = self._disp_point_to_base(int(x), int(y))
        if base_pt is None:
            # likely clicked in letterbox bar
            return
        pt = (int(base_pt[0]), int(base_pt[1]))

        if self._motor_cam_mode == "marker_pick":
            # Ask worker to sample HSV at this base coordinate on the next frame.
            if self._motor_cam_worker is not None:
                try:
                    self._motor_cam_worker._marker_pick_pt = pt  # intentional: lightweight request flag
                except Exception:
                    pass
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("Picking marker color… click again if needed.")
            # Return to view mode to avoid accidental extra picks.
            if self._motor_cam_mode_combo is not None:
                self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")
            return

        if self._motor_cam_mode == "center_b":
            self.motor_center_b = pt
            if self._motor_cam_worker is not None:
                self._motor_cam_worker.center_b = pt
            self._save_motor_homing_config()
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M8 center saved. Returning to View mode.")
            if self._motor_cam_mode_combo is not None:
                self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")
            return
        if self._motor_cam_mode == "center_a":
            self.motor_center_a = pt
            if self._motor_cam_worker is not None:
                self._motor_cam_worker.center_a = pt
            self._save_motor_homing_config()
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText("M7 center saved. Returning to View mode.")
            if self._motor_cam_mode_combo is not None:
                self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")
            return

        # 3-point capture flows (ROI and Zero), avoids precision dragging at high zoom.
        if self._motor_cam_mode in ("roi_pts_a", "roi_pts_b"):
            buf = self._pts_roi_b if self._motor_cam_mode == "roi_pts_b" else self._pts_roi_a
            buf.append(pt)
            # Show points immediately while picking
            if self._motor_cam_mode == "roi_pts_b":
                self.motor_roi_pts_b = list(buf[:3])
                if self._motor_cam_worker is not None:
                    self._motor_cam_worker.roi_pts_b = list(buf[:3])
            else:
                self.motor_roi_pts_a = list(buf[:3])
                if self._motor_cam_worker is not None:
                    self._motor_cam_worker.roi_pts_a = list(buf[:3])
            if self._motor_cam_hint_label is not None:
                which_lbl = "8" if self._motor_cam_mode == "roi_pts_b" else "7"
                self._motor_cam_hint_label.setText(f"Pick ROI pts {which_lbl}: {len(buf)}/3")
            if len(buf) >= 3:
                xs = [p[0] for p in buf[:3]]
                ys = [p[1] for p in buf[:3]]
                pad = 20
                roi = (min(xs) - pad, min(ys) - pad, max(xs) + pad, max(ys) + pad)
                if self._motor_cam_mode == "roi_pts_b":
                    self.motor_roi_b = roi
                    self.motor_roi_pts_b = list(buf[:3])
                    if self._motor_cam_worker is not None:
                        self._motor_cam_worker.roi_b = roi
                        self._motor_cam_worker.roi_pts_b = list(buf[:3])
                    self._pts_roi_b = []
                else:
                    self.motor_roi_a = roi
                    self.motor_roi_pts_a = list(buf[:3])
                    if self._motor_cam_worker is not None:
                        self._motor_cam_worker.roi_a = roi
                        self._motor_cam_worker.roi_pts_a = list(buf[:3])
                    self._pts_roi_a = []
                self._save_motor_homing_config()
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("ROI saved from 3 points. Returning to View mode.")
                if self._motor_cam_mode_combo is not None:
                    self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")
            return

        if self._motor_cam_mode in ("zero_pts_a", "zero_pts_b"):
            buf = self._pts_zero_b if self._motor_cam_mode == "zero_pts_b" else self._pts_zero_a
            buf.append(pt)
            # Show points immediately while picking
            if self._motor_cam_mode == "zero_pts_b":
                self.motor_zero_pts_b = list(buf[:3])
                if self._motor_cam_worker is not None:
                    self._motor_cam_worker.zero_pts_b = list(buf[:3])
            else:
                self.motor_zero_pts_a = list(buf[:3])
                if self._motor_cam_worker is not None:
                    self._motor_cam_worker.zero_pts_a = list(buf[:3])
            if self._motor_cam_hint_label is not None:
                which_lbl = "8" if self._motor_cam_mode == "zero_pts_b" else "7"
                self._motor_cam_hint_label.setText(f"Pick Zero pts {which_lbl}: {len(buf)}/3")
            if len(buf) >= 3:
                xs = [p[0] for p in buf[:3]]
                ys = [p[1] for p in buf[:3]]
                mx = float(sum(xs)) / 3.0
                my = float(sum(ys)) / 3.0
                if (self._motor_cam_mode == "zero_pts_b" and self.motor_center_b is None) or (self._motor_cam_mode == "zero_pts_a" and self.motor_center_a is None):
                    if self._motor_cam_hint_label is not None:
                        self._motor_cam_hint_label.setText("Set Center first, then pick Zero points.")
                    return
                if self._motor_cam_mode == "zero_pts_b":
                    cx, cy = self.motor_center_b
                    ang = float(math.degrees(math.atan2(my - float(cy), mx - float(cx))))
                    self.motor_zero_b = ang
                    self.motor_zero_pts_b = list(buf[:3])
                    if self._motor_cam_worker is not None:
                        self._motor_cam_worker.zero_pts_b = list(buf[:3])
                    self._pts_zero_b = []
                    if self._motor_cam_hint_label is not None:
                        self._motor_cam_hint_label.setText(f"M8: Zero saved at {ang:+.1f}°. Returning to View mode.")
                else:
                    cx, cy = self.motor_center_a
                    ang = float(math.degrees(math.atan2(my - float(cy), mx - float(cx))))
                    self.motor_zero_a = ang
                    self.motor_zero_pts_a = list(buf[:3])
                    if self._motor_cam_worker is not None:
                        self._motor_cam_worker.zero_pts_a = list(buf[:3])
                    self._pts_zero_a = []
                    if self._motor_cam_hint_label is not None:
                        self._motor_cam_hint_label.setText(f"M7: Zero saved at {ang:+.1f}°. Returning to View mode.")
                self._save_motor_homing_config()
                if self._motor_cam_mode_combo is not None:
                    self._motor_cam_mode_combo.setCurrentText("View: Pan / Drag")
            return

    def _on_motor_cam_calibrate_clicked(self) -> None:
        """
        Capture a single frame from the currently selected motor camera index and
        save a role fingerprint. This makes the motor cam robust to index swapping.
        """
        role = str(self.motor_cam_role or "motor").strip().lower()
        idx = int(self.motor_cam_index)
        roles_path = Path(self.camera_roles_file)
        if self._motor_cam_status_label is not None:
            self._motor_cam_status_label.setText(f"roles: calibrating '{role}' from index {idx}…")

        def worker() -> None:
            cap = None
            try:
                cap = cv2.VideoCapture(int(idx), cv2.CAP_ANY)
                if cap is None or not cap.isOpened():
                    raise RuntimeError("open failed")
                ok, frame = cap.read()
                if not ok or frame is None:
                    raise RuntimeError("read failed")
                h = dhash_hex_from_bgr(frame)
                save_role(role, h, index_hint=int(idx), path=roles_path)
                msg = f"roles: calibrated '{role}' index={idx} dhash={h}"
            except Exception as exc:
                msg = f"roles: calibrate failed ({exc})"
            finally:
                try:
                    if cap is not None:
                        cap.release()
                except Exception:
                    pass
            QTimer.singleShot(0, lambda: self._motor_cam_status_label.setText(msg) if self._motor_cam_status_label is not None else None)

        threading.Thread(target=worker, daemon=True).start()

    def _osc_note_incoming(self, msg: str, *, kind: str = "pattern") -> None:
        """Update OSC RX monitors in the UI."""
        self._osc_rx_count += 1
        k = str(kind or "").lower().strip()
        if k == "set":
            self._osc_rx_set_count += 1
            if self.osc_set_last_label is not None:
                self.osc_set_last_label.setText(f"{self._osc_rx_set_count}: {msg}")
        else:
            self._osc_rx_pattern_count += 1
            if self.osc_pattern_last_label is not None:
                self.osc_pattern_last_label.setText(f"{self._osc_rx_pattern_count}: {msg}")

    def _on_osc_pattern_received(self, n: int) -> None:
        """Handle /pattern N on the GUI thread (N is 1-based)."""
        n = int(n)
        self._osc_note_incoming(f"/pattern {n}", kind="pattern")
        idx = n - 1
        if idx < 0:
            return
        if idx >= len(self.patterns):
            self._set_status(f"OSC: /pattern {n} ignored (out of range).")
            return
        if not self.patterns[idx].is_defined():
            self._set_status(f"OSC: /pattern {n} ignored (slot undefined).")
            return
        self._on_activate_pattern(idx)

    def _on_osc_set_received(self, n: int) -> None:
        """Handle /set N (or /pattern_set N) on the GUI thread (N is 1-based)."""
        n = int(n)
        self._osc_note_incoming(f"/set {n}", kind="set")
        idx = n - 1
        if idx < 0:
            return
        if idx >= len(self.pattern_sets):
            self._set_status(f"OSC: /set {n} ignored (out of range).")
            return

        if not self.set_combo:
            self._set_status("OSC: /set ignored (UI not ready).")
            return

        # Select set by name (more robust than index if combo gets re-ordered).
        name = self.pattern_sets[idx].name
        self._last_selected_set_name = name
        self.set_combo.setCurrentText(name)
        self._on_load_set()

    def _on_osc_stop_received(self) -> None:
        """Handle /pattern 0 on the GUI thread."""
        self.active_pattern_index = None
        self._osc_note_incoming("/pattern 0 (stop)", kind="pattern")
        self._set_status("OSC: pattern stopped (/pattern 0).")

    def _on_osc_blackout_received(self) -> None:
        """Handle /blackout on the GUI thread."""
        self._osc_note_incoming("/blackout", kind="pattern")
        self._on_hard_reset_all()
        self._set_status("OSC: blackout (/blackout).")

    def _on_hard_reset_all(self) -> None:
        """
        Immediately stop all fixtures and send a black frame:
        - All channels modes set to 'off'
        - All sliders set to 0
        - All rates set to 0
        Patterns remain in memory but are no longer active until re‑activated.
        """
        # Clear current behaviours.
        for fs in self.fixtures:
            fs.ensure_defaults()
            for ch in range(1, fs.channel_count + 1):
                fs.slider_values[ch] = 0
                fs.modes[ch] = "off"
                fs.rates[ch] = 0.0

        # Deactivate any running pattern so the tick loop stops sending frames.
        self.active_pattern_index = None

        # Refresh DMX view for the currently selected fixture and send a black frame.
        # Selected index comes from the button group; default to 0 if unset.
        idx = self.fixture_buttons.checkedId()
        if idx < 0:
            idx = 0
        self._update_fixture_dmx_view(idx)

        frame = [0] * 512
        self._send_frame_with_ola_feedback(frame)

    def _build_fixture_editor(self, parent_layout: QVBoxLayout) -> None:
        group = QGroupBox("Fixture")
        parent_layout.addWidget(group)

        vbox = QVBoxLayout(group)

        # Fixture selector.
        fixture_row = QHBoxLayout()
        vbox.addLayout(fixture_row)
        fixture_row.addWidget(QLabel("Fixture"))

        self.fixture_buttons = QButtonGroup(self)
        for i in range(FIXTURE_COUNT):
            btn = QCheckBox(str(i + 1))
            btn.setAutoExclusive(True)
            btn.setChecked(i == 0)
            self.fixture_buttons.addButton(btn, i)
            fixture_row.addWidget(btn)
        self.fixture_buttons.idClicked.connect(self._on_fixture_selected)

        # Channel controls.
        self.channels_layout = QGridLayout()
        vbox.addLayout(self.channels_layout)
        self._rebuild_channel_controls(0)

    def _build_patterns_block(self, parent_layout: QVBoxLayout) -> None:
        # Wrap the patterns area in a scroll area so adding many slots does not
        # break the layout or push controls off-screen.
        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        parent_layout.addWidget(scroll)

        container = QWidget()
        scroll.setWidget(container)
        container_layout = QVBoxLayout(container)
        container_layout.setContentsMargins(0, 0, 0, 0)
        container_layout.setSpacing(8)

        group = QGroupBox("Patterns")
        container_layout.addWidget(group)
        vbox = QVBoxLayout(group)
        self.patterns_group = group
        self.patterns_layout = vbox

        self._rebuild_patterns_ui()

    def _clear_layout(self, layout) -> None:
        """
        Recursively remove all widgets and child layouts from a layout.
        This prevents old controls (like previous Add/Random rows) from
        lingering behind newly rebuilt pattern slots and overlapping.
        """
        while layout.count():
            item = layout.takeAt(0)
            child_widget = item.widget()
            child_layout = item.layout()
            if child_widget is not None:
                child_widget.deleteLater()
            elif child_layout is not None:
                self._clear_layout(child_layout)

    def _rebuild_patterns_ui(self) -> None:
        """Recreate the pattern slots and pattern-set controls."""
        if self.patterns_layout is None:
            return

        self._clear_layout(self.patterns_layout)
        self.pattern_rows = []

        for i, pattern in enumerate(self.patterns):
            slot_group = QGroupBox(f"Slot {i+1}")
            self.patterns_layout.addWidget(slot_group)
            gl = QGridLayout(slot_group)
            gl.setContentsMargins(8, 4, 8, 8)
            gl.setHorizontalSpacing(6)
            gl.setVerticalSpacing(4)

            name_edit = QLineEdit(pattern.name)
            name_edit.textChanged.connect(
                lambda text, idx=i: self._on_pattern_rename(idx, text)
            )
            gl.addWidget(QLabel("Name"), 0, 0)
            gl.addWidget(name_edit, 0, 1)

            store_btn = QPushButton("Store from current")
            store_btn.clicked.connect(lambda _=None, idx=i: self._on_store_pattern(idx))
            gl.addWidget(store_btn, 0, 2)

            act_btn = QPushButton("Activate")
            act_btn.clicked.connect(lambda _=None, idx=i: self._on_activate_pattern(idx))
            gl.addWidget(act_btn, 0, 3)

            gl.addWidget(QLabel(f"OSC: /pattern {i+1}"), 0, 4)

            # Lamps + mirrors + motors checkboxes (fixtures 1-8 only, not fog).
            lamps_row = QHBoxLayout()
            gl.addLayout(lamps_row, 1, 0, 1, 5)
            lamps_row.addWidget(QLabel("Lamps"))
            for f_idx in range(MOVING_HEAD_COUNT):
                cb = QCheckBox(str(f_idx + 1))
                cb.setChecked(pattern.active_fixtures[f_idx])
                cb.stateChanged.connect(
                    lambda _state, p=i, f=f_idx, cb_ref=cb: self._on_pattern_fixture_toggle(
                        p, f, cb_ref.isChecked()
                    )
                )
                lamps_row.addWidget(cb)

            lamps_row.addSpacing(16)
            lamps_row.addWidget(QLabel("Mirrors"))
            for h_idx in range(HERO_COUNT):
                f_idx = MOVING_HEAD_COUNT + h_idx
                cb = QCheckBox(str(f_idx + 1))
                if f_idx < len(pattern.active_fixtures):
                    cb.setChecked(pattern.active_fixtures[f_idx])
                cb.stateChanged.connect(
                    lambda _state, p=i, f=f_idx, cb_ref=cb: self._on_pattern_fixture_toggle(
                        p, f, cb_ref.isChecked()
                    )
                )
                lamps_row.addWidget(cb)

            if MBM_COUNT > 0:
                lamps_row.addSpacing(16)
                lamps_row.addWidget(QLabel("Motors"))
                for m_idx in range(MBM_COUNT):
                    f_idx = MOVING_HEAD_COUNT + HERO_COUNT + m_idx
                    cb = QCheckBox(str(f_idx + 1))
                    if f_idx < len(pattern.active_fixtures):
                        cb.setChecked(pattern.active_fixtures[f_idx])
                    cb.stateChanged.connect(
                        lambda _state, p=i, f=f_idx, cb_ref=cb: self._on_pattern_fixture_toggle(
                            p, f, cb_ref.isChecked()
                        )
                    )
                    lamps_row.addWidget(cb)

            # Fog (fixture 9) is NOT included in patterns/sets

            self.pattern_rows.append((name_edit, store_btn, act_btn))

        # Lock button to prevent accidental overwriting.
        lock_row = QHBoxLayout()
        self.patterns_layout.addLayout(lock_row)
        self.patterns_lock_btn = QPushButton("🔓 Unlocked (editing allowed)")
        self.patterns_lock_btn.setCheckable(True)
        self.patterns_lock_btn.setChecked(self.patterns_locked)
        self.patterns_lock_btn.clicked.connect(self._on_toggle_patterns_lock)
        self._update_lock_button_style()
        lock_row.addWidget(self.patterns_lock_btn)
        lock_row.addStretch(1)

        # Add / Random pattern controls.
        controls_row = QHBoxLayout()
        self.patterns_layout.addLayout(controls_row)
        add_btn = QPushButton("Add pattern")
        add_btn.clicked.connect(self._on_add_pattern)
        rand_btn = QPushButton("Random pattern")
        rand_btn.clicked.connect(self._on_random_pattern)
        controls_row.addWidget(add_btn)
        controls_row.addWidget(rand_btn)
        controls_row.addStretch(1)

        # Pattern sets block.
        sets_group = QGroupBox("Pattern sets")
        self.patterns_layout.addWidget(sets_group)
        sets_layout = QGridLayout(sets_group)

        default_name = self._last_selected_set_name or "Set 1"
        self.set_name_edit = QLineEdit(default_name)
        sets_layout.addWidget(QLabel("Name"), 0, 0)
        sets_layout.addWidget(self.set_name_edit, 0, 1)
        store_set_btn = QPushButton("Store set from current")
        store_set_btn.clicked.connect(self._on_store_set)
        sets_layout.addWidget(store_set_btn, 0, 2)

        sets_layout.addWidget(QLabel("Load"), 1, 0)
        self.set_combo = QComboBox()
        self._refresh_set_combo()
        if self._last_selected_set_name:
            self.set_combo.setCurrentText(self._last_selected_set_name)
        sets_layout.addWidget(self.set_combo, 1, 1)
        load_set_btn = QPushButton("Load set")
        load_set_btn.clicked.connect(self._on_load_set)
        sets_layout.addWidget(load_set_btn, 1, 2)

        delete_set_btn = QPushButton("Delete set")
        delete_set_btn.clicked.connect(self._on_delete_set)
        sets_layout.addWidget(delete_set_btn, 2, 0, 1, 3)

    # --------------------------- Callbacks / logic ---------------------------

    def _on_universe_changed(self, value: int) -> None:
        self.universe = value

    def _on_osc_port_changed(self, value: int) -> None:
        self.osc_port = value

    def _on_start_osc_clicked(self) -> None:
        if self._osc_server is not None:
            self._set_status(f"OSC already running on port {self.osc_port}.")
            return

        dispatcher = Dispatcher()
        dispatcher.map("/pattern", self._osc_pattern_handler)
        dispatcher.map("/pattern_random", self._osc_random_handler)
        dispatcher.map("/pattern/random", self._osc_random_handler)
        dispatcher.map("/set", self._osc_set_handler)
        dispatcher.map("/pattern_set", self._osc_set_handler)
        dispatcher.map("/pattern/set", self._osc_set_handler)
        dispatcher.map("/blackout", self._osc_blackout_handler)
        dispatcher.map("/link/enable", self._osc_link_enable)
        dispatcher.map("/link/tempo", self._osc_link_tempo)
        dispatcher.map("/link/beat", self._osc_link_beat)

        try:
            server = ThreadingOSCUDPServer(("0.0.0.0", self.osc_port), dispatcher)
        except OSError as exc:
            self._set_status(f"OSC start failed: {exc}")
            return

        self._osc_server = server

        def serve() -> None:
            server.serve_forever()

        thread = threading.Thread(target=serve, daemon=True)
        thread.start()
        self._set_status(f"OSC listening on port {self.osc_port}.")

    def _make_fixture_addr_callback(self, index: int):
        def _cb(value: int) -> None:
            self.fixtures[index].start_address = value
            self._validate_fixture_address_ranges()

        return _cb

    def _validate_fixture_address_ranges(self) -> None:
        """
        Validate DMX address ranges for all fixtures:
        - Detect overlaps (fog overwriting other fixtures, etc.)
        - Detect out-of-range spans beyond 512
        Highlights offending address spinboxes and updates the status label.
        """
        ranges = []
        for i, fs in enumerate(self.fixtures):
            start = int(fs.start_address)
            end = int(fs.start_address) + int(fs.channel_count) - 1
            ranges.append((i, start, end))

        bad_indices: set[int] = set()
        messages: list[str] = []

        # Out-of-range check
        for i, start, end in ranges:
            if start < 1 or start > 512:
                bad_indices.add(i)
                messages.append(f"f{i+1} start {start} is out of range (1..512)")
            if end > 512:
                bad_indices.add(i)
                messages.append(f"f{i+1} span {start}-{end} exceeds 512")

        # Overlap check (pairwise)
        for a in range(len(ranges)):
            i1, s1, e1 = ranges[a]
            for b in range(a + 1, len(ranges)):
                i2, s2, e2 = ranges[b]
                if s1 <= e2 and s2 <= e1:
                    bad_indices.add(i1)
                    bad_indices.add(i2)
                    ov_s = max(s1, s2)
                    ov_e = min(e1, e2)
                    messages.append(f"Overlap f{i1+1}({s1}-{e1}) with f{i2+1}({s2}-{e2}) at {ov_s}-{ov_e}")

        # Highlight UI widgets
        if hasattr(self, "fixture_addr_edits"):
            for i, edit in enumerate(self.fixture_addr_edits):
                if i in bad_indices:
                    edit.setStyleSheet("QSpinBox { border: 2px solid #ff3b30; }")
                else:
                    edit.setStyleSheet("")

        if messages:
            # Keep message short but informative.
            self._set_status("DMX address warning: " + " | ".join(messages[:2]))
        else:
            # Only reset to a benign status if we are not currently showing an error.
            # Avoid spamming status while user is working.
            current = self.ola_status_label.text()
            if "DMX address warning" in current:
                self._set_status("OK")

    def _rebuild_channel_controls(self, fixture_index: int) -> None:
        # Clear layout.
        while self.channels_layout.count():
            item = self.channels_layout.takeAt(0)
            if w := item.widget():
                w.deleteLater()

        fs = self.fixtures[fixture_index]
        if fixture_index < MOVING_HEAD_COUNT:
            channels = self.moving_head_def["channels"]
        elif fixture_index < MOVING_HEAD_COUNT + HERO_COUNT:
            channels = self.hero_def["channels"]
        elif fixture_index < MOVING_HEAD_COUNT + HERO_COUNT + MBM_COUNT:
            channels = self.mbm_def["channels"]
        else:
            channels = self.fog_def["channels"]

        headers = ["Ch", "Name", "Min", "Max", "Ctl", "DMX", "Mode", "Rate"]
        for col, text in enumerate(headers):
            self.channels_layout.addWidget(QLabel(text), 0, col)

        self.channel_widgets = {}

        for row_idx, ch in enumerate(sorted(channels.keys()), start=1):
            name = channels[ch].get("name", "")
            self.channels_layout.addWidget(QLabel(str(ch)), row_idx, 0)
            self.channels_layout.addWidget(QLabel(name), row_idx, 1)

            min_spin = QSpinBox()
            min_spin.setRange(0, 255)
            min_spin.setValue(fs.min_values.get(ch, 0))
            max_spin = QSpinBox()
            max_spin.setRange(0, 255)
            max_spin.setValue(fs.max_values.get(ch, 255))

            slider = QSlider(Qt.Horizontal)
            slider.setRange(0, 255)
            slider.setValue(fs.slider_values.get(ch, 0))
            slider.setMaximumWidth(120)

            # Precise numeric control for the same value (0–255).
            ctl_spin = QSpinBox()
            ctl_spin.setRange(0, 255)
            ctl_spin.setValue(fs.slider_values.get(ch, 0))
            ctl_spin.setMaximumWidth(60)

            ctl_widget = QWidget()
            ctl_layout = QHBoxLayout(ctl_widget)
            ctl_layout.setContentsMargins(0, 0, 0, 0)
            ctl_layout.setSpacing(4)
            ctl_layout.addWidget(slider)
            ctl_layout.addWidget(ctl_spin)

            dmx_label = QLabel("0")

            mode_combo = QComboBox()
            mode_combo.addItems(["off", "static", "sine", "square", "saw"])
            mode_combo.setCurrentText(fs.modes.get(ch, "static"))

            rate_spin = QDoubleSpinBox()
            rate_spin.setDecimals(3)
            rate_spin.setSingleStep(0.001)
            rate_spin.setRange(0.0, 20.0)
            rate_spin.setValue(float(fs.rates.get(ch, 0.0)))

            self.channels_layout.addWidget(min_spin, row_idx, 2)
            self.channels_layout.addWidget(max_spin, row_idx, 3)
            self.channels_layout.addWidget(ctl_widget, row_idx, 4)
            self.channels_layout.addWidget(dmx_label, row_idx, 5)
            self.channels_layout.addWidget(mode_combo, row_idx, 6)
            self.channels_layout.addWidget(rate_spin, row_idx, 7)

            self.channel_widgets[ch] = (
                min_spin,
                max_spin,
                slider,
                ctl_spin,
                dmx_label,
                mode_combo,
                rate_spin,
            )

            # Wiring.
            min_spin.valueChanged.connect(
                lambda val, ch_num=ch: self._on_min_changed(fixture_index, ch_num, val)
            )
            max_spin.valueChanged.connect(
                lambda val, ch_num=ch: self._on_max_changed(fixture_index, ch_num, val)
            )
            def _on_slider(val: int, ch_num=ch, f_idx=fixture_index, spin_ref=ctl_spin) -> None:
                # Keep spinbox in sync and drive behaviour from the slider.
                spin_ref.setValue(val)
                self._on_slider_changed(f_idx, ch_num, val)

            slider.valueChanged.connect(_on_slider)

            # When the spinbox changes, update the slider; the slider callback
            # then updates the model/UI. This avoids double-calling.
            ctl_spin.valueChanged.connect(
                lambda val, slider_ref=slider: slider_ref.setValue(val)
            )
            mode_combo.currentTextChanged.connect(
                lambda text, ch_num=ch: self._on_mode_changed(fixture_index, ch_num, text)
            )
            rate_spin.valueChanged.connect(
                lambda val, ch_num=ch: self._on_rate_changed(fixture_index, ch_num, float(val))
            )

        # Keep all channel rows visually anchored to the top, regardless of
        # how many channels this fixture has, and let extra space grow below.
        self.channels_layout.setRowStretch(len(channels) + 1, 1)
        self._update_fixture_dmx_view(fixture_index)

    def _on_fixture_selected(self, fixture_index: int) -> None:
        self._rebuild_channel_controls(fixture_index)

    def _on_min_changed(self, f_idx: int, ch: int, val: int) -> None:
        self.fixtures[f_idx].min_values[ch] = val
        self._update_fixture_dmx_view(f_idx)
        self._send_snapshot()

    def _on_max_changed(self, f_idx: int, ch: int, val: int) -> None:
        self.fixtures[f_idx].max_values[ch] = val
        self._update_fixture_dmx_view(f_idx)
        self._send_snapshot()

    def _on_slider_changed(self, f_idx: int, ch: int, val: int) -> None:
        self.fixtures[f_idx].slider_values[ch] = val
        self._update_fixture_dmx_view(f_idx)
        self._send_snapshot()

    def _on_mode_changed(self, f_idx: int, ch: int, text: str) -> None:
        self.fixtures[f_idx].modes[ch] = text
        self._update_fixture_dmx_view(f_idx)
        self._send_snapshot()

    def _on_rate_changed(self, f_idx: int, ch: int, val: int) -> None:
        self.fixtures[f_idx].rates[ch] = float(val)
        self._update_fixture_dmx_view(f_idx)
        self._send_snapshot()

    def _current_behaviour_time(self) -> float:
        """
        Time base for all behaviours (LFOs, etc.).
        If Link sync is enabled, derive time from the last received
        tempo/beat so that animation is phase-locked to the Link grid.
        Otherwise, fall back to wall-clock time.
        """
        now = time.monotonic()
        if (
            self.link_enabled
            and self.link_tempo_bpm > 0.0
            and self._link_last_update_monotonic is not None
        ):
            # How many beats have elapsed since the last Link update?
            beats_since = (now - self._link_last_update_monotonic) * (
                self.link_tempo_bpm / 60.0
            )
            beat_pos = self.link_beat + beats_since
            # Convert beats back to seconds at current tempo.
            return beat_pos * 60.0 / self.link_tempo_bpm
        return now

    def _update_fixture_dmx_view(self, fixture_index: int) -> None:
        fs = self.fixtures[fixture_index]
        values = fs.build_channels(self._current_behaviour_time())
        for ch, v in enumerate(values, start=1):
            widgets = self.channel_widgets.get(ch)
            if not widgets:
                continue
            _, _, slider, ctl_spin, dmx_label, _, _ = widgets
            # Keep Ctl widgets in sync with the underlying behaviour value.
            if slider.value() != fs.slider_values.get(ch, 0):
                slider.setValue(fs.slider_values.get(ch, 0))
            if ctl_spin.value() != fs.slider_values.get(ch, 0):
                ctl_spin.setValue(fs.slider_values.get(ch, 0))
            dmx_label.setText(str(v))

    def _send_snapshot(self) -> None:
        """
        Send one DMX frame built from the current fixture states.
        If a pattern is currently active, apply its active_fixtures mask so
        that editing fixtures outside the pattern does not cause flicker.
        """
        frame = self._build_universe_frame()
        if self.active_pattern_index is not None:
            pattern = self.patterns[self.active_pattern_index]
            if pattern.is_defined():
                frame = self._apply_active_mask(frame, pattern.active_fixtures)
        frame = self._apply_motor_homing_overrides(frame)
        self._send_frame_with_ola_feedback(frame)

    def _set_status(self, text: str) -> None:
        self.ola_status_label.setText(f"Status: {text}")

    # OLA helpers ------------------------------------------------------------

    def _on_check_ola(self) -> None:
        try:
            wrapper = ClientWrapper()
            _ = wrapper.Client()
        except OLADNotRunningException:
            self._set_status("OLAD not running on localhost:9010.")
            return
        except Exception as exc:
            self._set_status(f"OLA error: {exc}")
            return
        self._set_status(f"Connected to OLAD. Universe {self.universe}.")

    def _on_open_ola_ui(self) -> None:
        try:
            webbrowser.open("http://localhost:9090")
        except Exception:
            self._set_status("Could not open browser. Visit http://localhost:9090.")

    def _run_ola_service_cmd(self, args: list, label: str) -> None:
        try:
            result = subprocess.run(
                args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
            )
        except FileNotFoundError:
            self._set_status(f"{label}: command not found (brew?).")
            return
        if result.returncode == 0:
            self._set_status(f"{label} succeeded.")
        else:
            self._set_status(
                f"{label} failed ({result.returncode}): {result.stderr.strip()}"
            )

    def _on_start_ola(self) -> None:
        self._run_ola_service_cmd(["brew", "services", "start", "ola"], "Start OLA")

    def _on_stop_ola(self) -> None:
        self._run_ola_service_cmd(["brew", "services", "stop", "ola"], "Stop OLA")

    def _on_restart_ola(self) -> None:
        self._run_ola_service_cmd(["brew", "services", "restart", "ola"], "Restart OLA")

    # Patterns
    def _on_pattern_rename(self, idx: int, text: str) -> None:
        self.patterns[idx].name = text

    def _on_toggle_patterns_lock(self) -> None:
        """Toggle the global patterns lock."""
        self.patterns_locked = not self.patterns_locked
        self._update_lock_button_style()
        status = "locked 🔒" if self.patterns_locked else "unlocked 🔓"
        self._set_status(f"Patterns {status}")

    def _update_lock_button_style(self) -> None:
        """Update the lock button text and style based on lock state."""
        if self.patterns_lock_btn is None:
            return
        
        if self.patterns_locked:
            self.patterns_lock_btn.setText("🔒 Locked (read-only)")
            self.patterns_lock_btn.setStyleSheet("""
                QPushButton {
                    background-color: #d32f2f;
                    color: white;
                    font-weight: bold;
                    padding: 8px;
                }
                QPushButton:hover {
                    background-color: #f44336;
                }
            """)
        else:
            self.patterns_lock_btn.setText("🔓 Unlocked (editing allowed)")
            self.patterns_lock_btn.setStyleSheet("""
                QPushButton {
                    background-color: #388e3c;
                    color: white;
                    font-weight: bold;
                    padding: 8px;
                }
                QPushButton:hover {
                    background-color: #4caf50;
                }
            """)

    def _on_store_pattern(self, idx: int) -> None:
        # Check if patterns are locked
        if self.patterns_locked:
            self._set_status("⚠️  Patterns are locked! Unlock to edit.")
            return
        
        # Deep copy of fixture states (only fixtures 1-8, not fog) so each pattern remembers its behaviours.
        snapshot = [FixtureState(
            start_address=fs.start_address,
            channel_count=fs.channel_count,
            min_values=dict(fs.min_values),
            max_values=dict(fs.max_values),
            slider_values=dict(fs.slider_values),
            modes=dict(fs.modes),
            rates=dict(fs.rates),
            phases=dict(fs.phases),
        ) for fs in self.fixtures[:PATTERN_FIXTURE_COUNT]]
        self.patterns[idx].fixtures_state = snapshot
        self.active_pattern_index = idx
        self._set_status(f"✓ Pattern {idx+1} stored")

    def _on_activate_pattern(self, idx: int) -> None:
        pattern = self.patterns[idx]
        if not pattern.is_defined():
            return
        # Keep a reference to current fixtures so we can pad/truncate if the stored pattern
        # was created with a different PATTERN_FIXTURE_COUNT.
        prev_fixtures = self.fixtures[:PATTERN_FIXTURE_COUNT]
        # Restore fixture behaviours from this pattern (only fixtures 1-8, not fog).
        if pattern.fixtures_state:
            restored = [
                FixtureState(
                    start_address=fs.start_address,
                    channel_count=fs.channel_count,
                    min_values=dict(fs.min_values),
                    max_values=dict(fs.max_values),
                    slider_values=dict(fs.slider_values),
                    modes=dict(fs.modes),
                    rates=dict(fs.rates),
                    phases=dict(fs.phases),
                )
                for fs in pattern.fixtures_state
            ]
            # Pad/truncate to current PATTERN_FIXTURE_COUNT to avoid index mismatches elsewhere in the UI.
            if len(restored) < PATTERN_FIXTURE_COUNT:
                tail = prev_fixtures[len(restored):]
                restored.extend(
                    FixtureState(
                        start_address=fs.start_address,
                        channel_count=fs.channel_count,
                        min_values=dict(fs.min_values),
                        max_values=dict(fs.max_values),
                        slider_values=dict(fs.slider_values),
                        modes=dict(fs.modes),
                        rates=dict(fs.rates),
                        phases=dict(fs.phases),
                    )
                    for fs in tail
                )
            elif len(restored) > PATTERN_FIXTURE_COUNT:
                restored = restored[:PATTERN_FIXTURE_COUNT]
            # Replace fixtures 1-8, keep fixture 9 (fog) unchanged.
            self.fixtures[:PATTERN_FIXTURE_COUNT] = restored
        self.active_pattern_index = idx
        self._set_status(f"Activated pattern {idx+1}: {pattern.name}")
        # Send immediately for responsiveness (tick will continue streaming)
        self._send_snapshot()

    def _on_pattern_fixture_toggle(self, p_idx: int, f_idx: int, active: bool) -> None:
        self.patterns[p_idx].active_fixtures[f_idx] = active

    # OSC handlers -----------------------------------------------------------

    def _osc_pattern_handler(self, _addr: str, *args) -> None:
        """Handle /pattern N messages from OSC."""
        if not self.external_osc_enabled:
            return
        if not args:
            return
        try:
            idx = int(args[0]) - 1
        except (TypeError, ValueError):
            return
        if idx < 0:
            print("[OSC IN] /pattern 0 -> stop")
            self.osc_stop_received.emit()
            return
        if 0 <= idx < len(self.patterns):
            n = idx + 1
            print(f"[OSC IN] /pattern {n}")
            self.osc_pattern_received.emit(n)
            return

        # Out of range
        n = idx + 1
        print(f"[OSC IN] /pattern {n} (out of range)")
        # UI update must be on GUI thread; reuse signal path by emitting then range-checking there.
        self.osc_pattern_received.emit(n)

    def _osc_set_handler(self, _addr: str, *args) -> None:
        """Handle /set N or /pattern_set N messages from OSC (N is 1-based)."""
        if not self.external_osc_enabled:
            return
        if not args:
            return
        try:
            idx = int(args[0]) - 1
        except (TypeError, ValueError):
            return

        n = idx + 1
        if idx < 0:
            print(f"[OSC IN] {_addr} {n} (ignored)")
            return

        print(f"[OSC IN] {_addr} {n}")
        self.osc_set_received.emit(n)

    def _osc_random_handler(self, _addr: str, *_args) -> None:
        """Handle /pattern_random or /pattern/random messages."""
        if not self.external_osc_enabled:
            return
        QTimer.singleShot(0, self._on_random_pattern)

    def _osc_blackout_handler(self, _addr: str, *_args) -> None:
        """Handle /blackout messages from OSC (hard reset: all fixtures off)."""
        if not self.external_osc_enabled:
            return
        print("[OSC IN] /blackout")
        self.osc_blackout_received.emit()

    # Link-style tempo / beat sync over OSC -------------------------------

    def _osc_link_enable(self, _addr: str, *args) -> None:
        """Handle /link/enable <0|1> from Max/Link bridge."""
        if not args:
            return
        try:
            enabled = bool(int(args[0]))
        except (TypeError, ValueError):
            return

        def apply() -> None:
            self.link_enabled = enabled

        QTimer.singleShot(0, apply)

    def _osc_link_tempo(self, _addr: str, *args) -> None:
        """Handle /link/tempo <float bpm>."""
        if not args:
            return
        try:
            tempo = float(args[0])
        except (TypeError, ValueError):
            return

        def apply() -> None:
            if tempo > 0.0:
                self.link_tempo_bpm = tempo

        QTimer.singleShot(0, apply)

    def _osc_link_beat(self, _addr: str, *args) -> None:
        """Handle /link/beat <float beat_position>."""
        if not args:
            return
        try:
            beat = float(args[0])
        except (TypeError, ValueError):
            return

        def apply() -> None:
            self.link_beat = beat
            self._link_last_update_monotonic = time.monotonic()

        QTimer.singleShot(0, apply)

    def _on_add_pattern(self) -> None:
        """Append a new empty pattern slot and rebuild the patterns UI."""
        new_index = len(self.patterns) + 1
        self.patterns.append(PatternSlot(name=f"Pattern {new_index}"))
        self._rebuild_patterns_ui()

    def _on_random_pattern(self) -> None:
        """Activate a random defined pattern."""
        defined = [i for i, p in enumerate(self.patterns) if p.is_defined()]
        if not defined:
            return
        idx = random.choice(defined)
        self._on_activate_pattern(idx)

    # DMX frame + tick
    def _build_universe_frame(self) -> List[int]:
        frame = [0] * 512
        t = self._current_behaviour_time()
        for fs in self.fixtures:
            values = fs.build_channels(t)
            start = fs.start_address - 1
            for i, val in enumerate(values):
                idx = start + i
                if 0 <= idx < 512:
                    frame[idx] = val
        return frame

    def _apply_active_mask(self, frame: List[int], active_fixtures: List[bool]) -> List[int]:
        """
        Zero-out channels for fixtures that are inactive in the current pattern.
        This mirrors the behaviour of the Tk controller and avoids flicker when
        editing fixtures that are not part of the active pattern.
        """
        masked = list(frame)
        for idx, fs in enumerate(self.fixtures):
            if idx >= len(active_fixtures):
                continue
            if active_fixtures[idx]:
                continue
            start = fs.start_address - 1
            end = start + fs.channel_count
            for ch in range(start, min(end, 512)):
                masked[ch] = 0
        return masked

    @staticmethod
    def _wrap_deg180(deg: float) -> float:
        # Wrap angle to [-180, 180)
        x = float(deg)
        x = (x + 180.0) % 360.0 - 180.0
        return x

    def _motor_fixture_indices(self) -> Tuple[int, int]:
        # MBM fixtures are after moving heads + heroes. In 1-based terms, these are typically fixtures 7 and 8.
        a = MOVING_HEAD_COUNT + HERO_COUNT + 0
        b = MOVING_HEAD_COUNT + HERO_COUNT + 1
        return a, b

    def _motor_cmd_from_error(self, err_deg: float, *, invert: bool) -> int:
        """
        Convert angle error into DMX command for MBM40D:
        1..127 CW, 128 stop, 129..255 CCW.
        """
        e = float(err_deg)
        if invert:
            e = -e
        ae = abs(e)
        # Simple speed controller (slow near target)
        if ae > 25.0:
            speed = 0.55
        elif ae > 8.0:
            speed = 0.28
        else:
            speed = 0.08
        if e > 0.0:
            # CW: 1..127
            if bool(self.motor_low_range_speed_reversed):
                # Reversed speed response: smaller = faster (e.g. 14 fast, 67 slow)
                return int(max(1, min(127, round(127 - speed * 126))))
            return int(max(1, min(127, round(1 + speed * 126))))
        else:
            # CCW: 129..255
            return int(max(129, min(255, round(129 + speed * 126))))

    def _apply_motor_homing_overrides(self, frame: List[int]) -> List[int]:
        """
        If homing is active, override the MBM rotation channel value for fixtures 7/8.
        This does NOT change any other fixture/channels.
        """
        a_idx, b_idx = self._motor_fixture_indices()
        out = list(frame)

        def _apply_one(which: str, fixture_idx: int, active: bool, angle: Optional[float], zero: Optional[float], invert: bool) -> None:
            if not active:
                return
            if angle is None or zero is None:
                return
            now = time.monotonic()
            # If we just completed homing, hold STOP for a short time to prevent chatter.
            if which == "a" and now < float(self._motor_stop_hold_until_a):
                out[self.fixtures[fixture_idx].start_address - 1] = 128
                return
            if which == "b" and now < float(self._motor_stop_hold_until_b):
                out[self.fixtures[fixture_idx].start_address - 1] = 128
                return
            err = self._wrap_deg180(float(zero) - float(angle))
            # Apply invert at the error level so direction logic is consistent.
            if invert:
                err = -err

            # Direction-reversal protection:
            # - If we'd reverse direction for a small correction, prefer a full wrap-around in the same direction.
            # - Otherwise, stop briefly before reversing to avoid motor stall/freeze.
            last_dir = self._motor_last_dir_a if which == "a" else self._motor_last_dir_b
            block_until = self._motor_reverse_block_until_a if which == "a" else self._motor_reverse_block_until_b
            desired_dir = 0
            if abs(err) > 1e-6:
                desired_dir = 1 if err > 0 else -1

            if last_dir != 0 and desired_dir != 0 and desired_dir != last_dir:
                # Prefer wrap-around (same direction) when reversal would be small.
                if abs(err) < float(self.motor_wrap_prefer_deg):
                    if last_dir > 0 and err < 0:
                        err = err + 360.0
                    elif last_dir < 0 and err > 0:
                        err = err - 360.0
                    desired_dir = last_dir
                else:
                    # Stop dwell before allowing reversal.
                    if now < float(block_until):
                        out[self.fixtures[fixture_idx].start_address - 1] = 128
                        return
                    dwell = float(max(0.05, min(1.0, self.motor_reverse_stop_dwell_s)))
                    if which == "a":
                        self._motor_reverse_block_until_a = now + dwell
                    else:
                        self._motor_reverse_block_until_b = now + dwell
                    out[self.fixtures[fixture_idx].start_address - 1] = 128
                    return

            tol = float(self.motor_tol_deg)
            # Require consecutive "within tolerance" frames before stopping (debounce).
            if abs(err) <= tol:
                if which == "a":
                    self._motor_within_a = int(self._motor_within_a) + 1
                    if self._motor_within_a >= 3:
                        out[self.fixtures[fixture_idx].start_address - 1] = 128
                        self._motor_homing_a = False
                        self._motor_within_a = 0
                        self._motor_stop_hold_until_a = now + 0.6
                        self._motor_last_dir_a = 0
                        return
                else:
                    self._motor_within_b = int(self._motor_within_b) + 1
                    if self._motor_within_b >= 3:
                        out[self.fixtures[fixture_idx].start_address - 1] = 128
                        self._motor_homing_b = False
                        self._motor_within_b = 0
                        self._motor_stop_hold_until_b = now + 0.6
                        self._motor_last_dir_b = 0
                        return
            else:
                if which == "a":
                    self._motor_within_a = 0
                else:
                    self._motor_within_b = 0
            # cmd builder expects non-inverted error now
            cmd = self._motor_cmd_from_error(err, invert=False)
            out[self.fixtures[fixture_idx].start_address - 1] = int(cmd)
            # Track last commanded direction for reversal protection
            if which == "a":
                self._motor_last_dir_a = 1 if 0 < int(cmd) < 128 else (-1 if int(cmd) > 128 else 0)
            else:
                self._motor_last_dir_b = 1 if 0 < int(cmd) < 128 else (-1 if int(cmd) > 128 else 0)

        # Use filtered angles when available to reduce jitter.
        ang_a = self._motor_angle_a_filt if self._motor_angle_a_filt is not None else self._motor_angle_a
        ang_b = self._motor_angle_b_filt if self._motor_angle_b_filt is not None else self._motor_angle_b
        _apply_one("a", a_idx, self._motor_homing_a, ang_a, self.motor_zero_a, self.motor_invert_a)
        _apply_one("b", b_idx, self._motor_homing_b, ang_b, self.motor_zero_b, self.motor_invert_b)
        return out

    def _on_motor_set_zero(self, which: str) -> None:
        if which == "a":
            if self.motor_roi_a is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 7: set ROI first (Calibrate M7: ROI …).")
                return
            if self.motor_center_a is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 7: set Center first (Calibrate M7: Center).")
                return
            if not self._motor_found_a:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 7: no green marker detected inside ROI (adjust ROI / lighting).")
                return
            ang = self._motor_angle_a if self._motor_angle_a is not None else self._motor_angle_a_last
            if ang is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 7: marker OK but no angle yet (check Center position).")
                return
            self.motor_zero_a = float(ang)
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText(f"Motor 7: Zero saved at {self.motor_zero_a:+.1f}°")
        else:
            if self.motor_roi_b is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 8: set ROI first (Calibrate M8: ROI …).")
                return
            if self.motor_center_b is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 8: set Center first (Calibrate M8: Center).")
                return
            if not self._motor_found_b:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 8: no green marker detected inside ROI (adjust ROI / lighting).")
                return
            ang = self._motor_angle_b if self._motor_angle_b is not None else self._motor_angle_b_last
            if ang is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 8: marker OK but no angle yet (check Center position).")
                return
            self.motor_zero_b = float(ang)
            if self._motor_cam_hint_label is not None:
                self._motor_cam_hint_label.setText(f"Motor 8: Zero saved at {self.motor_zero_b:+.1f}°")
        self._save_motor_homing_config()

    def _on_motor_go_zero(self, which: str) -> None:
        # Validate we have everything needed; otherwise show a clear hint.
        if which == "a":
            if self.motor_zero_a is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 7: set Zero first (Set Zero 7).")
                return
            if self._motor_angle_a is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 7: marker/angle not detected (check ROI + center + green marker).")
                return
            self._motor_homing_a = True
        else:
            if self.motor_zero_b is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 8: set Zero first (Set Zero 8).")
                return
            if self._motor_angle_b is None:
                if self._motor_cam_hint_label is not None:
                    self._motor_cam_hint_label.setText("Motor 8: marker/angle not detected (check ROI + center + green marker).")
                return
            self._motor_homing_b = True
        # Trigger an immediate send (so you see motion even if no pattern is active).
        try:
            self._send_snapshot()
        except Exception:
            pass

    def _on_motor_stop_homing(self) -> None:
        self._motor_homing_a = False
        self._motor_homing_b = False
        self._motor_within_a = 0
        self._motor_within_b = 0
        self._motor_stop_hold_until_a = time.monotonic() + 0.2
        self._motor_stop_hold_until_b = time.monotonic() + 0.2
        self._motor_last_dir_a = 0
        self._motor_last_dir_b = 0
        self._motor_reverse_block_until_a = 0.0
        self._motor_reverse_block_until_b = 0.0
        # Send an immediate stop command to the MBM motors (best effort).
        try:
            a_idx, b_idx = self._motor_fixture_indices()
            frame = self._build_universe_frame()
            frame = self._apply_active_mask(frame, self.patterns[self.active_pattern_index].active_fixtures) if self.active_pattern_index is not None else frame
            frame[self.fixtures[a_idx].start_address - 1] = 128
            frame[self.fixtures[b_idx].start_address - 1] = 128
            self._send_frame_with_ola_feedback(frame)
        except Exception:
            pass

    def _tick(self) -> None:
        # Update FPS diagnostics.
        now = time.monotonic()
        if self._last_tick_time is not None:
            dt = now - self._last_tick_time
            if dt > 0:
                inst_fps = 1.0 / dt
                if self._fps_smooth is None:
                    self._fps_smooth = inst_fps
                else:
                    # Simple exponential moving average for stability.
                    self._fps_smooth = 0.9 * self._fps_smooth + 0.1 * inst_fps
                if self.fps_value_label is not None:
                    self.fps_value_label.setText(f"{self._fps_smooth:.1f}")
        self._last_tick_time = now

        # Build base frame from current fixture states.
        frame = self._build_universe_frame()
        
        # Apply pattern mask if a pattern is active.
        if self.active_pattern_index is not None:
            pattern = self.patterns[self.active_pattern_index]
            if pattern.is_defined():
                frame = self._apply_active_mask(frame, pattern.active_fixtures)
        
        # Apply motor homing overrides (independent of patterns).
        frame = self._apply_motor_homing_overrides(frame)
        
        # Apply fog timer (independent of patterns, always check for active bursts).
        frame = self._apply_fog_timer(frame, now)
        
        # Only send DMX if something is actually active.
        has_active_fog_burst = (self.fog_last_burst_time is not None and 
                                (now - self.fog_last_burst_time) < self.fog_burst_duration_s)
        if (self.active_pattern_index is None and 
            not self._motor_homing_a and 
            not self._motor_homing_b and 
            not self.fog_enabled and 
            not has_active_fog_burst):
            # Nothing active, skip DMX send
            return
        
        self._send_frame_with_ola_feedback(frame)

    def _apply_fog_timer(self, frame: List[int], now: float) -> List[int]:
        """
        Apply independent fog timer logic (fixture 9).
        Handles both automatic bursts (if enabled) and manual bursts.
        """
        fog_idx = MOVING_HEAD_COUNT + HERO_COUNT + MBM_COUNT  # fixture 9 (0-based = 8)
        if fog_idx >= len(self.fixtures):
            return frame
        
        fog_fixture = self.fixtures[fog_idx]
        fog_addr = fog_fixture.start_address - 1
        if fog_addr < 0 or fog_addr >= 512:
            return frame
        
        out = list(frame)
        
        # Check if we're currently in a burst (manual or automatic).
        if self.fog_last_burst_time is not None:
            time_since_burst = now - self.fog_last_burst_time
            if time_since_burst < self.fog_burst_duration_s:
                # Active burst: fog ON (DMX 255).
                out[fog_addr] = 255
                return out
        
        # If auto fog is enabled, check if it's time for a new burst.
        if self.fog_enabled:
            if self.fog_last_burst_time is None:
                # First burst: start now.
                print(f"[FOG] AUTO: Starting first burst at addr={fog_addr}, duration={self.fog_burst_duration_s}s, interval={self.fog_interval_s}s")
                self.fog_last_burst_time = now
                out[fog_addr] = 255
            elif (now - self.fog_last_burst_time) >= self.fog_interval_s:
                # Start a new automatic burst.
                print(f"[FOG] AUTO: Starting new burst (interval elapsed: {now - self.fog_last_burst_time:.1f}s >= {self.fog_interval_s}s)")
                self.fog_last_burst_time = now
                out[fog_addr] = 255
            else:
                # Between bursts: fog OFF (DMX 0).
                out[fog_addr] = 0
        else:
            # Auto fog disabled: ensure fog is off.
            out[fog_addr] = 0
        
        return out

    def _send_frame_with_ola_feedback(self, frame: List[int]) -> None:
        """
        Low-level DMX sender that mirrors main.send_single_frame, but also
        updates the OLA status label so the user sees when we restart the
        connection to olad.
        """
        # Queue latest frame for background DMX thread (non-blocking UI)
        self._ensure_dmx_thread()
        with self._dmx_cv:
            self._dmx_queue.append((int(self.universe), list(frame)))
            self._dmx_cv.notify()
        self._set_status(f"Sending DMX to Universe {self.universe}.")

    # --------------------------- Pattern sets persistence --------------------

    def _refresh_set_combo(self) -> None:
        if self.set_combo is None:
            return
        prev = self.set_combo.currentText()
        self.set_combo.clear()
        for s in self.pattern_sets:
            self.set_combo.addItem(s.name)
        # Restore selection if possible
        target = self._last_selected_set_name or prev
        if target:
            self.set_combo.setCurrentText(target)

    def _on_store_set(self) -> None:
        """Store the current patterns into a named set and save to disk."""
        name = (self.set_name_edit.text().strip() if self.set_name_edit else "") or f"Set {len(self.pattern_sets) + 1}"
        snapshot = [PatternSlot(p.name, fixtures_state=p.fixtures_state, active_fixtures=list(p.active_fixtures)) for p in self.patterns]

        for s in self.pattern_sets:
            if s.name == name:
                s.patterns = snapshot
                break
        else:
            self.pattern_sets.append(PatternSet(name=name, patterns=snapshot))

        self._save_sets_to_disk()
        if self.set_name_edit:
            self.set_name_edit.setText(name)
        self._last_selected_set_name = name
        self._refresh_set_combo()

    def _on_load_set(self) -> None:
        """Load patterns from the selected set into the controller."""
        if not self.set_combo or self.set_combo.currentIndex() < 0:
            return
        name = self.set_combo.currentText()
        self._last_selected_set_name = name
        for s in self.pattern_sets:
            if s.name == name:
                # Deep copy so further edits do not mutate the stored set.
                def _normalize_active_fixtures(raw_list: List[bool]) -> List[bool]:
                    af = list(raw_list)
                    if len(af) < PATTERN_FIXTURE_COUNT:
                        af.extend([True] * (PATTERN_FIXTURE_COUNT - len(af)))
                    elif len(af) > PATTERN_FIXTURE_COUNT:
                        af = af[:PATTERN_FIXTURE_COUNT]
                    return af

                self.patterns = [
                    PatternSlot(
                        name=p.name,
                        fixtures_state=(
                            [FixtureState(**{
                                "start_address": fs.start_address,
                                "channel_count": fs.channel_count,
                                "min_values": _coerce_int_key_dict(fs.min_values, value_type=int),
                                "max_values": _coerce_int_key_dict(fs.max_values, value_type=int),
                                "slider_values": _coerce_int_key_dict(fs.slider_values, value_type=int),
                                "modes": _coerce_int_key_dict(fs.modes, value_type=str),
                                "rates": _coerce_int_key_dict(fs.rates, value_type=float),
                                "phases": _coerce_int_key_dict(fs.phases, value_type=float),
                            }) for fs in (p.fixtures_state or [])]
                            if p.fixtures_state
                            else None
                        ),
                        active_fixtures=_normalize_active_fixtures(p.active_fixtures),
                    )
                    for p in s.patterns
                ]

                # Pad/truncate to default slot count so OSC /pattern 1..7 stays valid.
                if len(self.patterns) < DEFAULT_PATTERN_SLOTS:
                    for i in range(len(self.patterns), DEFAULT_PATTERN_SLOTS):
                        self.patterns.append(PatternSlot(name=f"Pattern {i+1}"))
                elif len(self.patterns) > DEFAULT_PATTERN_SLOTS:
                    self.patterns = self.patterns[:DEFAULT_PATTERN_SLOTS]

                self._rebuild_patterns_ui()
                # Keep UI selection consistent after rebuild
                if self.set_name_edit:
                    self.set_name_edit.setText(name)
                if self.set_combo:
                    self.set_combo.setCurrentText(name)
                self._set_status(f"Loaded set: {name}")
                break
        else:
            self._set_status(f"Load set failed: '{name}' not found.")

    def _on_delete_set(self) -> None:
        """Delete the currently selected pattern set from disk (with confirmation)."""
        if not self.set_combo or self.set_combo.currentIndex() < 0:
            self._set_status("Delete set: no set selected.")
            return
        
        name = self.set_combo.currentText()
        if not name:
            self._set_status("Delete set: no set selected.")
            return
        
        # Confirmation dialog.
        reply = QMessageBox.question(
            self,
            "Confirm Delete",
            f"Are you sure you want to delete the pattern set '{name}'?\n\nThis cannot be undone.",
            QMessageBox.Yes | QMessageBox.No,
            QMessageBox.No
        )
        
        if reply != QMessageBox.Yes:
            self._set_status("Delete cancelled.")
            return
        
        # Find and remove the set.
        found = False
        for i, s in enumerate(self.pattern_sets):
            if s.name == name:
                self.pattern_sets.pop(i)
                found = True
                break
        
        if not found:
            self._set_status(f"Delete set failed: '{name}' not found.")
            return
        
        # Save to disk immediately.
        self._save_sets_to_disk()
        
        # Refresh the combo box (will auto-select first set or show empty).
        self._refresh_set_combo()
        
        # Clear the last selected name if it was the deleted one.
        if self._last_selected_set_name == name:
            self._last_selected_set_name = ""
        
        self._set_status(f"Deleted set: {name}")

    def _save_sets_to_disk(self) -> None:
        data = {
            "sets": [
                {
                    "name": s.name,
                    "patterns": [
                        {
                            "name": p.name,
                            "fixtures": [
                                {
                                    "start_address": fs.start_address,
                                    "channel_count": fs.channel_count,
                                    "min_values": fs.min_values,
                                    "max_values": fs.max_values,
                                    "slider_values": fs.slider_values,
                                    "modes": fs.modes,
                                    "rates": fs.rates,
                                    "phases": fs.phases,
                                }
                                for fs in (p.fixtures_state or [])
                            ],
                            "active_fixtures": p.active_fixtures,
                        }
                        for p in s.patterns
                    ],
                }
                for s in self.pattern_sets
            ]
        }
        try:
            with open(PATTERN_SETS_FILE, "w", encoding="utf-8") as f:
                import json

                json.dump(data, f, indent=2)
        except OSError:
            # Do not crash if disk is read-only.
            pass

    def _load_sets_from_disk(self) -> List[PatternSet]:
        if not os.path.exists(PATTERN_SETS_FILE):
            return []
        try:
            import json

            with open(PATTERN_SETS_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
        except (OSError, json.JSONDecodeError):
            return []

        def _normalize_active_fixtures(raw_list: List[bool]) -> List[bool]:
            af = list(raw_list)
            if len(af) < PATTERN_FIXTURE_COUNT:
                af.extend([True] * (PATTERN_FIXTURE_COUNT - len(af)))
            elif len(af) > PATTERN_FIXTURE_COUNT:
                af = af[:PATTERN_FIXTURE_COUNT]
            return af

        sets: List[PatternSet] = []
        for sdata in data.get("sets", []):
            patterns: List[PatternSlot] = []
            for pdata in sdata.get("patterns", []):
                fixtures_state: List[FixtureState] = []
                for fsd in pdata.get("fixtures", []):
                    fs = FixtureState(
                        start_address=fsd.get("start_address", 1),
                        channel_count=fsd.get("channel_count", 0),
                        min_values=fsd.get("min_values", {}),
                        max_values=fsd.get("max_values", {}),
                        slider_values=fsd.get("slider_values", {}),
                        modes=fsd.get("modes", {}),
                        rates=fsd.get("rates", {}),
                        phases=fsd.get("phases", {}),
                    )
                    fixtures_state.append(fs)

                patterns.append(
                    PatternSlot(
                        name=pdata.get("name", "Pattern"),
                        fixtures_state=fixtures_state if fixtures_state else None,
                        active_fixtures=_normalize_active_fixtures(
                            pdata.get(
                                "active_fixtures",
                                [True for _ in range(PATTERN_FIXTURE_COUNT)],
                            )
                        ),
                    )
                )

            sets.append(PatternSet(name=sdata.get("name", "Set"), patterns=patterns))
        return sets


def main() -> None:
    import argparse
    parser = argparse.ArgumentParser(description="IMOL Pattern Controller")
    parser.add_argument("--display", type=int, default=-1,
                       help="Display index to show window on (-1 = auto-detect smallest/built-in, default: -1)")
    parser.add_argument("--osc-autostart", action="store_true", default=True,
                       help="Auto-start OSC listening on launch (default: True)")
    parser.add_argument("--no-osc-autostart", action="store_true",
                       help="Disable OSC auto-start (overrides --osc-autostart)")
    parser.add_argument("--fog-autostart", action="store_true", default=False,
                       help="Auto-start fog timer on launch (overrides config file)")
    args = parser.parse_args()
    
    app = QApplication(sys.argv)
    
    # Display selection: choose target screen
    target_screen = None
    screens = app.screens()
    
    if args.display >= 0 and args.display < len(screens):
        # Explicit display index provided
        target_screen = screens[args.display]
        print(f"[DISPLAY] Controller using display {args.display}: {target_screen.name()}")
    elif args.display == -1 and len(screens) > 1:
        # Auto-detect: use smallest screen (built-in laptop screen is typically smaller)
        target_screen = min(screens, key=lambda s: s.size().width() * s.size().height())
        screen_idx = screens.index(target_screen)
        print(f"[DISPLAY] Controller auto-detected smallest display ({screen_idx}): {target_screen.name()} "
              f"{target_screen.size().width()}x{target_screen.size().height()}")
    elif len(screens) == 1:
        target_screen = screens[0]
        print(f"[DISPLAY] Controller using primary display: {target_screen.name()}")
    else:
        # Fallback to primary screen
        target_screen = app.primaryScreen()
        print(f"[DISPLAY] Controller using primary screen (fallback)")
    
    win = MainWindow()
    
    # Auto-start OSC if requested
    osc_autostart = args.osc_autostart and not args.no_osc_autostart
    if osc_autostart:
        # Use QTimer to start OSC after the event loop starts
        from PySide6.QtCore import QTimer
        QTimer.singleShot(100, win._on_start_osc_clicked)
    
    # Auto-start fog timer if requested
    if args.fog_autostart:
        win.fog_enabled = True
        win._save_fog_timer_config()
        print(f"[FOG] Auto-start enabled via --fog-autostart flag")
    
    # Position window on target screen
    if target_screen:
        # Ensure window handle exists before setting screen
        win.create()
        if win.windowHandle():
            win.windowHandle().setScreen(target_screen)
        # Move to screen's geometry
        geom = target_screen.availableGeometry()
        win.move(geom.x(), geom.y())
    
    win.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()


