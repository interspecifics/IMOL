"""
IMOL_CV_GRAPHIC_SCORE_QT
------------------------

Qt-based computer vision graphic score system for IMOL.

Features:
- CV process with image controls (contrast, brightness, gamma)
- Audio file viewer with waveform and spectral analysis
- Light pattern detection with bounding boxes and centroids
- Punching-card style scrolling graphic score (partiture)

Uses PySide6 for GUI and OpenCV for computer vision processing.
"""

import sys
import time
import math
import os
import random
import re
from collections import deque
from typing import Optional
from pathlib import Path
import argparse

import cv2
import numpy as np
from PySide6.QtCore import Qt, QTimer, Signal
from PySide6.QtGui import QImage, QPixmap, QPalette, QColor, QFont, QPainter, QPen, QFontMetrics
from PySide6.QtWidgets import (
    QApplication,
    QMainWindow,
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QLabel,
    QPushButton,
    QFileDialog,
    QGridLayout,
    QSlider,
    QGroupBox,
    QCheckBox,
)

# Import our advanced geometry analyzer
from light_geometry_analyzer import LightGeometryAnalyzer, GeometricFeatures

# Audio analysis imports
try:
    import librosa
    import librosa.display
    LIBROSA_AVAILABLE = True
except ImportError:
    LIBROSA_AVAILABLE = False
    print("Warning: librosa not available. Install with: pip install librosa")

# OSC (pattern controller)
try:
    from pythonosc.udp_client import SimpleUDPClient
    OSC_AVAILABLE = True
except ImportError:
    OSC_AVAILABLE = False
    SimpleUDPClient = None
    print("Warning: python-osc not available. Install with: pip install python-osc")


def _norm01(x: np.ndarray) -> np.ndarray:
    x = np.asarray(x, dtype=np.float32)
    mn = float(np.min(x)) if x.size else 0.0
    mx = float(np.max(x)) if x.size else 1.0
    if mx - mn < 1e-9:
        return np.zeros_like(x, dtype=np.float32)
    return (x - mn) / (mx - mn)


def _ellipsize_cv_text(text: str, max_px: int, font_face: int, font_scale: float, thickness: int) -> str:
    """Ellipsize text to fit in max_px using cv2.getTextSize."""
    if max_px <= 0:
        return ""
    (w, _), _ = cv2.getTextSize(text, font_face, font_scale, thickness)
    if w <= max_px:
        return text
    ell = "…"
    lo, hi = 0, len(text)
    best = ""
    while lo <= hi:
        mid = (lo + hi) // 2
        candidate = text[:mid].rstrip() + ell
        (cw, _), _ = cv2.getTextSize(candidate, font_face, font_scale, thickness)
        if cw <= max_px:
            best = candidate
            lo = mid + 1
        else:
            hi = mid - 1
    return best if best else ell


def _qt_color_from_bgr(bgr: tuple[int, int, int]) -> QColor:
    b, g, r = bgr
    return QColor(int(r), int(g), int(b))


