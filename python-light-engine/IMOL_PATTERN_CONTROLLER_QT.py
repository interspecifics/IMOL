"""
IMOL_PATTERN_CONTROLLER_QT
--------------------------

Qt-based controller for An Instrument Made of Light.

This is a new front-end that mirrors the behaviour of the Tk controller
(`IMOL_PATTERN_CONTROLLER.py`) but uses PySide6 for precise, pixel-level
layout and a dark gallery-friendly theme.

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
from dataclasses import dataclass, field
from typing import Dict, List, Optional

import yaml
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import ThreadingOSCUDPServer
from ola.ClientWrapper import ClientWrapper
from ola.OlaClient import OLADNotRunningException
from PySide6.QtCore import Qt, QTimer
from PySide6.QtGui import QPalette, QColor
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
    QPushButton,
    QSlider,
    QSpinBox,
    QDoubleSpinBox,
    QScrollArea,
    QSizePolicy,
    QVBoxLayout,
    QWidget,
)

from main import DmxByteArray, _start_olad_if_needed


FIXTURES_FILE = "fixtures.yml"
MOVING_HEAD_KEY = "moving_head_14ch"
HERO_KEY = "varytec_hero_mirror_8ch"
MBM_KEY = "mbm40d_mirror_motor_1ch"
MOVING_HEAD_COUNT = 4
HERO_COUNT = 2
MBM_COUNT = 2
FIXTURE_COUNT = MOVING_HEAD_COUNT + HERO_COUNT + MBM_COUNT
DEFAULT_OSC_PORT = 9000
PATTERN_SETS_FILE = "pattern_sets.json"


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
        default_factory=lambda: [True for _ in range(FIXTURE_COUNT)]
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
    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("IMOL Pattern Controller (Qt)")
        self.resize(1400, 900)

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
        self.mh_channel_count = len(self.moving_head_def["channels"])
        self.hero_channel_count = len(self.hero_def["channels"])
        self.mbm_channel_count = len(self.mbm_def["channels"])

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
            else:
                mbm_index = i - MOVING_HEAD_COUNT - HERO_COUNT
                start = self.mbm_def.get("default_address", 1) + mbm_index * self.mbm_channel_count
                ch_count = self.mbm_channel_count
            fs = FixtureState(start_address=start, channel_count=ch_count)
            fs.ensure_defaults()
            self.fixtures.append(fs)

        # Patterns and sets.
        self.patterns: List[PatternSlot] = [
            PatternSlot(name=f"Pattern {i+1}") for i in range(4)
        ]
        self.pattern_sets: List[PatternSet] = self._load_sets_from_disk()
        self.active_pattern_index: Optional[int] = None

        # Pattern UI references (set in _build_patterns_block / _rebuild_patterns_ui).
        self.patterns_group: Optional[QGroupBox] = None
        self.patterns_layout: Optional[QVBoxLayout] = None
        self.set_name_edit: Optional[QLineEdit] = None
        self.set_combo: Optional[QComboBox] = None

        # OSC server placeholder.
        self._osc_server: Optional[ThreadingOSCUDPServer] = None

        # DMX timing diagnostics.
        self._last_tick_time: Optional[float] = None
        self._fps_smooth: Optional[float] = None
        self.fps_value_label: Optional[QLabel] = None

        self._build_ui()

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
        main_layout.setContentsMargins(16, 16, 16, 16)
        main_layout.setSpacing(16)

        # Top: controls + fixtures.
        top_layout = QHBoxLayout()
        main_layout.addLayout(top_layout)

        top_left = QVBoxLayout()
        top_right = QVBoxLayout()
        top_layout.addLayout(top_left, 1)
        top_layout.addLayout(top_right, 1)

        # Universe / OSC / OLA services (left).
        self._build_universe_osc_block(top_left)
        self._build_ola_services_block(top_left)

        # Fixtures ADD (right) + engine/external control panel, side by side.
        right_split = QHBoxLayout()
        top_right.addLayout(right_split)
        fixtures_group = self._build_fixtures_block()
        engine_group = self._build_engine_block()
        right_split.addWidget(fixtures_group, 2)
        right_split.addWidget(engine_group, 1)

        # Middle / bottom: fixture editor + patterns.
        mid_layout = QHBoxLayout()
        main_layout.addLayout(mid_layout, 1)

        left_panel = QVBoxLayout()
        right_panel = QVBoxLayout()
        mid_layout.addLayout(left_panel, 1)
        mid_layout.addLayout(right_panel, 1)

        self._build_fixture_editor(left_panel)
        self._build_patterns_block(right_panel)

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
        return group

    def _build_engine_block(self) -> QGroupBox:
        """
        Small diagnostics / external control block: shows DMX frame rate and
        lets you enable/disable external OSC control (from Max, etc.).
        """
        group = QGroupBox("ENGINE / EXTERNAL CONTROL")
        layout = QGridLayout(group)

        # DMX frame rate display (smoothed).
        layout.addWidget(QLabel("DMX FPS"), 0, 0, Qt.AlignLeft)
        self.fps_value_label = QLabel("—")
        layout.addWidget(self.fps_value_label, 0, 1, Qt.AlignLeft)

        # External OSC enable toggle.
        osc_cb = QCheckBox("Enable OSC pattern control (Max / others)")
        osc_cb.setChecked(True)

        def _on_osc_toggle(state: int) -> None:
            self.external_osc_enabled = state == Qt.Checked

        osc_cb.stateChanged.connect(_on_osc_toggle)
        layout.addWidget(osc_cb, 1, 0, 1, 2, Qt.AlignLeft)

        # Hard reset: immediately stop all behaviours and send DMX = 0.
        reset_btn = QPushButton("Hard reset (all fixtures off)")
        reset_btn.clicked.connect(self._on_hard_reset_all)
        layout.addWidget(reset_btn, 2, 0, 1, 2, Qt.AlignLeft)

        # Placeholder for Ableton Link (not implemented yet, but reserved).
        link_label = QLabel("Ableton Link: driven via /link/* OSC")
        link_label.setEnabled(False)
        layout.addWidget(link_label, 3, 0, 1, 2, Qt.AlignLeft)

        return group

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

            # Lamps + mirrors + motors checkboxes.
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

            self.pattern_rows.append((name_edit, store_btn, act_btn))

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

        self.set_name_edit = QLineEdit("Set 1")
        sets_layout.addWidget(QLabel("Name"), 0, 0)
        sets_layout.addWidget(self.set_name_edit, 0, 1)
        store_set_btn = QPushButton("Store set from current")
        store_set_btn.clicked.connect(self._on_store_set)
        sets_layout.addWidget(store_set_btn, 0, 2)

        sets_layout.addWidget(QLabel("Load"), 1, 0)
        self.set_combo = QComboBox()
        self._refresh_set_combo()
        sets_layout.addWidget(self.set_combo, 1, 1)
        load_set_btn = QPushButton("Load set")
        load_set_btn.clicked.connect(self._on_load_set)
        sets_layout.addWidget(load_set_btn, 1, 2)

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

        return _cb

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
        else:
            channels = self.mbm_def["channels"]

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
            slider.setMaximumWidth(140)
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
            self.channels_layout.addWidget(slider, row_idx, 4)
            self.channels_layout.addWidget(dmx_label, row_idx, 5)
            self.channels_layout.addWidget(mode_combo, row_idx, 6)
            self.channels_layout.addWidget(rate_spin, row_idx, 7)

            self.channel_widgets[ch] = (
                min_spin,
                max_spin,
                slider,
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
            slider.valueChanged.connect(
                lambda val, ch_num=ch: self._on_slider_changed(fixture_index, ch_num, val)
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
            _, _, _, dmx_label, _, _ = widgets
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

    def _on_store_pattern(self, idx: int) -> None:
        # Deep copy of fixture states so each pattern remembers its behaviours.
        snapshot = [FixtureState(
            start_address=fs.start_address,
            channel_count=fs.channel_count,
            min_values=dict(fs.min_values),
            max_values=dict(fs.max_values),
            slider_values=dict(fs.slider_values),
            modes=dict(fs.modes),
            rates=dict(fs.rates),
            phases=dict(fs.phases),
        ) for fs in self.fixtures]
        self.patterns[idx].fixtures_state = snapshot
        self.active_pattern_index = idx

    def _on_activate_pattern(self, idx: int) -> None:
        pattern = self.patterns[idx]
        if not pattern.is_defined():
            return
        # Restore fixture behaviours from this pattern.
        if pattern.fixtures_state:
            self.fixtures = [
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
        self.active_pattern_index = idx

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
        if 0 <= idx < len(self.patterns):
            # Schedule on GUI thread.
            QTimer.singleShot(0, lambda i=idx: self._on_activate_pattern(i))

    def _osc_random_handler(self, _addr: str, *_args) -> None:
        """Handle /pattern_random or /pattern/random messages."""
        if not self.external_osc_enabled:
            return
        QTimer.singleShot(0, self._on_random_pattern)

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

        if self.active_pattern_index is None:
            return
        pattern = self.patterns[self.active_pattern_index]
        if not pattern.is_defined():
            return

        frame = self._build_universe_frame()
        frame = self._apply_active_mask(frame, pattern.active_fixtures)
        self._send_frame_with_ola_feedback(frame)

    def _send_frame_with_ola_feedback(self, frame: List[int]) -> None:
        """
        Low-level DMX sender that mirrors main.send_single_frame, but also
        updates the OLA status label so the user sees when we restart the
        connection to olad.
        """
        try:
            wrapper = ClientWrapper()
        except OLADNotRunningException:
            self._set_status("OLAD not running; attempting to start it…")
            _start_olad_if_needed()
            try:
                wrapper = ClientWrapper()
            except OLADNotRunningException:
                self._set_status("Failed to connect to OLAD after restart attempt.")
                return

        client = wrapper.Client()

        def dmx_sent(_state) -> None:
            wrapper.Stop()

        try:
            client.SendDmx(self.universe, DmxByteArray(frame), dmx_sent)
            wrapper.Run()
            self._set_status(f"Sending DMX to Universe {self.universe}.")
        except Exception as exc:
            self._set_status(f"DMX send error: {exc}")

    # --------------------------- Pattern sets persistence --------------------

    def _refresh_set_combo(self) -> None:
        if self.set_combo is None:
            return
        self.set_combo.clear()
        for s in self.pattern_sets:
            self.set_combo.addItem(s.name)

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
        self._refresh_set_combo()

    def _on_load_set(self) -> None:
        """Load patterns from the selected set into the controller."""
        if not self.set_combo or self.set_combo.currentIndex() < 0:
            return
        name = self.set_combo.currentText()
        for s in self.pattern_sets:
            if s.name == name:
                # Deep copy so further edits do not mutate the stored set.
                def _normalize_active_fixtures(raw_list: List[bool]) -> List[bool]:
                    af = list(raw_list)
                    if len(af) < FIXTURE_COUNT:
                        af.extend([True] * (FIXTURE_COUNT - len(af)))
                    elif len(af) > FIXTURE_COUNT:
                        af = af[:FIXTURE_COUNT]
                    return af

                self.patterns = [
                    PatternSlot(
                        name=p.name,
                        fixtures_state=(
                            [FixtureState(**{
                                "start_address": fs.start_address,
                                "channel_count": fs.channel_count,
                                "min_values": dict(fs.min_values),
                                "max_values": dict(fs.max_values),
                                "slider_values": dict(fs.slider_values),
                                "modes": dict(fs.modes),
                                "rates": dict(fs.rates),
                                "phases": dict(fs.phases),
                            }) for fs in (p.fixtures_state or [])]
                            if p.fixtures_state
                            else None
                        ),
                        active_fixtures=_normalize_active_fixtures(p.active_fixtures),
                    )
                    for p in s.patterns
                ]
                self._rebuild_patterns_ui()
                break

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
            if len(af) < FIXTURE_COUNT:
                af.extend([True] * (FIXTURE_COUNT - len(af)))
            elif len(af) > FIXTURE_COUNT:
                af = af[:FIXTURE_COUNT]
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
                                [True for _ in range(FIXTURE_COUNT)],
                            )
                        ),
                    )
                )

            sets.append(PatternSet(name=sdata.get("name", "Set"), patterns=patterns))
        return sets


def main() -> None:
    app = QApplication(sys.argv)
    win = MainWindow()
    win.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()