def _sanitize_context(text: str) -> str:
    """
    Make RTF/TXT context safe + readable in a single-line terminal UI:
    - keep ASCII printable
    - collapse whitespace
    - collapse noisy punctuation runs
    """
    s = re.sub(r"[^\x20-\x7E]+", " ", text)
    s = re.sub(r"[;]{2,}", ";", s)
    s = re.sub(r"[|]{2,}", "|", s)
    s = re.sub(r"\s+", " ", s).strip()
    # Drop common font-table remnants if any slip through
    s = re.sub(r"^\s*Times-Roman\s*[,;:\s\\\*\"]+", "", s, flags=re.IGNORECASE)
    s = re.sub(r"\bTimes-Roman\b", "", s, flags=re.IGNORECASE)
    # If the beginning still looks like an RTF font header, strip the first token chunk.
    s = re.sub(r"^\s*[A-Za-z0-9\-]+\s*[,;:\s\\\*\"]{2,}", "", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def _wrap_text_to_lines(text: str, metrics: QFontMetrics, max_width_px: int) -> list[str]:
    """
    Word-wrap `text` into lines that fit `max_width_px` using Qt font metrics.
    """
    if max_width_px <= 0:
        return []
    words = text.split(" ")
    lines: list[str] = []
    cur = ""
    for w in words:
        if not w:
            continue
        candidate = f"{cur} {w}".strip() if cur else w
        if metrics.horizontalAdvance(candidate) <= max_width_px:
            cur = candidate
            continue
        if cur:
            lines.append(cur)
        # If a single word is too long, hard-cut it with ellipsis.
        if metrics.horizontalAdvance(w) > max_width_px:
            cut = w
            ell = "…"
            while cut and metrics.horizontalAdvance(cut + ell) > max_width_px:
                cut = cut[:-1]
            lines.append((cut + ell) if cut else ell)
            cur = ""
        else:
            cur = w
    if cur:
        lines.append(cur)
    return lines


class AudioFeatureTimeline:
    """
    Extracted audio features as time series, used for visualization and for OSC scheduling.
    All arrays are 1D and share the same timebase `t` (seconds).
    """

    def __init__(self):
        self.t: np.ndarray = np.zeros((0,), dtype=np.float32)
        self.rms: np.ndarray = np.zeros((0,), dtype=np.float32)
        self.onset: np.ndarray = np.zeros((0,), dtype=np.float32)
        self.centroid: np.ndarray = np.zeros((0,), dtype=np.float32)
        self.bandwidth: np.ndarray = np.zeros((0,), dtype=np.float32)
        self.flatness: np.ndarray = np.zeros((0,), dtype=np.float32)
        self.rolloff: np.ndarray = np.zeros((0,), dtype=np.float32)
        # ML state (cluster -> pattern id)
        self.cluster_labels: np.ndarray = np.zeros((0,), dtype=np.int16)  # 0..k-1 per frame
        self.cluster_to_pattern: dict[int, int] = {}  # cluster_id -> 1..pattern_count
        self.pattern_count: int = 7
        self.duration: float = 0.0

    @property
    def is_valid(self) -> bool:
        return self.t.size > 1

    def value_at(self, arr: np.ndarray, t_sec: float) -> float:
        if arr.size == 0 or self.t.size == 0:
            return 0.0
        idx = int(np.clip(np.searchsorted(self.t, t_sec, side="right") - 1, 0, arr.size - 1))
        return float(arr[idx])

    def label_at(self, t_sec: float) -> int:
        """Return mapped pattern number (1..pattern_count) at time t_sec."""
        if self.cluster_labels.size == 0 or self.t.size == 0:
            return 1
        idx = int(np.clip(np.searchsorted(self.t, t_sec, side="right") - 1, 0, self.cluster_labels.size - 1))
        cid = int(self.cluster_labels[idx])
        return int(self.cluster_to_pattern.get(cid, 1))


def _kmeans_fit_predict(X: np.ndarray, k: int, seed: int = 0, iters: int = 25) -> np.ndarray:
    """
    Minimal k-means (numpy) for small feature matrices.
    Returns labels in 0..k-1.
    """
    X = np.asarray(X, dtype=np.float32)
    n = X.shape[0]
    if n == 0:
        return np.zeros((0,), dtype=np.int16)
    k = int(max(1, min(k, n)))

    rng = np.random.default_rng(int(seed))
    idxs = rng.choice(n, size=k, replace=False)
    C = X[idxs].copy()

    labels = np.zeros((n,), dtype=np.int16)
    for _ in range(iters):
        # squared distances: (n,k)
        d2 = ((X[:, None, :] - C[None, :, :]) ** 2).sum(axis=2)
        new_labels = d2.argmin(axis=1).astype(np.int16)
        if np.array_equal(new_labels, labels):
            break
        labels = new_labels
        # update centroids
        for j in range(k):
            mask = labels == j
            if not np.any(mask):
                # re-seed empty cluster
                C[j] = X[rng.integers(0, n)]
            else:
                C[j] = X[mask].mean(axis=0)
    return labels


def strip_rtf(text: str) -> str:
    """Strip RTF formatting to get plain text."""
    if not text:
        return ""

    # Remove header groups that often contain font names / metadata
    text = re.sub(r"\{\\fonttbl[\s\S]*?\}", " ", text)
    text = re.sub(r"\{\\colortbl[\s\S]*?\}", " ", text)
    text = re.sub(r"\{\\stylesheet[\s\S]*?\}", " ", text)
    text = re.sub(r"\{\\\*[\s\S]*?\}", " ", text)

    # Paragraph-ish controls to spaces
    text = re.sub(r"\\par[d]?\b", " ", text)
    text = re.sub(r"\\line\b", " ", text)
    text = re.sub(r"\\tab\b", " ", text)

    # Remove hex escapes
    text = re.sub(r"\\'[0-9a-fA-F]{2}", " ", text)

    # Remove remaining control words like \fs24, \b0, \cf1
    text = re.sub(r"\\[a-zA-Z]+\d*(?:-[0-9]+)?\s?", " ", text)

    # Remove braces and normalize whitespace
    text = re.sub(r"[{}]", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text


class AudioViewerWidget(QWidget):
    """
    Audio file viewer with real waveform, metadata, and spectrogram display.
    """
    
    def __init__(self, width: int, height: int):
        super().__init__()
        self.viewer_width = width
        self.viewer_height = height
        self.setFixedSize(width, height)
        
        layout = QVBoxLayout()
        layout.setContentsMargins(0, 0, 0, 0)
        layout.setSpacing(0)
        
        # Display label
        self.display_label = QLabel()
        self.display_label.setFixedSize(width, height - 40)
        self.display_label.setStyleSheet("background-color: black; border: 1px solid #333;")
        layout.addWidget(self.display_label)
        
        # Load button (integrated into transport row to keep more vertical space for the spectrogram)
        self.load_button = QPushButton("Select Audio Folder")
        self.load_button.setFixedHeight(28)
        self.load_button.setMinimumWidth(180)
        # Minimal, terminal-like look (consistent with the rest of the UI)
        self.load_button.setStyleSheet("""
            QPushButton {
                background-color: #151515;
                color: #cfcfcf;
                border: 1px solid #333;
                padding: 4px 10px;
                font-size: 12px;
            }
            QPushButton:hover { background-color: #1d1d1d; border-color: #444; }
            QPushButton:pressed { background-color: #0f0f0f; }
        """)

        # Transport row (playback of extracted features; does NOT play audio)
        transport = QHBoxLayout()
        transport.setContentsMargins(8, 0, 8, 0)
        transport.setSpacing(10)

        self.play_button = QPushButton("Play")
        self.play_button.setFixedHeight(28)
        self.play_button.setStyleSheet("""
            QPushButton {
                background-color: #151515;
                color: #cfcfcf;
                border: 1px solid #333;
                padding: 4px 10px;
                font-size: 12px;
            }
            QPushButton:hover { background-color: #1d1d1d; border-color: #444; }
            QPushButton:pressed { background-color: #0f0f0f; }
        """)

        self.autoplay_cb = QCheckBox("Auto play features")
        self.autoplay_cb.setChecked(True)
        self.autoplay_cb.setStyleSheet("color: #9a9a9a; font-size: 11px;")

        self.osc_log_cb = QCheckBox("OSC log")
        # Default OFF: printing OSC traffic can easily stall the GUI and/or Max debugging.
        self.osc_log_cb.setChecked(False)
        self.osc_log_cb.setStyleSheet("color: #9a9a9a; font-size: 11px;")

        self.time_label = QLabel("0.00 / 0.00s")
        self.time_label.setStyleSheet("color: #9a9a9a; font-size: 11px;")

        # Put "Select Audio Folder" before Pause/Play to keep this as a single compact bar.
        transport.addWidget(self.load_button)
        transport.addWidget(self.play_button)
        transport.addWidget(self.autoplay_cb)
        transport.addWidget(self.osc_log_cb)
        transport.addStretch(1)
        transport.addWidget(self.time_label)

        layout.addLayout(transport)
        
        self.setLayout(layout)
        
        # Audio data
        self.audio_folder = None
        self.audio_files = []
        self.current_file = None
        self.audio_data = None
        self.sample_rate = None
        self.duration = None
        self.metadata = {}
        self.context_text = ""  # For longer descriptions from RTF/TXT

        # Features + transport state
        self.features = AudioFeatureTimeline()
        self.is_playing = False
        self.playhead_t = 0.0
        self._last_ui_redraw = 0.0
        self._last_play_monotonic: Optional[float] = None

        # Cached rendering (to keep playback smooth)
        self._cache_dirty = True
        self._cached_base_qimage: Optional[QImage] = None
        self._cached_wave_box: Optional[tuple[int, int, int, int]] = None  # x0,y0,x1,y1 for playhead
        self._mono_font = QApplication.font()

        # OSC clients (set by parent window)
        # - osc_client_pattern: goes to the light pattern controller (/pattern)
        # - osc_client_track: goes to Max (tracker-like addresses: /track/*, /system/state, /feat/*, etc.)
        self.osc_client_pattern = None
        self.osc_client_track = None
        self.osc_enabled = False
        self.osc_format = "pattern"  # "pattern" | "tracker"
        self.osc_send_features = False
        self.osc_send_rate_hz = 20.0
        self._last_osc_send_monotonic = 0.0
        # Tracker stream throttles (separate from /track/* which is handled in IMOLGraphicScoreWindow)
        # Rates: <= 0 disables sending that stream.
        self.osc_tracker_system_rate_hz: float = 10.0
        self.osc_tracker_vel_value_rate_hz: float = 10.0
        self.osc_tracker_feat_rate_hz: float = 5.0
        # Minimum deltas to avoid sending tiny changes (Max can choke on high packet rate)
        self.osc_tracker_system_min_delta: float = 0.01
        self.osc_tracker_vel_value_min_delta: float = 0.01
        self.osc_tracker_feat_min_delta: float = 0.02
        # Debounce the discrete /vel/<level> toggles (prevents rapid thrashing)
        self.osc_tracker_vel_level_hold_s: float = 0.25
        # Per-stream last-send timestamps
        self._osc_last_send_system_monotonic: float = 0.0
        self._osc_last_send_vel_value_monotonic: float = 0.0
        self._osc_last_send_feat_monotonic: float = 0.0
        # Last values (for min-delta)
        self._osc_last_sent_system_state: Optional[float] = None
        self._osc_last_sent_vel_value: Optional[float] = None
        self._osc_last_sent_feats: dict[str, float] = {}
        self._osc_last_vel_level_change_monotonic: float = 0.0
        self.pattern_max = 8
        self.pattern_count = 7
        self._last_trigger_t = 0.0
        self._silence_since: Optional[float] = None
        self._last_osc_print_monotonic = 0.0
        self._last_sent_pattern: Optional[int] = None
        self._last_sent_vel_level: Optional[int] = None
        self._last_state_on: Optional[int] = None
        self._osc_state_value: float = 1.0
        self._osc_state_target: float = 1.0
        self._osc_state_lerp: float = 0.08

        # Playback tick timer
        self.play_timer = QTimer(self)
        self.play_timer.timeout.connect(self._tick_playback)
        self.play_timer.start(33)  # ~30fps

        self.play_button.clicked.connect(self.toggle_play)
        
        # Initial render
        self.update_display()

    def _pick_next_audio_file(self) -> Optional[Path]:
        """
        Pick the next audio file to load.
        We choose randomly but try to avoid repeating the current file.
        """
        if not self.audio_files:
            return None
        if len(self.audio_files) == 1:
            return self.audio_files[0]

        current = self.current_file
        # Try a few times to pick a different file.
        for _ in range(8):
            candidate = random.choice(self.audio_files)
            if current is None or candidate != current:
                return candidate
        return random.choice(self.audio_files)

    def load_next_audio(self):
        """Load another audio file from the folder and keep feature playback running."""
        if not self.audio_files:
            return
        next_file = self._pick_next_audio_file()
        if next_file is None:
            return
        self.current_file = next_file
        self._load_audio_file(next_file)

    def _load_audio_file(self, audio_path: Path):
        """Load a specific audio file (and its context), extract features, refresh cache/UI."""
        # Look for accompanying .txt or .rtf metadata file
        txt_file = audio_path.with_suffix('.txt')
        rtf_file = audio_path.with_suffix('.rtf')

        self.context_text = ""
        if rtf_file.exists():
            try:
                with open(rtf_file, 'r', encoding='utf-8', errors='ignore') as f:
                    raw_content = f.read()
                    self.context_text = strip_rtf(raw_content)
                print(f"Loaded context from RTF: {rtf_file.name}")
                self._cache_dirty = True
            except Exception as e:
                print(f"Error reading RTF file: {e}")
        elif txt_file.exists():
            try:
                with open(txt_file, 'r', encoding='utf-8') as f:
                    self.context_text = f.read().strip()
                print(f"Loaded context from TXT: {txt_file.name}")
                self._cache_dirty = True
            except Exception as e:
                print(f"Error reading TXT file: {e}")

        if not LIBROSA_AVAILABLE:
            print("Librosa not available - cannot load audio")
            return

        try:
            print(f"Loading audio: {audio_path.name}")
            # Load audio with librosa (analysis-friendly SR, full duration)
            self.audio_data, self.sample_rate = librosa.load(str(audio_path), sr=22050, mono=True)
            self.duration = len(self.audio_data) / self.sample_rate

            # Extract metadata
            self.metadata = {
                'filename': audio_path.name,
                'duration': f"{self.duration:.2f}s",
                'sample_rate': f"{self.sample_rate}Hz",
            }

            print(f"Loaded: {audio_path.name} ({self.duration:.2f}s)")
            self._extract_features()
            self._cache_dirty = True

            # Keep playback running if we were playing or autoplay is enabled
            if self.is_playing or self.autoplay_cb.isChecked():
                self.start_play()
            self.update_display()
        except Exception as e:
            print(f"Error loading audio: {e}")
            self.audio_data = None
    
    def select_folder(self):
        """Select folder containing audio files."""
        folder = QFileDialog.getExistingDirectory(
            self,
            "Select Audio Folder",
            "",
            QFileDialog.ShowDirsOnly
        )
        
        if folder:
            self.audio_folder = folder
            # Find all audio files in the folder
            audio_extensions = ['.wav', '.mp3', '.flac', '.ogg', '.m4a', '.aac']
            self.audio_files = []
            
            for ext in audio_extensions:
                self.audio_files.extend(Path(folder).glob(f'*{ext}'))
                self.audio_files.extend(Path(folder).glob(f'*{ext.upper()}'))
            
            if self.audio_files:
                print(f"Found {len(self.audio_files)} audio files in {folder}")
                # Load a random file
                self.load_random_audio()
            else:
                print(f"No audio files found in {folder}")
                self.update_display()
    
    def load_random_audio(self):
        """Load a random audio file from the folder."""
        if not self.audio_files:
            return

        random_file = self._pick_next_audio_file()
        if random_file is None:
            return
        self.current_file = random_file
        self._load_audio_file(random_file)

    def set_osc(
        self,
        enabled: bool,
        client_pattern,
        pattern_max: int = 8,
        osc_format: str = "pattern",
        send_features: bool = False,
        send_rate_hz: float = 20.0,
        client_track=None,
        tracker_system_rate_hz: float = 10.0,
        tracker_vel_value_rate_hz: float = 10.0,
        tracker_feat_rate_hz: float = 5.0,
        tracker_system_min_delta: float = 0.01,
        tracker_vel_value_min_delta: float = 0.01,
        tracker_feat_min_delta: float = 0.02,
        tracker_vel_level_hold_s: float = 0.25,
    ):
        self.osc_enabled = bool(enabled) and client_pattern is not None
        self.osc_client_pattern = client_pattern
        self.osc_client_track = client_track
        self.osc_format = str(osc_format or "pattern").strip().lower()
        if self.osc_format not in ("pattern", "tracker"):
            self.osc_format = "pattern"
        self.osc_send_features = bool(send_features)
        self.osc_send_rate_hz = float(max(1.0, send_rate_hz))
        self._last_osc_send_monotonic = 0.0
        # Tracker throttles (for /system/state, /vel/value, /feat/*)
        self.osc_tracker_system_rate_hz = float(tracker_system_rate_hz)
        self.osc_tracker_vel_value_rate_hz = float(tracker_vel_value_rate_hz)
        self.osc_tracker_feat_rate_hz = float(tracker_feat_rate_hz)
        self.osc_tracker_system_min_delta = float(max(0.0, tracker_system_min_delta))
        self.osc_tracker_vel_value_min_delta = float(max(0.0, tracker_vel_value_min_delta))
        self.osc_tracker_feat_min_delta = float(max(0.0, tracker_feat_min_delta))
        self.osc_tracker_vel_level_hold_s = float(max(0.0, tracker_vel_level_hold_s))
        # Reset stream clocks and last-values when changing OSC config
        self._osc_last_send_system_monotonic = 0.0
        self._osc_last_send_vel_value_monotonic = 0.0
        self._osc_last_send_feat_monotonic = 0.0
        self._osc_last_sent_system_state = None
        self._osc_last_sent_vel_value = None
        self._osc_last_sent_feats = {}
        self._osc_last_vel_level_change_monotonic = 0.0
        self.pattern_max = int(max(1, pattern_max))
        self.pattern_count = min(self.pattern_max, 7)
        if self.osc_enabled:
            # Note: host/port are set in IMOLGraphicScoreWindow; client repr may include them.
            track_name = type(self.osc_client_track).__name__ if self.osc_client_track is not None else "None"
            print(f"[AUDIO/OSC] enabled pattern_client={type(client_pattern).__name__} track_client={track_name} format={self.osc_format} send_features={self.osc_send_features} rate_hz={self.osc_send_rate_hz} pattern_max={self.pattern_max} pattern_count={self.pattern_count}")
        else:
            if enabled:
                print("[AUDIO/OSC] requested but disabled (no client). Check --osc-out-enable and python-osc.")
            else:
                print("[AUDIO/OSC] disabled")

    def _osc_send(self, address: str, value, *, target: str = "pattern"):
        if not self.osc_enabled:
            return
        if target == "track":
            client = self.osc_client_track
        else:
            client = self.osc_client_pattern
        if client is None:
            return
        # Terminal logging (rate-limited)
        if self.osc_log_cb.isChecked():
            now = time.monotonic()
            if (now - self._last_osc_print_monotonic) > 0.02:
                self._last_osc_print_monotonic = now
                pat = self.features.label_at(self.playhead_t) if self.features.is_valid else 0
                print(f"[AUDIO/OSC] t={self.playhead_t:6.2f}s pattern={pat} target={target} -> {address} {value}")
        try:
            client.send_message(address, value)
        except Exception as exc:
            if self.osc_log_cb.isChecked():
                print(f"[AUDIO/OSC] send failed {address} {value}: {exc}")

    def _feature_value_at(self, t_sec: float, arr: Optional[np.ndarray]) -> float:
        """Nearest-sample lookup for feature arrays aligned to self.features.t."""
        if arr is None or not self.features.is_valid or self.features.t.size == 0:
            return 0.0
        try:
            idx = int(np.searchsorted(self.features.t, t_sec, side="right") - 1)
            idx = int(np.clip(idx, 0, int(arr.shape[0] - 1)))
            return float(arr[idx])
        except Exception:
            return 0.0

    def _maybe_send_tracker_osc(self, pattern_n: int):
        """
        Tracker-style OSC format inspired by your motion tracker:
        - /pattern <int>
        - /state/N <0|1>
        - /system/state <float> (smoothed continuous state value)
        - optional normalized features: /feat/rms, /feat/onset, /feat/centroid, /feat/flatness, /feat/rolloff
        - simple energy level: /vel/<0..4> <0|1> and /vel/value <0..1>
        """
        if not self.osc_enabled:
            return
        if self.osc_client_track is None:
            return

        now = time.monotonic()

        # Smooth /system/state toward current pattern id
        self._osc_state_target = float(pattern_n)
        self._osc_state_value = float(self._osc_state_value + self._osc_state_lerp * (self._osc_state_target - self._osc_state_value))
        # Tracker stream goes to Max (track target).
        # Rate limit + min-delta to avoid spamming Max with tiny smooth steps.
        if self.osc_tracker_system_rate_hz > 0.0:
            min_dt_sys = 1.0 / float(max(0.01, self.osc_tracker_system_rate_hz))
            if (now - self._osc_last_send_system_monotonic) >= min_dt_sys:
                sys_val = float(self._osc_state_value)
                sys_val = float(np.clip(sys_val, 0.0, 999.0))
                sys_val = float(round(sys_val, 4))
                last_sys = self._osc_last_sent_system_state
                if last_sys is None or abs(sys_val - float(last_sys)) >= self.osc_tracker_system_min_delta:
                    self._osc_send("/system/state", sys_val, target="track")
                    self._osc_last_sent_system_state = sys_val
                    self._osc_last_send_system_monotonic = now

        # State toggles on pattern change
        if self._last_state_on is None:
            self._last_state_on = int(pattern_n)
            self._osc_send(f"/state/{int(pattern_n)}", 1, target="track")
        elif int(pattern_n) != int(self._last_state_on):
            self._osc_send(f"/state/{int(self._last_state_on)}", 0, target="track")
            self._osc_send(f"/state/{int(pattern_n)}", 1, target="track")
            self._last_state_on = int(pattern_n)

        # Feature-derived velocity level (0..4) from normalized RMS
        rms01 = float(_norm01(np.array([self._feature_value_at(self.playhead_t, self.features.rms)], dtype=np.float32))[0]) if self.features.is_valid else 0.0
        vel_level = int(np.clip(int(rms01 * 5.0), 0, 4))
        if self._last_sent_vel_level is None:
            self._last_sent_vel_level = vel_level
            self._osc_send(f"/vel/{vel_level}", 1, target="track")
            self._osc_last_vel_level_change_monotonic = now
        elif vel_level != self._last_sent_vel_level:
            # Debounce level switching
            if (now - self._osc_last_vel_level_change_monotonic) >= float(self.osc_tracker_vel_level_hold_s):
                self._osc_send(f"/vel/{int(self._last_sent_vel_level)}", 0, target="track")
                self._osc_send(f"/vel/{vel_level}", 1, target="track")
                self._last_sent_vel_level = vel_level
                self._osc_last_vel_level_change_monotonic = now

        # Optional continuous /vel/value (rate-limited + min-delta)
        if self.osc_tracker_vel_value_rate_hz > 0.0:
            min_dt_vel = 1.0 / float(max(0.01, self.osc_tracker_vel_value_rate_hz))
            if (now - self._osc_last_send_vel_value_monotonic) >= min_dt_vel:
                vv = float(np.clip(float(rms01), 0.0, 1.0))
                vv = float(round(vv, 4))
                last_vv = self._osc_last_sent_vel_value
                if last_vv is None or abs(vv - float(last_vv)) >= self.osc_tracker_vel_value_min_delta:
                    self._osc_send("/vel/value", vv, target="track")
                    self._osc_last_sent_vel_value = vv
                    self._osc_last_send_vel_value_monotonic = now

        if not self.osc_send_features or not self.features.is_valid:
            return
        if self.osc_tracker_feat_rate_hz <= 0.0:
            return

        min_dt_feat = 1.0 / float(max(0.01, self.osc_tracker_feat_rate_hz))
        if (now - self._osc_last_send_feat_monotonic) < min_dt_feat:
            return

        onset01 = float(_norm01(np.array([self._feature_value_at(self.playhead_t, self.features.onset)], dtype=np.float32))[0])
        cent01 = float(_norm01(np.array([self._feature_value_at(self.playhead_t, self.features.centroid)], dtype=np.float32))[0])
        flat01 = float(_norm01(np.array([self._feature_value_at(self.playhead_t, self.features.flatness)], dtype=np.float32))[0])
        roll01 = float(_norm01(np.array([self._feature_value_at(self.playhead_t, self.features.rolloff)], dtype=np.float32))[0])

        feat_map = {
            "/feat/rms": float(round(float(np.clip(rms01, 0.0, 1.0)), 4)),
            "/feat/onset": float(round(float(np.clip(onset01, 0.0, 1.0)), 4)),
            "/feat/centroid": float(round(float(np.clip(cent01, 0.0, 1.0)), 4)),
            "/feat/flatness": float(round(float(np.clip(flat01, 0.0, 1.0)), 4)),
            "/feat/rolloff": float(round(float(np.clip(roll01, 0.0, 1.0)), 4)),
        }
        # Only send if at least one feature changed meaningfully.
        any_change = False
        for addr, val in feat_map.items():
            last_val = self._osc_last_sent_feats.get(addr)
            if last_val is None or abs(float(val) - float(last_val)) >= self.osc_tracker_feat_min_delta:
                any_change = True
                break
        if not any_change:
            self._osc_last_send_feat_monotonic = now
            return

        for addr, val in feat_map.items():
            self._osc_send(addr, float(val), target="track")
            self._osc_last_sent_feats[addr] = float(val)
        self._osc_last_send_feat_monotonic = now

    def start_play(self):
        self.is_playing = True
        self.play_button.setText("Pause")
        self._last_play_monotonic = time.monotonic()
        print("[AUDIO] play features")

    def stop_play(self):
        self.is_playing = False
        self.play_button.setText("Play")
        self._last_play_monotonic = None
        print("[AUDIO] pause features")

    def toggle_play(self):
        if not self.features.is_valid:
            return
        if self.is_playing:
            self.stop_play()
        else:
            self.start_play()

    def _extract_features(self):
        """Extract audio features for visualization + OSC scheduling."""
        self.features = AudioFeatureTimeline()
        if self.audio_data is None or not LIBROSA_AVAILABLE:
            return
        y = self.audio_data
        sr = int(self.sample_rate or 22050)

        # Feature frame rate (hop)
        hop = 512

        rms = librosa.feature.rms(y=y, frame_length=2048, hop_length=hop)[0]
        onset = librosa.onset.onset_strength(y=y, sr=sr, hop_length=hop)
        centroid = librosa.feature.spectral_centroid(y=y, sr=sr, hop_length=hop)[0]
        bandwidth = librosa.feature.spectral_bandwidth(y=y, sr=sr, hop_length=hop)[0]
        flatness = librosa.feature.spectral_flatness(y=y, hop_length=hop)[0]
        rolloff = librosa.feature.spectral_rolloff(y=y, sr=sr, hop_length=hop, roll_percent=0.85)[0]
        mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=8, hop_length=hop)  # (8, frames)

        t = librosa.frames_to_time(np.arange(len(rms)), sr=sr, hop_length=hop).astype(np.float32)
        n = min(len(t), len(rms), len(onset), len(centroid), len(bandwidth), len(flatness), len(rolloff), mfcc.shape[1])
        t = t[:n]

        self.features.t = t
        self.features.rms = rms[:n].astype(np.float32)
        self.features.onset = onset[:n].astype(np.float32)
        self.features.centroid = centroid[:n].astype(np.float32)
        self.features.bandwidth = bandwidth[:n].astype(np.float32)
        self.features.flatness = flatness[:n].astype(np.float32)
        self.features.rolloff = rolloff[:n].astype(np.float32)
        self.features.duration = float(self.duration or (float(t[-1]) if t.size else 0.0))
        self.features.pattern_count = int(max(2, self.pattern_count))

        # --- ML clustering into pattern states (k=pattern_count) ---
        # Goal: multiple patterns within ONE file. Clustering per-frame is too noisy and often collapses.
        # So we cluster on WINDOWED feature vectors (e.g. ~1s windows) and expand to the full timeline.
        mfcc_n = mfcc[:, :n].astype(np.float32)
        X = np.concatenate([
            _norm01(self.features.rms)[:, None],
            _norm01(self.features.onset)[:, None],
            _norm01(self.features.centroid)[:, None],
            _norm01(self.features.bandwidth)[:, None],
            _norm01(self.features.flatness)[:, None],
            _norm01(self.features.rolloff)[:, None],
            _norm01(mfcc_n.T),  # (frames, 8)
        ], axis=1).astype(np.float32)

        frame_dt = float(hop) / float(sr)
        win_sec = 1.0
        win = int(max(8, round(win_sec / max(1e-6, frame_dt))))
        step = int(max(1, win // 2))

        # Build windowed features by averaging inside each window
        starts = list(range(0, X.shape[0] - win + 1, step))
        if not starts:
            starts = [0]
            win = min(win, X.shape[0])
        Xw = np.stack([X[s:s + win].mean(axis=0) for s in starts], axis=0)

        # z-score on windowed vectors
        mu = Xw.mean(axis=0, keepdims=True)
        sig = Xw.std(axis=0, keepdims=True) + 1e-6
        Xw_z = (Xw - mu) / sig

        seed = abs(hash(str(self.current_file))) % (2**31) if self.current_file else 0
        k = int(self.features.pattern_count)
        labels_w = _kmeans_fit_predict(Xw_z, k=k, seed=seed, iters=40)

        # Expand window labels back to per-frame labels (piecewise-constant)
        labels = np.zeros((X.shape[0],), dtype=np.int16)
        for i, s in enumerate(starts):
            e = min(X.shape[0], s + step)
            labels[s:e] = labels_w[i]
        # tail fill
        if starts:
            tail_start = starts[-1] + step
            if tail_start < X.shape[0]:
                labels[tail_start:] = labels_w[-1]
        self.features.cluster_labels = labels

        # Stable mapping: order clusters by (mean centroid, mean rms) so patterns feel consistent
        cluster_stats = []
        for cid in range(k):
            m = labels == cid
            if not np.any(m):
                cluster_stats.append((cid, 0.0, 0.0))
                continue
            c_mean = float(self.features.centroid[m].mean())
            r_mean = float(self.features.rms[m].mean())
            cluster_stats.append((cid, c_mean, r_mean))
        cluster_stats.sort(key=lambda x: (x[1], x[2]))  # low->high
        self.features.cluster_to_pattern = {cid: (i + 1) for i, (cid, _, _) in enumerate(cluster_stats)}

        # Debug: distribution + mapping
        counts = np.bincount(labels.astype(np.int32), minlength=k).tolist()
        mapping_str = " ".join([f"{cid}->{self.features.cluster_to_pattern.get(cid,1)}" for cid in range(k)])
        print(f"[AUDIO] clustered k={k} seed={seed} counts={counts} map={mapping_str}")

        self.playhead_t = 0.0
        self._last_trigger_t = 0.0
        self._silence_since = None
        self._cache_dirty = True
        self._last_sent_pattern = None
        if self.features.is_valid:
            print(f"[AUDIO] features extracted frames={self.features.t.size} duration={self.features.duration:0.2f}s sr={sr} hop={hop}")

    def _tick_playback(self):
        """Advance playhead and emit OSC based on features."""
        if not self.is_playing or not self.features.is_valid:
            return

        # Advance time using real elapsed (keeps time consistent even if UI drops frames)
        now_m = time.monotonic()
        if self._last_play_monotonic is None:
            self._last_play_monotonic = now_m
        dt = now_m - self._last_play_monotonic
        self._last_play_monotonic = now_m
        dt = float(np.clip(dt, 0.0, 0.2))

        self.playhead_t += dt
        if self.playhead_t >= self.features.duration:
            # End of "feature playback": load a new file and keep going.
            if self.autoplay_cb.isChecked() and self.audio_files:
                # Schedule to avoid doing heavy work inside the timer callback.
                QTimer.singleShot(0, self.load_next_audio)
                return
            self.playhead_t = 0.0

        # Update time label
        self.time_label.setText(f"{self.playhead_t:0.2f} / {self.features.duration:0.2f}s")

        # Pattern detection from ML labels
        pattern_n = self.features.label_at(self.playhead_t)

        now = time.monotonic()
        redraw_due = (now - self._last_ui_redraw) > 0.12
        if redraw_due:
            self._last_ui_redraw = now
            self.update_display()

        if not self.osc_enabled or self.osc_client_pattern is None:
            return

        # Always keep legacy behavior: /pattern N on changes (debounced)
        min_hold = 0.40
        if self._last_sent_pattern is None:
            self._last_sent_pattern = pattern_n
            self._last_trigger_t = self.playhead_t
            # Pattern always goes to the light controller target
            self._osc_send("/pattern", int(pattern_n), target="pattern")
        elif pattern_n != self._last_sent_pattern and (self.playhead_t - self._last_trigger_t) >= min_hold:
            self._last_sent_pattern = pattern_n
            self._last_trigger_t = self.playhead_t
            self._osc_send("/pattern", int(pattern_n), target="pattern")

        # Optional tracker-style format (continuous + richer addresses)
        if self.osc_format == "tracker":
            self._maybe_send_tracker_osc(int(pattern_n))
    
    def update_display(self):
        """Render the audio viewer panel (cached to keep playback smooth)."""
        if self.audio_data is not None and self._cached_base_qimage is not None and not self._cache_dirty:
            img = self._cached_base_qimage.copy()
            if self.features.is_valid and self._cached_wave_box is not None:
                x0, y0, x1, y1 = self._cached_wave_box
                w = max(1, x1 - x0)
                ph = float(np.clip(self.playhead_t / max(1e-6, self.features.duration), 0.0, 1.0))
                px = x0 + int(ph * w)
                painter = QPainter(img)
                painter.setRenderHint(QPainter.Antialiasing, False)
                painter.setFont(self._mono_font)
                pen = QPen(QColor(230, 230, 230))
                pen.setWidth(1)
                painter.setPen(pen)
                painter.drawLine(px, y0, px, y1)

                # Dynamic pattern label (must NOT be cached, otherwise it looks stuck)
                pat = self.features.label_at(self.playhead_t)
                font = QFont(self._mono_font)
                font.setPointSize(11)
                painter.setFont(font)
                painter.setPen(QPen(QColor(210, 210, 210)))
                metrics = QFontMetrics(font)
                painter.drawText(int(x0 + 4), int(y0 + 2 + metrics.ascent()), f"pattern={pat}")
                painter.end()
            self.display_label.setPixmap(QPixmap.fromImage(img))
            return

        canvas = np.zeros((self.viewer_height - 40, self.viewer_width, 3), dtype=np.uint8)

        # Collect text overlays to draw with Qt (single font everywhere).
        text_overlays: list[tuple[str, int, int, QColor, int]] = []
        # tuple: (text, x, y, color, point_size)
        mono_color = QColor(210, 210, 210)
        dim_color = QColor(160, 160, 160)
        
        if self.audio_data is None:
            # No audio loaded - centered message
            center_y = (self.viewer_height - 40) // 2
            if self.audio_folder:
                msg = f"folder={Path(self.audio_folder).name}"
                msg2 = f"files={len(self.audio_files)}"
                text_overlays.append((msg, 20, center_y - 12, mono_color, 12))
                text_overlays.append((msg2, 20, center_y + 8, dim_color, 12))
            else:
                msg = "select an audio folder"
                text_overlays.append((msg, 20, center_y, dim_color, 12))
        else:
            # Audio loaded - display analysis
            y_pos = 20
            
            # Basic file info (terminal-like, compact)
            info_text = f"file={self.metadata.get('filename', 'N/A')}  dur={self.metadata.get('duration', 'N/A')}  sr={self.metadata.get('sample_rate', 'N/A')}"
            text_overlays.append((_ellipsize_cv_text(info_text, self.viewer_width - 20, cv2.FONT_HERSHEY_DUPLEX, 0.38, 1), 10, y_pos, mono_color, 12))
            y_pos += 28
            
            # Two-column layout: Context (left) | Waveform (right)
            middle_section_top = y_pos
            middle_section_height = 190
            split_x = self.viewer_width // 2
            
            # LEFT COLUMN: Context/Description area
            if self.context_text:
                context_left = 10
                context_right = split_x - 5
                context_top = middle_section_top
                context_bottom = context_top + middle_section_height

                # Terminal-style wrapped context block (no overlap, multiple lines)
                excerpt = _sanitize_context(self.context_text)
                # Define a strict text rectangle
                pad_x = 6
                pad_y = 6
                rect_x0 = context_left + pad_x
                rect_y0 = context_top + pad_y
                rect_w = max(1, (context_right - context_left) - 2 * pad_x)
                rect_h = max(1, (context_bottom - context_top) - 2 * pad_y)

                # We'll render this via Qt after the image conversion, using global font metrics.
                text_overlays.append((
                    f"__BLOCK__{rect_x0},{rect_y0},{rect_w},{rect_h}::{excerpt}",
                    0, 0, dim_color, 12
                ))
            
            # RIGHT COLUMN: Waveform
            waveform_left = split_x + 5
            waveform_right = self.viewer_width - 10
            waveform_top = middle_section_top
            waveform_height = middle_section_height
            self._draw_waveform_in_box(canvas, waveform_left, waveform_top, waveform_right - waveform_left, waveform_height)

            # Overlay feature traces inside waveform box (static); playhead is drawn separately for caching
            if self.features.is_valid:
                self._draw_feature_traces(canvas, waveform_left, waveform_top, waveform_right - waveform_left, waveform_height)
                # Store playhead bounds for fast redraw
                x0, y0 = waveform_left + 5, waveform_top + 25
                x1, y1 = waveform_right - 5, waveform_top + waveform_height - 8
                self._cached_wave_box = (x0, y0, x1, y1)
            
            # BOTTOM: Full-width Spectrogram
            spectro_top = middle_section_top + middle_section_height + 15
            spectro_height = (self.viewer_height - 40) - spectro_top - 10
            if spectro_height > 40:  # Only draw if enough space
                spec_overlays = self._draw_spectrogram(canvas, spectro_top, spectro_height)
                if spec_overlays:
                    text_overlays.extend(spec_overlays)
        
        # Convert to QPixmap
        rgb_image = cv2.cvtColor(canvas, cv2.COLOR_BGR2RGB)
        h, w, ch = rgb_image.shape
        bytes_per_line = ch * w
        qt_image = QImage(rgb_image.data, w, h, bytes_per_line, QImage.Format_RGB888).copy()

        # Draw text overlays with Qt font (single typography)
        painter = QPainter(qt_image)
        painter.setRenderHint(QPainter.TextAntialiasing, True)
        for text, x, y, color, pt in text_overlays:
            font = QFont(self._mono_font)
            font.setPointSize(int(pt))
            painter.setFont(font)
            painter.setPen(QPen(color))
            metrics = QFontMetrics(font)

            # Special case: block text wrapper marker
            if isinstance(text, str) and text.startswith("__BLOCK__"):
                try:
                    header, body = text.split("::", 1)
                    rect_part = header.replace("__BLOCK__", "", 1)
                    rx, ry, rw, rh = [int(v) for v in rect_part.split(",")]
                except Exception:
                    continue

                lines = _wrap_text_to_lines(body, metrics, rw)
                line_h = metrics.height()
                max_lines = max(1, rh // max(1, line_h))
                if len(lines) > max_lines:
                    lines = lines[:max_lines]
                    # mark truncation on last line
                    if lines:
                        last = lines[-1]
                        ell = "…"
                        while last and metrics.horizontalAdvance(last + ell) > rw:
                            last = last[:-1]
                        lines[-1] = (last + ell) if last else ell

                y_cursor = ry + metrics.ascent()
                for ln in lines:
                    painter.drawText(rx, y_cursor, ln)
                    y_cursor += line_h
                continue

            # Normal single-line text: treat y as top-left within the canvas
            baseline_y = int(y) + metrics.ascent()
            painter.drawText(int(x), baseline_y, str(text))
        painter.end()

        self.display_label.setPixmap(QPixmap.fromImage(qt_image))

        # Cache the base render for fast subsequent playhead updates
        if self.audio_data is not None:
            self._cached_base_qimage = qt_image.copy()
            self._cache_dirty = False

    def _draw_feature_traces(self, canvas: np.ndarray, left: int, top: int, width: int, height: int):
        """Draw RMS + onset as small static traces (no playhead)."""
        t = self.features.t
        if t.size < 2:
            return

        # Map to box coords
        x0, y0 = left + 5, top + 25
        x1, y1 = left + width - 5, top + height - 8
        w = max(1, x1 - x0)
        h = max(1, y1 - y0)

        rms_n = _norm01(self.features.rms)
        onset_n = _norm01(self.features.onset)

        # Downsample to fit width
        idxs = np.linspace(0, t.size - 1, w).astype(int)
        rms_s = rms_n[idxs]
        onset_s = onset_n[idxs]

        # Draw traces
        for i in range(1, w):
            y_r0 = y1 - int(rms_s[i - 1] * (h * 0.35))
            y_r1 = y1 - int(rms_s[i] * (h * 0.35))
            cv2.line(canvas, (x0 + i - 1, y_r0), (x0 + i, y_r1), (220, 220, 220), 1)

            y_o0 = y1 - int(onset_s[i - 1] * (h * 0.60))
            y_o1 = y1 - int(onset_s[i] * (h * 0.60))
            cv2.line(canvas, (x0 + i - 1, y_o0), (x0 + i, y_o1), (160, 160, 160), 1)

        # Labels are drawn via Qt to keep typography consistent.
    
    def _draw_waveform_in_box(self, canvas: np.ndarray, left: int, top: int, width: int, height: int):
        """Draw waveform visualization in a specific box with green/cyan colors."""
        if self.audio_data is None:
            return
        
        box_left = left
        box_right = left + width
        box_top = top
        box_bottom = top + height
        box_center = (box_top + box_bottom) // 2
        
        # Draw background box (minimal terminal look)
        cv2.rectangle(canvas, (box_left, box_top), (box_right, box_bottom), (16, 16, 16), -1)
        cv2.rectangle(canvas, (box_left, box_top), (box_right, box_bottom), (50, 50, 50), 1)
        cv2.line(canvas, (box_left, box_center), (box_right, box_center), (40, 40, 40), 1)

        # Label is drawn via Qt to keep typography consistent.
        
        # Waveform drawing area (with margins)
        draw_left = box_left + 5
        draw_right = box_right - 5
        draw_width = draw_right - draw_left
        draw_top = box_top + 25
        draw_bottom = box_bottom - 5
        draw_height = draw_bottom - draw_top
        draw_center = (draw_top + draw_bottom) // 2
        
        # Downsample audio to fit display width
        samples_per_pixel = max(1, len(self.audio_data) // draw_width)
        
        for x in range(draw_width):
            start_idx = x * samples_per_pixel
            end_idx = min(start_idx + samples_per_pixel, len(self.audio_data))
            
            if start_idx < len(self.audio_data):
                # Get min and max in this window
                segment = self.audio_data[start_idx:end_idx]
                if len(segment) > 0:
                    max_val = np.max(segment)
                    min_val = np.min(segment)
                    
                    # Scale to display height
                    y_max = int(draw_center - (max_val * draw_height * 0.45))
                    y_min = int(draw_center - (min_val * draw_height * 0.45))
                    
                    # Draw line with GREEN color (matching active detections)
                    screen_x = draw_left + x
                    cv2.line(canvas, (screen_x, y_max), (screen_x, y_min), (220, 220, 220), 1)
    
    def _draw_spectrogram(self, canvas: np.ndarray, top: int, height: int):
        """
        Draw spectrogram visualization (white/grey on dark background) plus a minimal
        frequency scale (Hz) to give more information from the analysis.
        Returns Qt text overlays: list[(text, x, y, QColor, point_size)].
        """
        if self.audio_data is None or not LIBROSA_AVAILABLE:
            return []
        
        # Label is drawn via Qt to keep typography consistent.
        
        try:
            # Compute spectrogram ONCE per file by caching the normalized matrix
            if not hasattr(self, "_spectro_cache") or self._cache_dirty or getattr(self, "_spectro_cache", None) is None:
                n_fft = 2048
                hop_length = 512
                D = librosa.stft(self.audio_data, n_fft=n_fft, hop_length=hop_length)
                S_db = librosa.amplitude_to_db(np.abs(D), ref=np.max)
                S_normalized = (S_db - S_db.min()) / (S_db.max() - S_db.min() + 1e-8)
                self._spectro_cache = S_normalized.astype(np.float32)
            else:
                S_normalized = self._spectro_cache
            
            # Resize spectrogram to fit display
            margin_left = 10
            margin_right = 10
            box_left = margin_left
            box_right = self.viewer_width - margin_right
            box_width = box_right - box_left
            box_top = top + 20  # Leave space for label
            box_bottom = min(top + height, canvas.shape[0] - 5)
            box_height = box_bottom - box_top
            
            if box_height <= 0:
                return []

            # Reserve a small left gutter for frequency scale (terminal style)
            axis_w = 52
            axis_w = min(axis_w, max(28, box_width // 6))
            spec_left = box_left + axis_w
            spec_right = box_right
            spec_width = max(1, spec_right - spec_left)
            
            # Resize
            S_resized = cv2.resize(S_normalized, (spec_width, box_height), interpolation=cv2.INTER_LINEAR)

            # Vectorized grayscale mapping (white/grey spectrogram on dark background)
            S = np.flipud(S_resized)  # flip vertically
            gamma = 0.60
            gray = (np.power(S.clip(0.0, 1.0), gamma) * 255.0).clip(0, 255).astype(np.uint8)
            img_bgr = np.dstack([gray, gray, gray]).astype(np.uint8)

            y0 = box_top
            y1 = box_bottom
            x0 = spec_left
            x1 = spec_right
            canvas[y0:y1, x0:x1] = img_bgr[: (y1 - y0), : (x1 - x0)]
            
            # Axis gutter background + separator
            cv2.rectangle(canvas, (box_left, box_top), (spec_left, box_bottom), (16, 16, 16), -1)
            cv2.line(canvas, (spec_left, box_top), (spec_left, box_bottom), (50, 50, 50), 1)

            # Draw border around the full spectrogram box
            cv2.rectangle(canvas, (box_left, box_top), (box_right, box_bottom), (50, 50, 50), 1)

            # Frequency ticks (Hz): minimal, readable, cheap to draw
            sr = int(self.sample_rate or 22050)
            nyq = max(1.0, sr / 2.0)
            # Use a small set of informative ticks; clamp to Nyquist.
            base_ticks = [0, 250, 500, 1000, 2000, 4000, 8000, int(nyq)]
            ticks = []
            for f in base_ticks:
                ff = int(min(max(0, f), int(nyq)))
                if ticks and ff == ticks[-1]:
                    continue
                if ff not in ticks:
                    ticks.append(ff)

            overlays: list[tuple[str, int, int, QColor, int]] = []
            dim = QColor(160, 160, 160)
            # Axis label
            overlays.append(("Hz", box_left + 6, box_top - 16, dim, 10))

            for f in ticks:
                # y=0 is top (high freq) because of flipud; 0 Hz at bottom.
                y = int(round((1.0 - (float(f) / nyq)) * (box_height - 1))) + box_top
                y = max(box_top, min(box_bottom - 1, y))
                # Tick mark
                cv2.line(canvas, (spec_left - 6, y), (spec_left - 1, y), (80, 80, 80), 1)
                # Subtle horizontal guide (very low contrast)
                cv2.line(canvas, (spec_left + 1, y), (box_right - 2, y), (26, 26, 26), 1)
                # Text (Qt overlay; y is top-left)
                label = f"{f}" if f < 1000 else (f"{f//1000}k" if f % 1000 == 0 else f"{f/1000.0:.1f}k")
                overlays.append((label, box_left + 6, y - 6, dim, 10))

            return overlays
            
        except Exception as e:
            print(f"Error drawing spectrogram: {e}")
            return []


class CVAnalysisWidget(QLabel):
    """
    Computer vision analysis widget showing edges and structures.
    """
    
    def __init__(self, width: int, height: int):
        super().__init__()
        self.setFixedSize(width, height)
        self.setStyleSheet("background-color: black; border: 1px solid #333;")
    
    def display_cv_image(self, cv_image: np.ndarray, overlays: Optional[list] = None):
        """
        Convert OpenCV BGR image to QPixmap and display.
        overlays: optional list of (text, x, y, QColor, point_size) drawn with Qt typography.
        """
        rgb_image = cv2.cvtColor(cv_image, cv2.COLOR_BGR2RGB)
        h, w, ch = rgb_image.shape
        bytes_per_line = ch * w
        qt_image = QImage(rgb_image.data, w, h, bytes_per_line, QImage.Format_RGB888).copy()

        if overlays:
            painter = QPainter(qt_image)
            painter.setRenderHint(QPainter.TextAntialiasing, True)
            painter.setFont(QApplication.font())
            for text, x, y, color, pt in overlays:
                font = QFont(QApplication.font())
                font.setPointSize(int(pt))
                painter.setFont(font)
                painter.setPen(QPen(color))
                painter.drawText(int(x), int(y), str(text))
            painter.end()

        self.setPixmap(QPixmap.fromImage(qt_image))


class GraphicScoreWidget(QLabel):
    """
    Spectrogram-style scrolling graphic score that captures ACTUAL LIGHT SHAPES.
    If light draws a cat face, you see a cat face in the score.
    
    Works by extracting a vertical profile from each frame:
    - For each Y position, check if light exists anywhere horizontally
    - This preserves curves, circles, spots - the complete light drawing
    """
    
    def __init__(
        self,
        width: int,
        height: int,
        *,
        # Defaults are LEGACY: no decay, dots, no halo.
        # Use CLI flags to enable the more stylized rendering.
        decay: float = 1.0,
        draw_strokes: bool = False,
        halo_enabled: bool = False,
        halo_kernel: int = 9,
        halo_strength: float = 0.65,
        stamp_brightness_min: int = 150,
        style: str = "dots",
        spectro_noise_floor: int = 6,
        spectro_grain: float = 0.18,
        spectro_blur_y: int = 3,
        spectro_log_k: float = 12.0,
        spectro_background_level: int = 235,
        spectro_ink_strength: int = 210,
        spectro_speckle_strength: int = 22,
        spectro_mask_feather: int = 5,
        spectro_intensity_weight: float = 1.0,
        spectro_motion_weight: float = 0.7,
        spectro_profile_smooth: float = 0.35,
        spectro_profile_mode: str = "max",
        spectro_render_mode: str = "profile",
        spectro_slices_per_frame: int = 1,
        spectro_slice_step: int = 1,
    ):
        super().__init__()
        self.score_width = width
        self.score_height = height
        self.setFixedSize(width, height)
        self.setStyleSheet("background-color: black; border: 1px solid #333;")
        
        # Canvas for spectrogram
        self.canvas = np.zeros((height, width, 3), dtype=np.uint8)
        self.scroll_position = 0

        # --- Score aesthetics (rendering only; extraction stays the same) ---
        # Set these to keep readability while adding a more "designed" feeling.
        # Defaults are conservative and aim to preserve the current look.
        #
        # decay: 1.0 disables fading (pure accumulation / long exposure).
        # Slightly below 1.0 creates breathing trails but can make shapes "disappear"
        # if you expect full accumulation.
        self.decay = float(decay)

        # If True, consecutive active Y pixels become continuous strokes instead of isolated dots.
        self.draw_strokes = bool(draw_strokes)

        # Core thickness of stroke/dots (kept small for readability).
        self.core_thickness = 1

        # Halo controls: soft glow around new marks only (not the whole canvas).
        self.halo_enabled = bool(halo_enabled)
        self.halo_kernel = int(halo_kernel)  # odd number; larger = softer/wider glow
        self.halo_strength = float(halo_strength)  # 0..1, additive blend factor

        # Brightness threshold for stamping into the score (post-inversion brightness).
        # Higher = stricter (cleaner), lower = more texture/noise.
        self.stamp_brightness_min = int(stamp_brightness_min)

        # Style: "dots" (legacy), "strokes", "spectrogram"
        self.style = str(style).strip().lower()
        if self.style not in ("dots", "strokes", "spectrogram"):
            self.style = "dots"

        # Spectrogram-style rendering parameters (only used when style == "spectrogram")
        self.spectro_noise_floor = int(spectro_noise_floor)  # 0..30-ish, added as base texture
        self.spectro_grain = float(spectro_grain)  # 0..1 additive grain amount
        self.spectro_blur_y = int(spectro_blur_y)  # 0 disables; otherwise odd kernel-ish strength
        self.spectro_log_k = float(spectro_log_k)  # >0, log compression factor
        self.spectro_background_level = int(spectro_background_level)  # 0..255, paper brightness
        self.spectro_ink_strength = int(spectro_ink_strength)  # 0..255, max darkness from energy
        self.spectro_speckle_strength = int(spectro_speckle_strength)  # 0..80-ish
        self.spectro_mask_feather = int(spectro_mask_feather)  # 0 disables, >0 softens mask edges
        self.spectro_intensity_weight = float(spectro_intensity_weight)
        self.spectro_motion_weight = float(spectro_motion_weight)
        self.spectro_profile_smooth = float(spectro_profile_smooth)  # 0..1 EMA alpha
        self.spectro_profile_mode = str(spectro_profile_mode).strip().lower()
        if self.spectro_profile_mode not in ("max", "mean"):
            self.spectro_profile_mode = "max"

        # Spectrogram render mode:
        # - "profile": true spectrogram behavior (energy vs y per frame) -> strong bands, fewer shapes
        # - "slice": slit-scan energy slices -> preserves shapes over time inside spectrogram paper
        self.spectro_render_mode = str(spectro_render_mode).strip().lower()
        if self.spectro_render_mode not in ("profile", "slice"):
            self.spectro_render_mode = "profile"

        self.spectro_slices_per_frame = int(max(1, spectro_slices_per_frame))
        self.spectro_slice_step = int(max(1, spectro_slice_step))

        # Spectrogram temporal state (for motion + smoothing)
        self._prev_img_scaled: Optional[np.ndarray] = None  # uint8 (H, W)
        self._profile_ema: Optional[np.ndarray] = None  # float32 (H,)

        # If spectrogram style is enabled, initialize the whole canvas as "paper"
        # to avoid the feeling of a cut-out pasted onto a black void (especially right after startup).
        if self.style == "spectrogram":
            self._init_spectrogram_paper()

        # Grid settings
        self.grid_spacing_x = 50  # Vertical lines every N pixels
        self.grid_spacing_y = 40  # Horizontal lines every N pixels
        self.grid_color = (25, 25, 25)  # Dark gray grid

        # Timeline marker settings (dots at top like chronophotography)
        self.timeline_interval = 30  # Dot every N frames
        self.timeline_y = 8  # Y position of timeline dots

    def _init_spectrogram_paper(self):
        """Fill the canvas with a spectrogram-like paper texture (light field + subtle speckle)."""
        bg = float(np.clip(self.spectro_background_level, 0, 255))
        nf = float(np.clip(self.spectro_noise_floor, 0, 80))
        speck = float(np.clip(self.spectro_speckle_strength, 0, 120))
        g = float(max(0.0, self.spectro_grain))

        base = np.full((self.score_height, self.score_width), bg, dtype=np.float32)
        if nf > 0:
            base -= nf
        if speck > 0:
            sp = np.abs(np.random.normal(loc=0.0, scale=1.0, size=base.shape)).astype(np.float32)
            base -= (sp * speck).clip(0, speck * 2.0)
        if g > 0.0:
            rnd = np.random.normal(loc=0.0, scale=1.0, size=base.shape).astype(np.float32)
            base += rnd * (255.0 * g * 0.06)

        out = base.clip(0, 255).astype(np.uint8)
        self.canvas[:, :, 0] = out
        self.canvas[:, :, 1] = out
        self.canvas[:, :, 2] = out

    def _make_paper_column(self) -> np.ndarray:
        """Make one paper-texture column (uint8, shape=(score_height,))."""
        bg = float(np.clip(self.spectro_background_level, 0, 255))
        nf = float(np.clip(self.spectro_noise_floor, 0, 80))
        speck = float(np.clip(self.spectro_speckle_strength, 0, 120))
        g = float(max(0.0, self.spectro_grain))

        base = np.full((self.score_height,), bg, dtype=np.float32)
        if nf > 0:
            base -= nf
        if speck > 0:
            sp = np.abs(np.random.normal(loc=0.0, scale=1.0, size=base.shape)).astype(np.float32)
            base -= (sp * speck).clip(0, speck * 2.0)
        if g > 0.0:
            rnd = np.random.normal(loc=0.0, scale=1.0, size=base.shape).astype(np.float32)
            base += rnd * (255.0 * g * 0.06)

        return base.clip(0, 255).astype(np.uint8)

    def _render_spectrogram_energy_column(self, *, dst_x: int, col_energy: np.ndarray):
        """
        Render one column from a 1D energy array (0..1) as dark ink on paper.
        This is used by both profile and slice-based spectrogram modes.
        """
        col_energy = col_energy.astype(np.float32).clip(0.0, 1.0)

        # Log compression
        k = max(0.01, float(self.spectro_log_k))
        col_energy = np.log1p(k * col_energy) / np.log1p(k)

        # Optional vertical blur
        if self.spectro_blur_y and self.spectro_blur_y > 0:
            col_img = col_energy.reshape((-1, 1))
            ks = int(2 * self.spectro_blur_y + 1)
            if ks % 2 == 0:
                ks += 1
            col_img = cv2.GaussianBlur(col_img, (1, ks), 0)
            col_energy = col_img.reshape((-1,))

        bg_col = self._make_paper_column().astype(np.float32)
        ink = float(np.clip(self.spectro_ink_strength, 0, 255))
        out = (bg_col - (col_energy * ink)).clip(0, 255).astype(np.uint8)

        self.canvas[:, dst_x, 0] = out
        self.canvas[:, dst_x, 1] = out
        self.canvas[:, dst_x, 2] = out
    
    def _draw_glow_dot(self, cy: int, cx: int, radius: int, brightness: int):
        """
        Draw a soft circular dot with glow effect (chronophotography style).
        Uses additive blending so overlapping dots become brighter.
        """
        for dy in range(-radius-1, radius + 2):
            for dx in range(-radius-1, radius + 2):
                y, x = cy + dy, cx + dx
                if 0 <= y < self.score_height and 0 <= x < self.score_width:
                    # Distance from center
                    dist = (dy*dy + dx*dx) ** 0.5
                    if dist <= radius + 1:
                        # Soft falloff from center (gaussian-like)
                        if dist <= radius * 0.5:
                            falloff = 1.0  # Core is full brightness
                        else:
                            falloff = 1.0 - ((dist - radius * 0.5) / (radius * 0.5 + 1))
                        falloff = max(0, falloff)
                        
                        pixel_brightness = int(brightness * falloff)
                        if pixel_brightness > 0:
                            # Additive blend
                            current = int(self.canvas[y, x, 0])
                            new_val = min(255, current + pixel_brightness)
                            self.canvas[y, x, :] = (new_val, new_val, new_val)

    def _apply_decay(self):
        """Apply a gentle decay to the canvas to create breathable trails."""
        if self.decay >= 0.9995:
            return
        if self.decay <= 0.0:
            self.canvas[:, :, :] = 0
            return
        # Multiply in float then convert back to uint8.
        decayed = (self.canvas.astype(np.float32) * float(self.decay)).clip(0, 255).astype(np.uint8)
        self.canvas[:, :, :] = decayed

    def _add_halo_roi(self, x: int, y0: int, y1: int):
        """
        Add a soft halo around the newly drawn marks in a small ROI.
        This keeps the core crisp while giving a more luminous feeling.
        """
        if not self.halo_enabled or self.halo_strength <= 0:
            return
        k = int(self.halo_kernel)
        if k < 3:
            return
        if k % 2 == 0:
            k += 1

        pad = max(3, k // 2 + 1)
        x0 = max(0, x - pad)
        x1 = min(self.score_width, x + pad + 1)
        yy0 = max(0, y0 - pad)
        yy1 = min(self.score_height, y1 + pad + 1)
        if x1 <= x0 or yy1 <= yy0:
            return

        roi = self.canvas[yy0:yy1, x0:x1, :]
        if roi.size == 0:
            return

        blurred = cv2.GaussianBlur(roi, (k, k), 0)
        out = roi.astype(np.float32) + blurred.astype(np.float32) * float(self.halo_strength)
        self.canvas[yy0:yy1, x0:x1, :] = out.clip(0, 255).astype(np.uint8)

    @staticmethod
    def _group_consecutive_indices(idxs: np.ndarray) -> list[tuple[int, int]]:
        """Group sorted indices into inclusive runs [(start, end), ...]."""
        if idxs.size == 0:
            return []
        runs: list[tuple[int, int]] = []
        start = int(idxs[0])
        prev = int(idxs[0])
        for v in idxs[1:]:
            vi = int(v)
            if vi == prev + 1:
                prev = vi
                continue
            runs.append((start, prev))
            start = vi
            prev = vi
        runs.append((start, prev))
        return runs

    def _render_spectrogram_column(
        self,
        *,
        dst_x: int,
        mask_scaled: np.ndarray,
        img_scaled: np.ndarray,
        src_x: int,
    ):
        """
        Render a full vertical intensity column with a spectrogram-like texture:
        - log compression (brings out mid-level detail)
        - noise floor (paper / sensor grain feel)
        - vertical blur (soft diffusion without losing the ridge)
        """
        # Compute energy from inverted grayscale: darker => higher energy (0..1)
        col_energy = (255.0 - img_scaled[:, src_x].astype(np.float32)) / 255.0

        # Mask (softened) to avoid the "cut-out" feeling while keeping object definition.
        col_mask = (mask_scaled[:, src_x] > 0).astype(np.float32)
        mf = int(max(0, self.spectro_mask_feather))
        if mf > 0:
            m_img = col_mask.reshape((-1, 1))
            ks = int(2 * mf + 1)
            if ks % 2 == 0:
                ks += 1
            m_img = cv2.GaussianBlur(m_img, (1, ks), 0)
            col_mask = m_img.reshape((-1,)).clip(0.0, 1.0)

        # Soft threshold ramp (keeps your strictness but preserves gradients -> more spectrogram-like ridges)
        gate = float(self.stamp_brightness_min) / 255.0
        denom = max(1e-6, 1.0 - gate)
        col_energy = ((col_energy - gate) / denom).clip(0.0, 1.0)

        # Log compression to get that spectrogram dynamic range
        k = max(0.01, float(self.spectro_log_k))
        col_energy = np.log1p(k * col_energy) / np.log1p(k)

        # Apply mask softly (edges feather into the field instead of hard clipping)
        col_energy *= col_mask

        # Optional vertical blur to make it feel like "ink in paper"
        if self.spectro_blur_y and self.spectro_blur_y > 0:
            col_img = col_energy.reshape((-1, 1))
            ks = int(2 * self.spectro_blur_y + 1)
            if ks % 2 == 0:
                ks += 1
            col_img = cv2.GaussianBlur(col_img, (1, ks), 0)
            col_energy = col_img.reshape((-1,))

        # --- Map to spectrogram look: light paper background, dark ink features ---
        bg = float(np.clip(self.spectro_background_level, 0, 255))
        ink = float(np.clip(self.spectro_ink_strength, 0, 255))
        nf = float(np.clip(self.spectro_noise_floor, 0, 80))
        speck = float(np.clip(self.spectro_speckle_strength, 0, 120))

        # Base paper texture (always present, prevents the "sticker on black" feeling)
        # Start near bg, then subtract a small noise floor to create light gray fog.
        base = np.full((self.score_height,), bg, dtype=np.float32)
        if nf > 0:
            base -= nf

        # Speckle: dark dots on paper (like spectrogram grain)
        if speck > 0:
            # Absolute normal gives mostly small specks with occasional stronger ones.
            sp = np.abs(np.random.normal(loc=0.0, scale=1.0, size=base.shape)).astype(np.float32)
            base -= (sp * speck).clip(0, speck * 2.0)

        # Grain: small ± variations (film/paper feel)
        g = float(max(0.0, self.spectro_grain))
        if g > 0.0:
            rnd = np.random.normal(loc=0.0, scale=1.0, size=base.shape).astype(np.float32)
            base += rnd * (255.0 * g * 0.06)

        # Ink darkness from energy (embedded into the field)
        darkness = (col_energy.clip(0.0, 1.0) * ink)
        out = (base - darkness).clip(0, 255).astype(np.uint8)

        # Stamp into canvas (write grayscale into all channels)
        self.canvas[:, dst_x, 0] = out
        self.canvas[:, dst_x, 1] = out
        self.canvas[:, dst_x, 2] = out

    def _render_spectrogram_profile_column(self, *, dst_x: int, profile: np.ndarray):
        """
        Render a spectrogram column from a vertical energy profile (0..1).
        This matches spectrogram logic better than stamping a spatial slice.
        """
        self._render_spectrogram_energy_column(dst_x=dst_x, col_energy=profile)
    
    def update_score_from_frame(self, adjusted_inverted: np.ndarray, detections: Optional[list] = None):
        """
        Extract light shapes and draw them like chronophotography:
        WHITE/bright traces on BLACK background.
        
        In inverted image: DARK pixels = BRIGHT light (the refractions)
        
        Args:
            adjusted_inverted: The adjusted inverted grayscale image from CV panel
            detections: Optional list of detections (bbox) to drive a softer "embedded" mask in spectrogram mode
        """
        # Gentle decay first (breathing trails without losing structure)
        self._apply_decay()

        # How many pixels to add per frame (controls scroll speed)
        # In spectrogram slice mode we can stamp multiple columns per frame to preserve more shape detail.
        if self.style == "spectrogram" and self.spectro_render_mode == "slice":
            stamp_width = int(max(1, self.spectro_slices_per_frame))
        else:
            stamp_width = 1  # Single pixel for smoother motion
        
        # Scroll the canvas RIGHT (content moves right, new content on left)
        self.canvas[:, stamp_width:, :] = self.canvas[:, :-stamp_width, :]

        # Clear the leftmost area (where new content goes)
        if self.style == "spectrogram":
            # Keep the field continuous: clear to paper texture, not black.
            for dx in range(stamp_width):
                col = self._make_paper_column()
                self.canvas[:, dx, 0] = col
                self.canvas[:, dx, 1] = col
                self.canvas[:, dx, 2] = col
        else:
            self.canvas[:, :stamp_width, :] = (0, 0, 0)
        
        # Build a mask for "where the object lives".
        # - Legacy modes: pixel threshold mask on inverted image (existing behavior)
        # - Spectrogram mode: prefer bbox-driven mask from detections to avoid hard cut-outs
        light_threshold = 70  # Lower = stricter, only very dark pixels (bright light)

        use_det_mask = self.style == "spectrogram" and bool(detections)
        if use_det_mask:
            det_mask = np.zeros_like(adjusted_inverted, dtype=np.uint8)
            for det in detections or []:
                bbox = None
                if isinstance(det, dict):
                    bbox = det.get("bbox")
                if not bbox or len(bbox) != 4:
                    continue
                x, y, w, h = bbox
                if w <= 0 or h <= 0:
                    continue
                x0 = max(0, int(x))
                y0 = max(0, int(y))
                x1 = min(det_mask.shape[1], int(x + w))
                y1 = min(det_mask.shape[0], int(y + h))
                if x1 > x0 and y1 > y0:
                    det_mask[y0:y1, x0:x1] = 255
            light_mask = det_mask
        else:
            light_mask = (adjusted_inverted < light_threshold).astype(np.uint8) * 255

        # Clean up mask only for legacy (bbox mask feathering happens later inside spectrogram renderer)
        if not use_det_mask:
            kernel_open = np.ones((2, 2), np.uint8)
            kernel_close = np.ones((3, 3), np.uint8)
            light_mask = cv2.morphologyEx(light_mask, cv2.MORPH_OPEN, kernel_open)
            light_mask = cv2.morphologyEx(light_mask, cv2.MORPH_CLOSE, kernel_close)
        
        # Scale to fit score dimensions while preserving shapes
        source_h, source_w = light_mask.shape[:2]
        
        # Scale to score height, keep proportional width then sample
        scale_factor = self.score_height / source_h
        scaled_w = int(source_w * scale_factor)
        
        mask_scaled = cv2.resize(light_mask, (scaled_w, self.score_height),
                                 interpolation=cv2.INTER_NEAREST)
        img_scaled = cv2.resize(adjusted_inverted, (scaled_w, self.score_height),
                               interpolation=cv2.INTER_LINEAR)
        
        # Spectrogram style: build a vertical energy profile from the whole frame (not a single x slice)
        dst_x = 0 if self.style == "spectrogram" else 2

        if self.style == "spectrogram":
            # Intensity energy (0..1): darker in inverted => higher energy
            intensity = (255.0 - img_scaled.astype(np.float32)) / 255.0

            # Mask (0..1) with feathering already handled later in column render, but here we need occupancy.
            mask01 = (mask_scaled > 0).astype(np.float32)

            # Motion energy (0..1) from frame difference in the same scaled space
            motion = np.zeros_like(intensity, dtype=np.float32)
            if self._prev_img_scaled is not None and self._prev_img_scaled.shape == img_scaled.shape:
                motion = (np.abs(img_scaled.astype(np.float32) - self._prev_img_scaled.astype(np.float32)) / 255.0)
            self._prev_img_scaled = img_scaled.copy()

            iw = max(0.0, float(self.spectro_intensity_weight))
            mw = max(0.0, float(self.spectro_motion_weight))
            energy = (iw * intensity + mw * motion).clip(0.0, 1.0)
            energy *= mask01

            # Soft threshold ramp (preserve gradients)
            gate = float(self.stamp_brightness_min) / 255.0
            denom = max(1e-6, 1.0 - gate)
            energy = ((energy - gate) / denom).clip(0.0, 1.0)

            if self.spectro_render_mode == "slice":
                # Slit-scan energy slices (preserves shapes over time).
                # Sweep across the scaled image as time advances.
                base_x = int((self.scroll_position * stamp_width) % max(1, scaled_w))
                for i in range(stamp_width):
                    x = int((base_x + i * self.spectro_slice_step) % max(1, scaled_w))
                    col = energy[:, x]
                    self._render_spectrogram_energy_column(dst_x=i, col_energy=col)
            else:
                # True spectrogram profile (strong bands, less shape detail).
                if self.spectro_profile_mode == "mean":
                    denom_m = np.maximum(1e-6, mask01.sum(axis=1))
                    profile = (energy.sum(axis=1) / denom_m).astype(np.float32)
                else:
                    profile = energy.max(axis=1).astype(np.float32)

                # Temporal smoothing (EMA) to create ridge continuity
                a = float(np.clip(self.spectro_profile_smooth, 0.0, 1.0))
                if self._profile_ema is None or self._profile_ema.shape != profile.shape:
                    self._profile_ema = profile.copy()
                else:
                    self._profile_ema = (1.0 - a) * self._profile_ema + a * profile

                self._render_spectrogram_profile_column(dst_x=dst_x, profile=self._profile_ema)
        else:
            # Sample a slice from the scaled mask (slit-scan style)
            # Use modulo to sweep across the image over time
            sample_x = (self.scroll_position * stamp_width) % scaled_w
            src_x = int(sample_x % scaled_w)
            col_mask = mask_scaled[:, src_x] > 0
            # Brightness computed from inverted grayscale: darker = brighter mark
            col_brightness = (255 - img_scaled[:, src_x]).astype(np.int16)
            active = col_mask & (col_brightness >= int(self.stamp_brightness_min))
            active_idxs = np.flatnonzero(active)

            use_strokes = self.draw_strokes or (self.style == "strokes")

            if use_strokes:
                # Turn vertical runs into strokes for a cleaner, more calligraphic look.
                runs = self._group_consecutive_indices(active_idxs)
                for y0, y1 in runs:
                    run_len = y1 - y0 + 1
                    peak = int(np.clip(col_brightness[y0:y1 + 1].max(), 0, 255))
                    # Keep the core crisp
                    if run_len <= 2:
                        self.canvas[y0, dst_x, :] = (peak, peak, peak)
                        if run_len == 2:
                            self.canvas[y1, dst_x, :] = (peak, peak, peak)
                        self._add_halo_roi(dst_x, y0, y1)
                        continue

                    # Stroke thickness depends slightly on brightness, capped for readability.
                    thickness = int(self.core_thickness)
                    if peak >= 230:
                        thickness = max(thickness, 2)

                    # Draw a continuous vertical stroke
                    cv2.line(self.canvas, (dst_x, y0), (dst_x, y1), (peak, peak, peak), thickness=thickness)

                    # Add a subtle, soft halo around this run only
                    self._add_halo_roi(dst_x, y0, y1)
            else:
                # Original dot-based aesthetic
                for y in active_idxs.tolist():
                    b = int(np.clip(col_brightness[y], 0, 255))
                    if b > 230:
                        radius = 3
                    elif b > 200:
                        radius = 2
                    elif b > 170:
                        radius = 1
                    else:
                        radius = 0

                    if radius > 0:
                        self._draw_glow_dot(int(y), dst_x, radius, b)
                    else:
                        self.canvas[int(y), dst_x, :] = (b, b, b)
        
        # Add timeline marker dot at top (like chronophotography reference)
        if self.scroll_position % self.timeline_interval == 0:
            self._draw_glow_dot(self.timeline_y, dst_x, 1, 180)
        
        # Advance scroll position
        self.scroll_position += 1
        
        # Create display with grid overlay
        display = self.canvas.copy()
        
        # Draw grid lines
        if self.style == "spectrogram":
            # On light paper, grid is a gentle darkening (not "only on black").
            # Keep it subtle and avoid crushing the darkest ink regions.
            darken = 14

            for y in range(0, self.score_height, self.grid_spacing_y):
                row = display[y, :, 0].astype(np.int16)
                mask = row > 70  # don't touch very dark ink
                row[mask] = np.clip(row[mask] - darken, 0, 255)
                display[y, :, 0] = row.astype(np.uint8)
                display[y, :, 1] = display[y, :, 0]
                display[y, :, 2] = display[y, :, 0]

            for x in range(0, self.score_width, self.grid_spacing_x):
                col = display[:, x, 0].astype(np.int16)
                mask = col > 70
                col[mask] = np.clip(col[mask] - darken, 0, 255)
                display[:, x, 0] = col.astype(np.uint8)
                display[:, x, 1] = display[:, x, 0]
                display[:, x, 2] = display[:, x, 0]
        else:
            # Legacy behavior: draw grid only on dark background.
            for y in range(0, self.score_height, self.grid_spacing_y):
                for x in range(self.score_width):
                    if display[y, x, 0] < 50:  # Only on dark pixels
                        display[y, x, :] = self.grid_color

            for x in range(0, self.score_width, self.grid_spacing_x):
                for y in range(self.score_height):
                    if display[y, x, 0] < 50:  # Only on dark pixels
                        display[y, x, :] = self.grid_color
        
        # Subtle cursor line (on left where new content appears)
        cursor_x = stamp_width + 1
        if cursor_x < self.score_width:
            for y in range(self.score_height):
                if display[y, cursor_x, 0] < 100:
                    display[y, cursor_x, :] = (0, 80, 0)
        
        # Display
        self.display_cv_image(display)
    
    def display_cv_image(self, cv_image: np.ndarray):
        """Convert OpenCV BGR image to QPixmap and display."""
        rgb_image = cv2.cvtColor(cv_image, cv2.COLOR_BGR2RGB)
        h, w, ch = rgb_image.shape
        bytes_per_line = ch * w
        qt_image = QImage(rgb_image.data, w, h, bytes_per_line, QImage.Format_RGB888)
        self.setPixmap(QPixmap.fromImage(qt_image))


class IMOLGraphicScoreWindow(QMainWindow):
    """
    Main window for IMOL CV Graphic Score system.
    """
    
    def __init__(self, args):
        super().__init__()
        self.args = args
        
        # Window setup
        self.setWindowTitle("IMOL - Graphic Score System")
        self.setFixedSize(args.window_width, args.window_height)
        
        # Dark theme
        self.set_dark_theme()
        
        # CV processing state
        self.cap = None
        self.geometry_analyzer = LightGeometryAnalyzer(history_size=30)
        self.frame_count = 0
        self.bg_learning_frames = args.bg_learning
        self.learning_phase = True
        self.current_features = None
        
        # Image processing controls for second CV panel
        self.contrast = 1.0      # 0.5 to 3.0
        self.brightness = 0      # -100 to 100
        self.gamma = 1.0         # 0.4 to 2.5
        
        # Temporal tracking for light refractions
        self.detection_history = deque(maxlen=10)  # Last 10 frames
        self.stable_detections = {}  # Track static detections to filter them out

        # OSC tracker-style /track/A..F state (CV-driven)
        self._track_letters = list("ABCDEF")
        self._track_prev_centers: list[tuple[float, float]] = [(0.0, 0.0) for _ in range(6)]
        self._track_prev_boxes: list[tuple[float, float, float, float]] = [(0.0, 0.0, 0.0, 0.0) for _ in range(6)]
        self._track_last_sent: list[tuple[float, float, float, float, float, float, float, float]] = [
            (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) for _ in range(6)
        ]
        self._track_last_send_monotonic: float = 0.0
        
        # Calculate panel dimensions
        self.panel_width = args.window_width // 2

        # OSC client for pattern controller (must exist before build_ui() wiring)
        self.osc_client = None
        self.osc_track_client = None
        if OSC_AVAILABLE and bool(getattr(args, "osc_out_enable", False)):
            try:
                self.osc_client = SimpleUDPClient(args.osc_out_host, int(args.osc_out_port))
            except Exception:
                self.osc_client = None

        # Optional separate OSC destination for tracker streams (Max)
        try:
            if OSC_AVAILABLE and bool(getattr(args, "osc_out_enable", False)) and str(getattr(args, "osc_out_format", "pattern")).strip().lower() == "tracker":
                host_t = str(getattr(args, "osc_track_host", "127.0.0.1"))
                port_t = int(getattr(args, "osc_track_port", 9001))
                # In tracker format we may always send lightweight /system/state + /vel/*,
                # even if the user disables /track/* and /feat/*, so create the track client.
                self.osc_track_client = SimpleUDPClient(host_t, port_t)
        except Exception:
            self.osc_track_client = None

        # Build UI
        self.build_ui()
        
        # Initialize camera
        self.init_camera()
        
        # Start update timer
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_frame)
        self.timer.start(int(1000 / args.fps))
    
    def set_dark_theme(self):
        """Set dark theme for the window."""
        palette = QPalette()
        palette.setColor(QPalette.Window, QColor(20, 20, 20))
        palette.setColor(QPalette.WindowText, QColor(200, 200, 200))
        palette.setColor(QPalette.Base, QColor(25, 25, 25))
        palette.setColor(QPalette.AlternateBase, QColor(30, 30, 30))
        palette.setColor(QPalette.Text, QColor(200, 200, 200))
        palette.setColor(QPalette.Button, QColor(40, 40, 40))
        palette.setColor(QPalette.ButtonText, QColor(200, 200, 200))
        self.setPalette(palette)
    
    def build_ui(self):
        """Build the Qt UI layout."""
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(0, 0, 0, 0)
        main_layout.setSpacing(0)
        
        # Row 1: CV Process + Audio Analysis (fill entire top area)
        top_row = QHBoxLayout()
        top_row.setContentsMargins(0, 0, 0, 0)
        top_row.setSpacing(0)
        
        # Left: CV Process with controls
        cv_container = QWidget()
        cv_container.setFixedSize(self.panel_width, self.args.top_panel_height)
        cv_layout = QVBoxLayout(cv_container)
        cv_layout.setContentsMargins(0, 0, 0, 0)
        cv_layout.setSpacing(0)
        
        # Minimal control panel with modern styling
        control_widget = QWidget()
        control_widget.setStyleSheet("""
            QWidget {
                background-color: #1a1a1a;
                border: 1px solid #333;
            }
            QLabel {
                color: #b0b0b0;
                font-family: 'SF Pro Display', 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
                font-size: 11px;
                font-weight: 500;
            }
            QSlider::groove:horizontal {
                border: none;
                height: 3px;
                background: #333;
            }
            QSlider::handle:horizontal {
                background: #0a84ff;
                border: none;
                width: 10px;
                margin: -3px 0;
                border-radius: 5px;
            }
        """)
        control_widget.setFixedHeight(50)
        control_layout = QHBoxLayout(control_widget)
        control_layout.setContentsMargins(8, 4, 8, 4)
        control_layout.setSpacing(15)
        
        # Contrast
        contrast_label = QLabel("1.0")
        contrast_label.setFixedWidth(32)
        contrast_label.setStyleSheet("color: #0a84ff; font-family: 'SF Mono', 'Consolas', monospace; font-size: 11px; font-weight: 500;")
        self.contrast_slider = QSlider(Qt.Horizontal)
        self.contrast_slider.setMinimum(50)
        self.contrast_slider.setMaximum(300)
        self.contrast_slider.setValue(100)
        self.contrast_slider.setFixedWidth(120)
        self.contrast_slider.valueChanged.connect(
            lambda v: self.update_contrast(v, contrast_label)
        )
        control_layout.addWidget(QLabel("C:"))
        control_layout.addWidget(self.contrast_slider)
        control_layout.addWidget(contrast_label)
        
        # Brightness
        brightness_label = QLabel("0")
        brightness_label.setFixedWidth(32)
        brightness_label.setStyleSheet("color: #0a84ff; font-family: 'SF Mono', 'Consolas', monospace; font-size: 11px; font-weight: 500;")
        self.brightness_slider = QSlider(Qt.Horizontal)
        self.brightness_slider.setMinimum(-100)
        self.brightness_slider.setMaximum(100)
        self.brightness_slider.setValue(0)
        self.brightness_slider.setFixedWidth(120)
        self.brightness_slider.valueChanged.connect(
            lambda v: self.update_brightness(v, brightness_label)
        )
        control_layout.addWidget(QLabel("B:"))
        control_layout.addWidget(self.brightness_slider)
        control_layout.addWidget(brightness_label)
        
        # Gamma
        gamma_label = QLabel("1.0")
        gamma_label.setFixedWidth(32)
        gamma_label.setStyleSheet("color: #0a84ff; font-family: 'SF Mono', 'Consolas', monospace; font-size: 11px; font-weight: 500;")
        self.gamma_slider = QSlider(Qt.Horizontal)
        self.gamma_slider.setMinimum(40)
        self.gamma_slider.setMaximum(250)
        self.gamma_slider.setValue(100)
        self.gamma_slider.setFixedWidth(120)
        self.gamma_slider.valueChanged.connect(
            lambda v: self.update_gamma(v, gamma_label)
        )
        control_layout.addWidget(QLabel("G:"))
        control_layout.addWidget(self.gamma_slider)
        control_layout.addWidget(gamma_label)
        
        control_layout.addStretch()
        
        cv_layout.addWidget(control_widget)
        
        # CV analysis display (fills remaining space)
        cv_display_height = self.args.top_panel_height - 50
        self.cv_widget = CVAnalysisWidget(self.panel_width, cv_display_height)
        cv_layout.addWidget(self.cv_widget)
        
        # Right: Audio Analysis (fills entire right side)
        self.audio_viewer = AudioViewerWidget(self.panel_width, self.args.top_panel_height)
        self.audio_viewer.load_button.clicked.connect(self.audio_viewer.select_folder)
        self.audio_viewer.set_osc(
            enabled=bool(self.args.osc_out_enable),
            client_pattern=self.osc_client,
            pattern_max=int(self.args.osc_pattern_max),
            osc_format=str(getattr(self.args, "osc_out_format", "pattern")),
            send_features=bool(getattr(self.args, "osc_out_send_features", False)),
            send_rate_hz=float(getattr(self.args, "osc_out_rate_hz", 20.0)),
            client_track=self.osc_track_client,
            tracker_system_rate_hz=float(getattr(self.args, "osc_tracker_system_rate_hz", 10.0)),
            tracker_vel_value_rate_hz=float(getattr(self.args, "osc_tracker_vel_value_rate_hz", 10.0)),
            tracker_feat_rate_hz=float(getattr(self.args, "osc_tracker_feat_rate_hz", 5.0)),
            tracker_system_min_delta=float(getattr(self.args, "osc_tracker_system_min_delta", 0.01)),
            tracker_vel_value_min_delta=float(getattr(self.args, "osc_tracker_vel_value_min_delta", 0.01)),
            tracker_feat_min_delta=float(getattr(self.args, "osc_tracker_feat_min_delta", 0.02)),
            tracker_vel_level_hold_s=float(getattr(self.args, "osc_tracker_vel_level_hold_s", 0.25)),
        )
        
        top_row.addWidget(cv_container)
        top_row.addWidget(self.audio_viewer)
        
        # Row 2: Partiture (Graphic Score) - fills remaining height
        score_height = self.args.window_height - self.args.top_panel_height
        self.score_widget = GraphicScoreWidget(
            self.args.window_width,
            score_height,
            decay=self.args.score_decay,
            draw_strokes=self.args.score_strokes,
            halo_enabled=self.args.score_halo,
            halo_kernel=self.args.score_halo_kernel,
            halo_strength=self.args.score_halo_strength,
            stamp_brightness_min=self.args.score_stamp_min_brightness,
            style=self.args.score_style,
            spectro_noise_floor=self.args.score_spectro_noise_floor,
            spectro_grain=self.args.score_spectro_grain,
            spectro_blur_y=self.args.score_spectro_blur_y,
            spectro_log_k=self.args.score_spectro_log_k,
            spectro_background_level=self.args.score_spectro_background_level,
            spectro_ink_strength=self.args.score_spectro_ink_strength,
            spectro_speckle_strength=self.args.score_spectro_speckle_strength,
            spectro_mask_feather=self.args.score_spectro_mask_feather,
            spectro_intensity_weight=self.args.score_spectro_intensity_weight,
            spectro_motion_weight=self.args.score_spectro_motion_weight,
            spectro_profile_smooth=self.args.score_spectro_profile_smooth,
            spectro_profile_mode=self.args.score_spectro_profile_mode,
            spectro_render_mode=self.args.score_spectro_render_mode,
            spectro_slices_per_frame=self.args.score_spectro_slices_per_frame,
            spectro_slice_step=self.args.score_spectro_slice_step,
        )
        
        # Add rows to main layout
        main_layout.addLayout(top_row)
        main_layout.addWidget(self.score_widget)
        
        central_widget.setLayout(main_layout)
    
    def init_camera(self):
        """Initialize camera."""
        self.cap = cv2.VideoCapture(self.args.camera_index, cv2.CAP_ANY)
        if not self.cap.isOpened():
            print(f"Warning: Could not open camera at index {self.args.camera_index}")
            return
        
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
    
    def update_contrast(self, value: int, label: QLabel):
        """Update contrast value from slider (50-300 -> 0.5-3.0)."""
        self.contrast = value / 100.0
        label.setText(f"{self.contrast:.1f}")
    
    def update_brightness(self, value: int, label: QLabel):
        """Update brightness value from slider (-100 to 100)."""
        self.brightness = value
        label.setText(f"{value}")
    
    def update_gamma(self, value: int, label: QLabel):
        """Update gamma value from slider (40-250 -> 0.4-2.5)."""
        self.gamma = value / 100.0
        label.setText(f"{self.gamma:.1f}")
    
    def apply_image_adjustments(self, gray_image: np.ndarray) -> np.ndarray:
        """
        Apply contrast, brightness, and gamma adjustments to grayscale image.
        """
        # Convert to float for processing
        img = gray_image.astype(np.float32)
        
        # Apply contrast (multiply)
        img = img * self.contrast
        
        # Apply brightness (add)
        img = img + self.brightness
        
        # Clip to valid range
        img = np.clip(img, 0, 255)
        
        # Apply gamma correction (curves)
        if self.gamma != 1.0:
            inv_gamma = 1.0 / self.gamma
            table = np.array([((i / 255.0) ** inv_gamma) * 255 for i in range(256)]).astype("uint8")
            img = cv2.LUT(img.astype(np.uint8), table)
        else:
            img = img.astype(np.uint8)
        
        return img
    
    def detect_all_bright_regions(self, frame_bgr: np.ndarray, inverted_gray: np.ndarray) -> dict:
        """
        Detect ALL bright regions in frame (not just moving ones).
        This captures the complete light field to show the full "light drawing".
        
        Returns all bright spots/patterns regardless of whether they're moving or static.
        """
        # Get grayscale and apply adjustments
        gray_original = cv2.cvtColor(frame_bgr, cv2.COLOR_BGR2GRAY)
        adjusted_original = self.apply_image_adjustments(gray_original)
        
        # Threshold for BRIGHT regions (capture ALL bright light)
        _, bright_mask = cv2.threshold(adjusted_original, 180, 255, cv2.THRESH_BINARY)
        
        # Cleanup morphology
        kernel = np.ones((3, 3), np.uint8)
        bright_mask = cv2.morphologyEx(bright_mask, cv2.MORPH_OPEN, kernel, iterations=1)
        bright_mask = cv2.morphologyEx(bright_mask, cv2.MORPH_CLOSE, kernel, iterations=2)
        
        # For visualization: use the inverted adjusted image
        adjusted_inverted = self.apply_image_adjustments(inverted_gray)
        
        # Find contours of ALL bright regions
        contours, _ = cv2.findContours(bright_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        detections = []
        
        for cnt in contours:
            area = cv2.contourArea(cnt)
            
            # Filter only tiny noise
            if area < 10:
                continue
            
            # Skip extremely large regions (likely full background)
            if area > 8000:
                continue
            
            # Get bounding box and centroid
            x, y, w, h = cv2.boundingRect(cnt)
            
            M = cv2.moments(cnt)
            if M["m00"] > 0:
                cx = int(M["m10"] / M["m00"])
                cy = int(M["m01"] / M["m00"])
            else:
                cx, cy = x + w//2, y + h//2
            
            # Calculate mean intensity
            mask_region = np.zeros(adjusted_original.shape, dtype=np.uint8)
            cv2.drawContours(mask_region, [cnt], -1, 255, -1)
            mean_intensity = cv2.mean(adjusted_original, mask=mask_region)[0]
            
            # Only accept bright regions
            if mean_intensity < 150:
                continue
            
            # Create detection ID for tracking
            detection_id = f"{cx//20}_{cy//20}"
            
            detections.append({
                'bbox': (x, y, w, h),
                'center': (cx, cy),
                'area': area,
                'size': int(np.sqrt(area)),
                'intensity': mean_intensity,
                'id': detection_id,
                'is_active': True  # All are "active" for drawing purposes
            })
        
        return {
            'binary': bright_mask,
            'detections': detections,
            'adjusted_inverted': adjusted_inverted
        }
    
    def detect_light_refractions_advanced(self, frame_bgr: np.ndarray, inverted_gray: np.ndarray) -> dict:
        """
        Advanced light refraction detection using multi-stage pipeline.
        
        Pipeline:
        1. Background subtraction (remove static objects)
        2. Brightness filtering (only bright spots)
        3. Shape analysis (light-like features)
        4. Temporal tracking (filter static detections)
        """
        # Stage 1: Background Subtraction - detect moving/changing elements
        fg_mask = self.geometry_analyzer.bg_subtractor.apply(frame_bgr, learningRate=0.001)
        
        # Clean up the foreground mask
        kernel = np.ones((3, 3), np.uint8)
        fg_mask = cv2.morphologyEx(fg_mask, cv2.MORPH_OPEN, kernel, iterations=1)
        fg_mask = cv2.morphologyEx(fg_mask, cv2.MORPH_CLOSE, kernel, iterations=2)
        
        # Stage 2: Brightness filtering - focus on bright regions in original frame
        gray_original = cv2.cvtColor(frame_bgr, cv2.COLOR_BGR2GRAY)
        
        # Apply adjustments to the original gray (not inverted) for brightness detection
        adjusted_original = self.apply_image_adjustments(gray_original)
        
        # Threshold for BRIGHT regions (high intensity in original)
        _, bright_mask = cv2.threshold(adjusted_original, 180, 255, cv2.THRESH_BINARY)
        
        # Combine foreground mask with brightness mask
        # Only keep detections that are BOTH moving/changing AND bright
        combined_mask = cv2.bitwise_and(fg_mask, bright_mask)
        
        # Additional cleanup
        combined_mask = cv2.morphologyEx(combined_mask, cv2.MORPH_OPEN, kernel, iterations=1)
        
        # For visualization: use the inverted adjusted image as requested
        adjusted_inverted = self.apply_image_adjustments(inverted_gray)
        
        # Stage 3: Find contours and analyze shapes
        contours, _ = cv2.findContours(combined_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        detections = []
        current_detection_set = set()
        
        for cnt in contours:
            area = cv2.contourArea(cnt)
            
            # Filter by minimum area (adjust if needed)
            if area < 10:  # Slightly larger minimum to filter tiny noise
                continue
            
            # Skip very large detections (likely background elements that slipped through)
            if area > 5000:
                continue
            
            # Get bounding box and centroid
            x, y, w, h = cv2.boundingRect(cnt)
            
            M = cv2.moments(cnt)
            if M["m00"] > 0:
                cx = int(M["m10"] / M["m00"])
                cy = int(M["m01"] / M["m00"])
            else:
                cx, cy = x + w//2, y + h//2
            
            # Stage 4: Shape analysis
            perimeter = cv2.arcLength(cnt, True)
            if perimeter == 0:
                continue
            
            # Circularity: 4π × area / perimeter²
            # Perfect circle = 1.0, elongated = lower
            circularity = (4 * np.pi * area) / (perimeter * perimeter) if perimeter > 0 else 0
            
            # Aspect ratio
            aspect_ratio = float(w) / h if h > 0 else 0
            
            # Calculate mean intensity in the bright region
            mask_region = np.zeros(adjusted_original.shape, dtype=np.uint8)
            cv2.drawContours(mask_region, [cnt], -1, 255, -1)
            mean_intensity = cv2.mean(adjusted_original, mask=mask_region)[0]
            
            # Filter by shape characteristics (light refractions are usually somewhat circular or elongated)
            # Accept if: reasonably circular OR elongated (beam-like)
            is_circular = circularity > 0.3  # More lenient
            is_beam_like = (aspect_ratio > 2.0 or aspect_ratio < 0.5) and area > 30
            
            if not (is_circular or is_beam_like):
                continue
            
            # Only accept bright detections
            if mean_intensity < 150:
                continue
            
            # Create detection ID based on position (for temporal tracking)
            detection_id = f"{cx//20}_{cy//20}"  # Grid-based ID
            current_detection_set.add(detection_id)
            
            detections.append({
                'bbox': (x, y, w, h),
                'center': (cx, cy),
                'area': area,
                'size': int(np.sqrt(area)),
                'circularity': circularity,
                'aspect_ratio': aspect_ratio,
                'intensity': mean_intensity,
                'id': detection_id
            })
        
        # Stage 5: Temporal filtering - track how long each detection has been present
        # Update stability tracking
        for det in detections:
            det_id = det['id']
            if det_id in self.stable_detections:
                self.stable_detections[det_id] += 1
            else:
                self.stable_detections[det_id] = 1
        
        # Clean up old detections not seen anymore
        active_ids = set(d['id'] for d in detections)
        ids_to_remove = [det_id for det_id in self.stable_detections if det_id not in active_ids]
        for det_id in ids_to_remove:
            del self.stable_detections[det_id]
        
        # Classify detections as "new/moving" vs "stable"
        # Include ALL detections (stable and active) to show complete light field
        for det in detections:
            stability_frames = self.stable_detections.get(det['id'], 0)
            
            # Mark as active if seen for less than 30 frames (1 second at 30fps)
            det['is_active'] = stability_frames < 30
            det['stability'] = stability_frames
        
        return {
            'binary': combined_mask,
            'detections': detections,  # Return ALL detections, not filtered
            'fg_mask': fg_mask,
            'bright_mask': bright_mask,
            'adjusted_inverted': adjusted_inverted
        }
    
    def find_line_intersections(self, lines: np.ndarray) -> list:
        """Find intersection points between line segments."""
        if lines is None or len(lines) < 2:
            return []
        
        intersections = []
        
        for i in range(len(lines)):
            for j in range(i + 1, len(lines)):
                x1, y1, x2, y2 = lines[i][0]
                x3, y3, x4, y4 = lines[j][0]
                
                denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
                if abs(denom) < 1e-6:
                    continue
                
                t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denom
                u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denom
                
                if 0 <= t <= 1 and 0 <= u <= 1:
                    ix = int(x1 + t * (x2 - x1))
                    iy = int(y1 + t * (y2 - y1))
                    intersections.append((ix, iy))
        
        return intersections
    
    def extract_light_profile(self, frame_bgr: np.ndarray) -> np.ndarray:
        """Extract vertical light profile from frame."""
        n_bins = self.args.bins
        
        if frame_bgr is None:
            return np.zeros((n_bins,), dtype=np.float32)
        
        hsv = cv2.cvtColor(frame_bgr, cv2.COLOR_BGR2HSV)
        lower = (0, 60, 170)
        upper = (179, 255, 255)
        mask = cv2.inRange(hsv, lower, upper)
        
        h, s, v = cv2.split(hsv)
        bright = cv2.bitwise_and(v, v, mask=mask)
        
        height = bright.shape[0]
        if height == 0:
            return np.zeros((n_bins,), dtype=np.float32)
        
        bin_height = max(1, height // n_bins)
        profile = []
        
        for i in range(n_bins):
            y0 = i * bin_height
            y1 = height if i == n_bins - 1 else (i + 1) * bin_height
            region = bright[y0:y1, :]
            if region.size == 0:
                profile.append(0.0)
            else:
                profile.append(float(region.mean()))
        
        profile = np.array(profile, dtype=np.float32)
        max_val = float(profile.max())
        if max_val > 0:
            profile /= max_val
        
        return profile
    
    def update_frame(self):
        """Process and display one frame with advanced geometry analyzer."""
        if self.cap is None or not self.cap.isOpened():
            return
        
        ret, frame = self.cap.read()
        if not ret or frame is None:
            return
        
        # Resize frame to fit CV display area (minus small control panel height)
        cv_display_height = self.args.top_panel_height - 50
        frame = cv2.resize(frame, (self.panel_width, cv_display_height),
                          interpolation=cv2.INTER_AREA)
        
        self.frame_count += 1
        
        # Learning phase - feed frames to analyzer's background subtractor
        if self.learning_phase and self.frame_count <= self.bg_learning_frames:
            # Just feed to background subtractor during learning
            _ = self.geometry_analyzer.bg_subtractor.apply(frame, learningRate=0.01)
            
            # Show learning message
            learning_vis = np.zeros((self.args.top_panel_height - 50, self.panel_width, 3), dtype=np.uint8)
            progress = int((self.frame_count / self.bg_learning_frames) * 100)
            msg1 = "Learning background..."
            msg2 = f"{progress}%"
            
            overlays = [
                (msg1, 20, (self.args.top_panel_height - 50)//2 - 10, QColor(230, 230, 230), 18),
                (msg2, 20, (self.args.top_panel_height - 50)//2 + 20, QColor(200, 200, 200), 18),
            ]
            self.cv_widget.display_cv_image(learning_vis, overlays=overlays)
            return
        
        if self.learning_phase:
            self.learning_phase = False
            print("Background learning complete, starting analysis...")
        
        # === SINGLE CV PANEL: PROCESSED WITH DETECTIONS ===
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        inverted_gray = cv2.bitwise_not(gray)
        
        # Use ALL-bright-regions detection method (not background subtraction)
        # This captures the complete light field, not just moving lights
        geometry = self.detect_all_bright_regions(frame, inverted_gray)

        # Optional: send CV-driven /track/A..F in tracker format (for Max patches that expect it)
        self._maybe_send_cv_tracks(geometry.get("detections", []), frame.shape[1], frame.shape[0])
        
        # Use adjusted inverted image as background
        cv_vis = cv2.cvtColor(geometry['adjusted_inverted'], cv2.COLOR_GRAY2BGR)
        
        # Overlay detections with color coding based on activity
        active_count = 0
        stable_count = 0
        
        for i, detection in enumerate(geometry['detections']):
            x, y, w, h = detection['bbox']
            cx, cy = detection['center']
            is_active = detection.get('is_active', True)
            stability = detection.get('stability', 0)
            
            # Color coding:
            # GREEN = Active/New light (moving, changing)
            # BLUE = Stable light (been there a while but still valid)
            # Thickness based on intensity
            if is_active:
                color = (0, 255, 0)  # Green - active light
                active_count += 1
                thickness = 2
            else:
                color = (255, 150, 0)  # Cyan-blue - stable light
                stable_count += 1
                thickness = 1
            
            # Draw bounding square
            cv2.rectangle(cv_vis, (x, y), (x+w, y+h), color, thickness)
            
            # Draw center dot (size based on area)
            radius = max(3, min(detection['size'] // 3, 12))
            cv2.circle(cv_vis, (cx, cy), radius, color, -1)
            cv2.circle(cv_vis, (cx, cy), radius + 2, (255, 255, 255), 1)
            
            # Optional: show intensity value for debugging
            # cv2.putText(cv_vis, f"{int(detection['intensity'])}", 
            #            (cx+10, cy), cv2.FONT_HERSHEY_SIMPLEX, 0.3, color, 1)
        
        # Get state label and add enhanced metrics
        state_label = self.geometry_analyzer.get_temporal_state()
        num_detections = len(geometry['detections'])
        
        # Enhanced info box (text via Qt for consistent typography)
        cv2.rectangle(cv_vis, (5, 5), (250, 98), (0, 0, 0), -1)
        cv2.rectangle(cv_vis, (5, 5), (250, 98), (60, 60, 60), 1)

        overlays = [
            (f"{state_label}", 12, 26, QColor(230, 230, 230), 13),
            (f"total={num_detections}", 12, 50, QColor(200, 200, 200), 12),
            (f"active={active_count}", 12, 72, QColor(10, 132, 255), 12),
            (f"stable={stable_count}", 12, 92, QColor(200, 200, 200), 12),
        ]

        # Update displays
        self.cv_widget.display_cv_image(cv_vis, overlays=overlays)
        
        # Update graphic score with the actual light shapes from the adjusted frame
        # Pass the inverted image where light appears dark - the score will flip it
        self.score_widget.update_score_from_frame(geometry['adjusted_inverted'], geometry.get('detections'))

    def _maybe_send_cv_tracks(self, detections: list, frame_w: int, frame_h: int):
        """
        Send motion-tracker-compatible OSC:
        - /track/A .. /track/F
          payload: [i, xNorm, yNorm, wNorm, hNorm, areaNorm, vxNorm, vyNorm]
          where vx/vy are per-frame center deltas normalized to 0..1 range.
        """
        if self.osc_track_client is None:
            return
        if not bool(getattr(self.args, "osc_out_enable", False)):
            return
        if str(getattr(self.args, "osc_out_format", "pattern")).strip().lower() != "tracker":
            return
        if not bool(getattr(self.args, "osc_out_send_tracks", False)):
            return

        # Rate limit (separate from /pattern)
        rate_hz = float(getattr(self.args, "osc_track_rate_hz", getattr(self.args, "osc_out_rate_hz", 20.0)))
        rate_hz = float(max(0.5, rate_hz))
        now = time.monotonic()
        if (now - self._track_last_send_monotonic) < (1.0 / rate_hz):
            return
        self._track_last_send_monotonic = now

        if frame_w <= 0 or frame_h <= 0:
            return

        # Sort detections by area descending
        dets = []
        for d in detections or []:
            if not isinstance(d, dict):
                continue
            bbox = d.get("bbox")
            if not bbox or len(bbox) != 4:
                continue
            x, y, w, h = bbox
            if w <= 0 or h <= 0:
                continue
            area = float(d.get("area", float(w * h)))
            cx, cy = d.get("center", (x + w // 2, y + h // 2))
            dets.append((area, float(x), float(y), float(w), float(h), float(cx), float(cy)))
        dets.sort(key=lambda t: t[0], reverse=True)

        track_n = int(getattr(self.args, "osc_out_track_count", 6))
        track_n = int(max(1, min(6, track_n)))
        send_empty = bool(getattr(self.args, "osc_track_send_empty", False))
        min_delta = float(getattr(self.args, "osc_track_min_delta", 0.003))
        min_delta = float(max(0.0, min_delta))

        # Send fixed A..F slots
        for i in range(track_n):
            letter = self._track_letters[i]
            if i < len(dets):
                area, x, y, w, h, cx, cy = dets[i]
                xN = float(np.clip(x / float(frame_w), 0.0, 1.0))
                yN = float(np.clip(y / float(frame_h), 0.0, 1.0))
                wN = float(np.clip(w / float(frame_w), 0.0, 1.0))
                hN = float(np.clip(h / float(frame_h), 0.0, 1.0))
                aN = float(np.clip((w * h) / float(frame_w * frame_h), 0.0, 1.0))

                prev_cx, prev_cy = self._track_prev_centers[i]
                vxN = float(np.clip((cx - prev_cx) / float(frame_w), -1.0, 1.0))
                vyN = float(np.clip((cy - prev_cy) / float(frame_h), -1.0, 1.0))

                self._track_prev_centers[i] = (cx, cy)
                self._track_prev_boxes[i] = (x, y, w, h)
                payload = [int(i), xN, yN, wN, hN, aN, vxN, vyN]
            else:
                if not send_empty:
                    continue
                # No detection -> zeros
                self._track_prev_centers[i] = (0.0, 0.0)
                self._track_prev_boxes[i] = (0.0, 0.0, 0.0, 0.0)
                payload = [int(i), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

            # Skip sending if payload hasn't changed much (reduces Max load)
            last = self._track_last_sent[i]
            cur = (float(payload[0]), float(payload[1]), float(payload[2]), float(payload[3]), float(payload[4]), float(payload[5]), float(payload[6]), float(payload[7]))
            dsum = abs(cur[1] - last[1]) + abs(cur[2] - last[2]) + abs(cur[3] - last[3]) + abs(cur[4] - last[4]) + abs(cur[5] - last[5]) + abs(cur[6] - last[6]) + abs(cur[7] - last[7])
            if dsum < min_delta:
                continue
            self._track_last_sent[i] = cur

            try:
                self.osc_track_client.send_message(f"/track/{letter}", payload)
            except Exception:
                # keep silent; audio panel already has OSC logging if desired
                pass
    
    def closeEvent(self, event):
        """Clean up on close."""
        if self.cap is not None:
            self.cap.release()
        event.accept()


def main():
    parser = argparse.ArgumentParser(
        description="IMOL CV graphic score system with Qt GUI."
    )
    parser.add_argument(
        "--preset",
        type=str,
        # Default to your current preferred gallery launch (no flags).
        default="spectro_mean",
        help="Apply a preset of visual/score parameters (e.g. 'spectro_mean').",
    )
    parser.add_argument("--camera-index", type=int, default=0,
                       help="Camera device index (default: 0)")
    parser.add_argument("--window-width", type=int, default=1920,
                       help="Window width (default: 1920)")
    parser.add_argument("--window-height", type=int, default=1080,
                       help="Window height (default: 1080)")
    parser.add_argument("--top-panel-height", type=int, default=580,
                       help="Height of top panels (default: 580)")
    parser.add_argument("--bins", type=int, default=24,
                       help="Number of vertical bins (default: 24)")
    parser.add_argument("--fps", type=float, default=30.0,
                       help="Target FPS (default: 30)")
    parser.add_argument("--bg-learning", type=int, default=120,
                       help="Background learning frames (default: 120)")

    # OSC output (to IMOL_PATTERN_CONTROLLER_QT)
    # Default ON (for gallery usage). Use --osc-out-disable to turn it off.
    parser.add_argument("--osc-out-enable", action="store_true", default=True,
                        help="(Default: enabled) Enable OSC output for pattern control")
    parser.add_argument("--osc-out-disable", action="store_true",
                        help="Disable OSC output (overrides --osc-out-enable)")
    parser.add_argument("--osc-out-host", type=str, default="127.0.0.1",
                        help="OSC destination host (default: 127.0.0.1)")
    parser.add_argument("--osc-out-port", type=int, default=9000,
                        help="OSC destination port (default: 9000)")
    parser.add_argument("--osc-pattern-max", type=int, default=8,
                        help="Max pattern index to target for /pattern mapping (default: 8)")
    parser.add_argument("--osc-out-format", type=str, default="tracker",
                        help="OSC format: pattern | tracker (default: tracker)")
    parser.add_argument("--osc-out-send-features", action="store_true",
                        help="In tracker format, also send normalized features under /feat/*")
    parser.add_argument("--osc-out-rate-hz", type=float, default=20.0,
                        help="OSC send rate limit in Hz for tracker format (default: 20.0)")
    # Default ON (for your Max patch). Use --osc-out-no-tracks to turn it off.
    parser.add_argument("--osc-out-send-tracks", action="store_true", default=True,
                        help="(Default: enabled) In tracker format, also send /track/A..F from CV detections")
    parser.add_argument("--osc-out-no-tracks", action="store_true",
                        help="Disable sending /track/A..F (overrides --osc-out-send-tracks)")
    parser.add_argument("--osc-out-track-count", type=int, default=6,
                        help="How many /track/* slots to send (1..6, default: 6)")
    parser.add_argument("--osc-track-host", type=str, default="127.0.0.1",
                        help="Tracker OSC destination host for Max (default: 127.0.0.1)")
    parser.add_argument("--osc-track-port", type=int, default=9001,
                        help="Tracker OSC destination port for Max (default: 9001)")
    parser.add_argument("--osc-track-rate-hz", type=float, default=6.0,
                        help="Rate limit for /track/* messages in Hz (default: 6.0)")
    parser.add_argument("--osc-track-min-delta", type=float, default=0.01,
                        help="Minimum total delta (x,y,w,h,area,vx,vy) to send a /track/* update (default: 0.01)")
    parser.add_argument("--osc-track-send-empty", action="store_true",
                        help="If set, also send zeroed /track/* messages when fewer detections than slots")

    # Tracker stream throttles for Max friendliness (applies to /system/state, /vel/value, /feat/*)
    parser.add_argument("--osc-tracker-system-rate-hz", type=float, default=5.0,
                        help="Rate limit for /system/state in Hz (<=0 disables; default: 5.0)")
    parser.add_argument("--osc-tracker-system-min-delta", type=float, default=0.02,
                        help="Min delta to send /system/state updates (default: 0.02)")
    parser.add_argument("--osc-tracker-vel-value-rate-hz", type=float, default=5.0,
                        help="Rate limit for /vel/value in Hz (<=0 disables; default: 5.0)")
    parser.add_argument("--osc-tracker-vel-value-min-delta", type=float, default=0.02,
                        help="Min delta to send /vel/value updates (default: 0.02)")
    parser.add_argument("--osc-tracker-vel-level-hold-s", type=float, default=0.25,
                        help="Debounce hold time in seconds for /vel/<level> toggles (default: 0.25)")
    parser.add_argument("--osc-tracker-feat-rate-hz", type=float, default=0.0,
                        help="Rate limit for /feat/* messages in Hz (<=0 disables; default: 0.0)")
    parser.add_argument("--osc-tracker-feat-min-delta", type=float, default=0.02,
                        help="Min delta to send /feat/* messages (default: 0.02)")

    # --- Graphic score aesthetics (rendering only) ---
    parser.add_argument("--score-decay", type=float, default=1.0,
                       help="Score decay per frame (1.0 disables fading / legacy accumulation; default: 1.0)")
    parser.add_argument("--score-strokes", action="store_true",
                       help="Use stroke stamping instead of dot stamping (adds complexity)")
    parser.add_argument("--score-halo", action="store_true",
                       help="Enable halo glow around new marks (adds softness without blurring core)")
    parser.add_argument("--score-style", type=str, default="dots",
                       help="Score style: dots | strokes | spectrogram (default: dots)")
    parser.add_argument("--score-halo-kernel", type=int, default=9,
                       help="Odd kernel size for halo blur (default: 9)")
    parser.add_argument("--score-halo-strength", type=float, default=0.65,
                       help="Halo strength 0..1 (default: 0.65)")
    parser.add_argument("--score-stamp-min-brightness", type=int, default=150,
                       help="Min brightness (post-inversion) to stamp into score (default: 150)")

    # Spectrogram style tuning (only used when --score-style spectrogram)
    parser.add_argument("--score-spectro-noise-floor", type=int, default=6,
                       help="Spectrogram background floor (default: 6)")
    parser.add_argument("--score-spectro-grain", type=float, default=0.18,
                       help="Spectrogram grain amount 0..1 (default: 0.18)")
    parser.add_argument("--score-spectro-blur-y", type=int, default=3,
                       help="Spectrogram vertical blur strength (0 disables; default: 3)")
    parser.add_argument("--score-spectro-log-k", type=float, default=12.0,
                       help="Spectrogram log compression factor >0 (default: 12.0)")
    parser.add_argument("--score-spectro-background-level", type=int, default=235,
                       help="Spectrogram paper brightness 0..255 (default: 235)")
    parser.add_argument("--score-spectro-ink-strength", type=int, default=210,
                       help="Spectrogram ink darkness from energy 0..255 (default: 210)")
    parser.add_argument("--score-spectro-speckle-strength", type=int, default=22,
                       help="Spectrogram speckle darkness 0..120 (default: 22)")
    parser.add_argument("--score-spectro-mask-feather", type=int, default=5,
                       help="Mask feathering (soft edge) 0 disables (default: 5)")
    parser.add_argument("--score-spectro-intensity-weight", type=float, default=1.0,
                       help="Spectrogram energy weight for intensity (default: 1.0)")
    parser.add_argument("--score-spectro-motion-weight", type=float, default=0.7,
                       help="Spectrogram energy weight for motion (default: 0.7)")
    parser.add_argument("--score-spectro-profile-smooth", type=float, default=0.35,
                       help="Spectrogram profile EMA smoothing 0..1 (default: 0.35)")
    parser.add_argument("--score-spectro-profile-mode", type=str, default="max",
                       help="Spectrogram profile mode: max | mean (default: max)")
    parser.add_argument("--score-spectro-render-mode", type=str, default="profile",
                       help="Spectrogram render mode: profile | slice (default: profile)")
    parser.add_argument("--score-spectro-slices-per-frame", type=int, default=1,
                       help="In spectrogram slice mode, how many columns to stamp per frame (default: 1)")
    parser.add_argument("--score-spectro-slice-step", type=int, default=1,
                       help="In spectrogram slice mode, x-step between consecutive slices (default: 1)")
    
    args = parser.parse_args()

    # ---------------------- Default gallery OSC wiring (no flags) ----------------------
    # Keep backwards compatibility with prior CLI flags, but allow "disable" overrides.
    if bool(getattr(args, "osc_out_disable", False)):
        args.osc_out_enable = False
    else:
        # argparse store_true with default=True makes this always True unless disabled above.
        args.osc_out_enable = bool(getattr(args, "osc_out_enable", True))

    if bool(getattr(args, "osc_out_no_tracks", False)):
        args.osc_out_send_tracks = False
    else:
        args.osc_out_send_tracks = bool(getattr(args, "osc_out_send_tracks", True))

    # ---------------------- Presets (avoid long CLI runs) ----------------------
    # Apply only if the user didn't explicitly pass the relevant flags.
    argv = sys.argv[1:]

    def _cli_has(prefix: str) -> bool:
        return any(a == prefix or a.startswith(prefix + "=") for a in argv)

    preset = (args.preset or "").strip().lower()
    if preset in ("spectro_mean", "spectrogram", "spectro"):
        # Matches your current preferred launch:
        # --score-style spectrogram
        # --score-spectro-profile-mode mean
        # --score-spectro-motion-weight 1.2
        # --score-spectro-profile-smooth 0.6
        # --score-spectro-log-k 25
        # --score-spectro-blur-y 5
        # --score-spectro-noise-floor 10
        # --score-spectro-grain 0.25
        # --score-spectro-mask-feather 9
        if not _cli_has("--score-style"):
            args.score_style = "spectrogram"
        if not _cli_has("--score-spectro-profile-mode"):
            args.score_spectro_profile_mode = "mean"
        if not _cli_has("--score-spectro-motion-weight"):
            args.score_spectro_motion_weight = 1.2
        if not _cli_has("--score-spectro-profile-smooth"):
            args.score_spectro_profile_smooth = 0.6
        if not _cli_has("--score-spectro-log-k"):
            args.score_spectro_log_k = 25.0
        if not _cli_has("--score-spectro-blur-y"):
            args.score_spectro_blur_y = 5
        if not _cli_has("--score-spectro-noise-floor"):
            args.score_spectro_noise_floor = 10
        if not _cli_has("--score-spectro-grain"):
            args.score_spectro_grain = 0.25
        if not _cli_has("--score-spectro-mask-feather"):
            args.score_spectro_mask_feather = 9
    
    app = QApplication(sys.argv)
    # Global typography (single font everywhere).
    # Use only this font family to keep the interface consistent.
    app.setFont(QFont("Menlo", 12))
    window = IMOLGraphicScoreWindow(args)
    window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()

