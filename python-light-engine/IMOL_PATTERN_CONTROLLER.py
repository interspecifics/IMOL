"""
IMOL_PATTERN_CONTROLLER
-----------------------

High-level controller for four moving-head fixtures plus two Varytec Hero
mirror fixtures (6 fixtures total).

Goals:
- Fast setup in the gallery:
  - Configure four identical fixtures (universe + DMX start address).
  - Per-channel min/max ranges (thresholds) for each fixture, based on the
    14-channel moving-head definition in fixtures.yml.
- Behavioural patterns:
  - A small number of pattern slots (e.g. 4) that store "looks" or behaviours.
  - Each pattern can be recalled from the GUI or via OSC.
- OSC control:
  - Listen for pattern change messages, e.g. /pattern <index>.

This file focuses on a clear, direct GUI and a simple pattern model which can be
extended later (e.g. to more complex motion patterns).
"""

import threading
import time
import tkinter as tk
from dataclasses import dataclass, field
from tkinter import ttk
from typing import Dict, List, Optional
import random
import copy
import json
import os
import webbrowser
import math

import yaml
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import ThreadingOSCUDPServer
from ola.ClientWrapper import ClientWrapper
from ola.OlaClient import OLADNotRunningException

from main import build_dmx_frame, send_single_frame


FIXTURES_FILE = "fixtures.yml"
FIXTURE_KEY = "moving_head_14ch"
HERO_FIXTURE_KEY = "varytec_hero_mirror_8ch"
MOVING_HEAD_COUNT = 4
HERO_COUNT = 2
FIXTURE_COUNT = MOVING_HEAD_COUNT + HERO_COUNT
DEFAULT_OSC_PORT = 9000
PATTERN_SETS_FILE = "pattern_sets.json"


def load_fixture_definition(path: str, fixture_key: str) -> dict:
    """
    Load a single fixture definition from fixtures.yml.
    """
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data["fixtures"][fixture_key]


@dataclass
class FixtureState:
    """
    Holds configuration and current channel values for a single fixture.
    - start_address: DMX start address (1–512).
    - min/max: per-channel DMX range (0–255) used as thresholds.
    - slider: abstract 0–255 "control" values which are mapped into [min,max].
    """

    start_address: int
    channel_count: int
    min_values: Dict[int, int] = field(default_factory=dict)
    max_values: Dict[int, int] = field(default_factory=dict)
    slider_values: Dict[int, int] = field(default_factory=dict)
    modes: Dict[int, str] = field(default_factory=dict)   # "off", "static", "sine"
    rates: Dict[int, float] = field(default_factory=dict) # Hz
    phases: Dict[int, float] = field(default_factory=dict)  # 0–1

    def ensure_defaults(self) -> None:
        for ch in range(1, self.channel_count + 1):
            self.min_values.setdefault(ch, 0)
            self.max_values.setdefault(ch, 255)
            self.slider_values.setdefault(ch, 0)
            self.modes.setdefault(ch, "static")
            self.rates.setdefault(ch, 0.0)
            self.phases.setdefault(ch, 0.0)

    def build_fixture_channels(self, t: float) -> List[int]:
        """
        Convert slider values + thresholds (+ optional LFO) to concrete DMX values
        for this fixture at time t.
        Returns a list of length channel_count with values in 0–255.
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
            elif mode == "sine":
                # Simple LFO between min and max.
                rate = float(self.rates.get(ch, 0.2))
                phase = float(self.phases.get(ch, 0.0))
                angle = 2.0 * math.pi * (rate * t + phase)
                norm = 0.5 + 0.5 * math.sin(angle)
                actual = int(round(min_v + norm * (max_v - min_v)))
            else:
                # Static mapping: slider 0–255 into [min,max].
                ratio = slider / 255.0
                actual = int(round(min_v + ratio * (max_v - min_v)))
            values[ch - 1] = actual
        return values


@dataclass
class PatternSlot:
    """
    A pattern is currently:
    - A static snapshot of DMX for all fixtures (dmx_frame).
    - Plus per-fixture on/off state (active_fixtures).

    Inactive fixtures are forced to "off" (their DMX channels are set to 0)
    when the pattern is recalled, but their configuration is still stored
    inside dmx_frame so the state can be reactivated later.

    Later this can be extended to animated patterns by adding:
    - type: str (e.g. "static", "pan_sweep")
    - parameters: dict (speeds, amplitudes, etc.)
    """

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
    A set is a named collection of patterns.
    This makes it easy to prepare several groups of looks (e.g. "intro",
    "dense", "quiet") and recall the whole bank in the gallery.
    """

    name: str
    patterns: List[PatternSlot]


class PatternControllerApp:
    def __init__(self, root: tk.Tk, moving_head_def: dict) -> None:
        self.root = root
        # Basic dark theme for the whole controller window.
        self.root.configure(bg="#111111")
        style = ttk.Style(self.root)
        try:
            style.theme_use("clam")
        except tk.TclError:
            # If 'clam' is not available, fall back silently to default.
            pass
        style.configure(".", background="#111111", foreground="#e0e0e0")
        style.configure("TFrame", background="#111111")
        style.configure("TLabelframe", background="#111111")
        style.configure("TLabelframe.Label", background="#111111", foreground="#e0e0e0")
        style.configure("TLabel", background="#111111", foreground="#e0e0e0")
        style.configure("TButton", background="#333333", foreground="#e0e0e0")
        style.configure("TCheckbutton", background="#111111", foreground="#e0e0e0")
        # Inputs: dark field background + dark grey text inside the boxes.
        style.configure(
            "TEntry",
            fieldbackground="#222222",
            background="#222222",
            foreground="#d0d0d0",
            insertcolor="#f0f0f0",
        )
        style.configure(
            "TCombobox",
            fieldbackground="#222222",
            background="#111111",
            foreground="#d0d0d0",
        )
        # Ensure the readonly/active states also keep the dark style so the
        # text in the Mode column stays readable on macOS.
        style.map(
            "TCombobox",
            fieldbackground=[
                ("readonly", "#222222"),
                ("!disabled", "#222222"),
            ],
            foreground=[
                ("readonly", "#d0d0d0"),
                ("!disabled", "#d0d0d0"),
            ],
            background=[
                ("readonly", "#111111"),
                ("!disabled", "#111111"),
            ],
        )
        # Fixture definitions for the two types used in this controller.
        self.moving_head_def = moving_head_def
        self.hero_def = load_fixture_definition(FIXTURES_FILE, HERO_FIXTURE_KEY)
        self.mh_channel_count = len(self.moving_head_def["channels"])
        self.hero_channel_count = len(self.hero_def["channels"])

        self.universe_var = tk.IntVar(value=self.moving_head_def.get("default_universe", 0))
        self.osc_port_var = tk.IntVar(value=DEFAULT_OSC_PORT)

        # Six fixtures (4 moving heads + 2 hero mirrors), each with its own start address.
        self.fixture_states: List[FixtureState] = []
        for i in range(FIXTURE_COUNT):
            if i < MOVING_HEAD_COUNT:
                # Moving heads: pack consecutively from their default address.
                start_addr = self.moving_head_def.get("default_address", 1) + i * self.mh_channel_count
                ch_count = self.mh_channel_count
            else:
                # Hero mirrors: use their own default address, offset per fixture.
                hero_index = i - MOVING_HEAD_COUNT
                start_addr = self.hero_def.get("default_address", 1) + hero_index * self.hero_channel_count
                ch_count = self.hero_channel_count

            self.fixture_states.append(
                FixtureState(
                    start_address=start_addr,
                    channel_count=ch_count,
                )
            )
        for fs in self.fixture_states:
            fs.ensure_defaults()

        # Currently selected fixture index (0–3) for editing thresholds.
        self.selected_fixture_index = tk.IntVar(value=0)

        # Pattern slots.
        self.patterns: List[PatternSlot] = [
            PatternSlot(name=f"Pattern {i+1}") for i in range(4)
        ]
        self.active_pattern_index: Optional[int] = None

        # Per-pattern, per-fixture active flags (for GUI checkbuttons).
        self.pattern_active_vars: List[List[tk.BooleanVar]] = []

        # Pattern sets (banks of patterns).
        self.pattern_sets: List[PatternSet] = []
        self.set_name_var = tk.StringVar(value="Set 1")
        self.set_select_var = tk.StringVar()

        # OLA / network diagnostics.
        self.ola_status_var = tk.StringVar(value="Not checked")

        # GUI state for the per-channel editor.
        self.slider_vars: Dict[int, tk.IntVar] = {}
        self.min_vars: Dict[int, tk.IntVar] = {}
        self.max_vars: Dict[int, tk.IntVar] = {}
        self.actual_vars: Dict[int, tk.IntVar] = {}
        self.mode_vars: Dict[int, tk.StringVar] = {}
        self.rate_vars: Dict[int, tk.DoubleVar] = {}

        # OSC server thread handle.
        self._osc_server: Optional[ThreadingOSCUDPServer] = None
        self._osc_thread: Optional[threading.Thread] = None

        # Try to load any previously stored sets from disk before building the UI.
        self.pattern_sets = self._load_sets_from_disk()

        self._build_ui()

        # Start the DMX tick loop so behaviours (e.g. LFOs) are animated.
        self._tick_interval_ms = 50  # ~20 FPS
        self._schedule_tick()

    # ------------------------------------------------------------------ GUI

    def _build_ui(self) -> None:
        self.root.title("IMOL Pattern Controller_ INTERSPECIFICS")

        top = ttk.Frame(self.root)
        top.pack(fill="x", padx=8, pady=4)

        ttk.Label(top, text="Universe").grid(row=0, column=0, sticky="w")
        ttk.Entry(top, textvariable=self.universe_var, width=5).grid(
            row=0, column=1, sticky="w"
        )

        # Fixture addresses
        for i in range(FIXTURE_COUNT):
            fs = self.fixture_states[i]
            fs_addr_var = tk.IntVar(value=fs.start_address)
            # Bind back into state when changed.
            fs_addr_var.trace_add(
                "write",
                lambda _n, _i, _m, idx=i, var=fs_addr_var: self._on_address_change(
                    idx, var
                ),
            )
            ttk.Label(top, text=f"F{i+1} addr").grid(
                row=0, column=2 + i * 2, padx=(12 if i == 0 else 4, 0)
            )
            ttk.Entry(top, textvariable=fs_addr_var, width=5).grid(
                row=0, column=3 + i * 2, sticky="w"
            )

        ttk.Label(top, text="OSC port").grid(row=1, column=0, sticky="w", pady=(4, 0))
        ttk.Entry(top, textvariable=self.osc_port_var, width=6).grid(
            row=1, column=1, sticky="w", pady=(4, 0)
        )
        ttk.Button(top, text="Start OSC", command=self.start_osc).grid(
            row=1, column=2, padx=(12, 0), pady=(4, 0)
        )

        # OLA / network diagnostics panel.
        ola_frame = ttk.LabelFrame(top, text="OLA / Network")
        ola_frame.grid(row=2, column=0, columnspan=8, sticky="we", pady=(4, 0))

        ttk.Label(ola_frame, text="Status").grid(row=0, column=0, sticky="w")
        ttk.Label(ola_frame, textvariable=self.ola_status_var).grid(
            row=0, column=1, sticky="w"
        )
        ttk.Button(
            ola_frame,
            text="Check OLA",
            command=self.check_ola_status,
        ).grid(row=0, column=2, padx=(8, 0))
        ttk.Button(
            ola_frame,
            text="Open OLA UI",
            command=self.open_ola_ui,
        ).grid(row=0, column=3, padx=(4, 0))

        ttk.Label(
            ola_frame,
            text="Hint: ensure this universe is patched to your Art-Net node in OLA.",
            foreground="#666666",
        ).grid(row=1, column=0, columnspan=4, sticky="w", pady=(2, 0))

        # Left: fixture/threshold editor; Right: patterns.
        body = ttk.Frame(self.root)
        body.pack(fill="both", expand=True, padx=8, pady=4)

        left = ttk.Frame(body)
        left.pack(side="left", fill="both", expand=True)

        right = ttk.Frame(body)
        right.pack(side="right", fill="both", expand=True, padx=(8, 0))

        # Fixture selector.
        fixture_select = ttk.Frame(left)
        fixture_select.pack(fill="x", pady=(0, 4))
        ttk.Label(fixture_select, text="Fixture").grid(row=0, column=0, sticky="w")
        for i in range(FIXTURE_COUNT):
            rb = ttk.Radiobutton(
                fixture_select,
                text=str(i + 1),
                value=i,
                variable=self.selected_fixture_index,
                command=self._rebuild_channel_editor,
            )
            rb.grid(row=0, column=1 + i, sticky="w")

        # Per-channel editor.
        self.channel_frame = ttk.Frame(left)
        self.channel_frame.pack(fill="both", expand=True)
        self._rebuild_channel_editor()

        # Pattern panel.
        self.pattern_panel = ttk.Frame(right)
        self.pattern_panel.pack(fill="both", expand=True)
        self._build_pattern_panel(self.pattern_panel)

    def _rebuild_channel_editor(self) -> None:
        for child in self.channel_frame.winfo_children():
            child.destroy()

        fixture_index = self.selected_fixture_index.get()
        fs = self.fixture_states[fixture_index]

        ttk.Label(self.channel_frame, text="Ch").grid(row=0, column=0, sticky="w")
        ttk.Label(self.channel_frame, text="Name").grid(row=0, column=1, sticky="w")
        ttk.Label(self.channel_frame, text="Min").grid(row=0, column=2, sticky="w")
        ttk.Label(self.channel_frame, text="Max").grid(row=0, column=3, sticky="w")
        ttk.Label(self.channel_frame, text="Ctl").grid(row=0, column=4, sticky="w")
        ttk.Label(self.channel_frame, text="DMX").grid(row=0, column=5, sticky="w")
        ttk.Label(self.channel_frame, text="Mode").grid(row=0, column=6, sticky="w")
        ttk.Label(self.channel_frame, text="Rate").grid(row=0, column=7, sticky="w")

        if fixture_index < MOVING_HEAD_COUNT:
            channels = self.moving_head_def["channels"]
        else:
            channels = self.hero_def["channels"]
        self.slider_vars.clear()
        self.min_vars.clear()
        self.max_vars.clear()
        self.actual_vars.clear()
        self.mode_vars.clear()
        self.rate_vars.clear()

        for row_index, ch in enumerate(sorted(channels.keys()), start=1):
            name = channels[ch].get("name", "")

            ttk.Label(self.channel_frame, text=str(ch)).grid(
                row=row_index, column=0, sticky="w"
            )
            ttk.Label(self.channel_frame, text=name).grid(
                row=row_index, column=1, sticky="w"
            )

            min_var = tk.IntVar(value=fs.min_values.get(ch, 0))
            max_var = tk.IntVar(value=fs.max_values.get(ch, 255))
            slider_var = tk.IntVar(value=fs.slider_values.get(ch, 0))
            actual_var = tk.IntVar(value=0)
            mode_var = tk.StringVar(value=fs.modes.get(ch, "static"))
            rate_var = tk.DoubleVar(value=float(fs.rates.get(ch, 0.0)))

            self.min_vars[ch] = min_var
            self.max_vars[ch] = max_var
            self.slider_vars[ch] = slider_var
            self.actual_vars[ch] = actual_var
            self.mode_vars[ch] = mode_var
            self.rate_vars[ch] = rate_var

            ttk.Entry(self.channel_frame, textvariable=min_var, width=5).grid(
                row=row_index, column=2, sticky="w"
            )
            ttk.Entry(self.channel_frame, textvariable=max_var, width=5).grid(
                row=row_index, column=3, sticky="w"
            )
            slider = ttk.Scale(
                self.channel_frame,
                from_=0,
                to=255,
                orient="horizontal",
                variable=slider_var,
                command=lambda _val, ch_num=ch: self.on_slider_change(ch_num),
            )
            slider.grid(row=row_index, column=4, sticky="we", padx=(4, 0))

            ttk.Label(self.channel_frame, textvariable=actual_var, width=4).grid(
                row=row_index, column=5, sticky="w", padx=(4, 0)
            )

            # Mode selector (off, static, sine).
            mode_combo = ttk.Combobox(
                self.channel_frame,
                textvariable=mode_var,
                values=["off", "static", "sine"],
                state="readonly",
                width=7,
            )
            mode_combo.grid(row=row_index, column=6, sticky="w", padx=(4, 0))

            def make_mode_callback(ch_num: int, var: tk.StringVar):
                def _cb(*_args):
                    fs.modes[ch_num] = var.get()
                    self._update_current_fixture_actuals()

                return _cb

            mode_var.trace_add("write", make_mode_callback(ch, mode_var))

            # Rate in Hz (meaningful for LFO modes).
            rate_entry = ttk.Entry(self.channel_frame, textvariable=rate_var, width=6)
            rate_entry.grid(row=row_index, column=7, sticky="w", padx=(4, 0))

            def make_rate_callback(ch_num: int, var: tk.DoubleVar):
                def _cb(*_args):
                    try:
                        fs.rates[ch_num] = float(var.get())
                    except (TypeError, ValueError):
                        fs.rates[ch_num] = 0.0
                    self._update_current_fixture_actuals()

                return _cb

            rate_var.trace_add("write", make_rate_callback(ch, rate_var))

        self._update_current_fixture_actuals()
        self.channel_frame.columnconfigure(4, weight=1)

    def _build_pattern_panel(self, parent: ttk.Frame) -> None:
        # Clear previous contents so this can be rebuilt after edits.
        for child in parent.winfo_children():
            child.destroy()

        ttk.Label(parent, text="Patterns").pack(anchor="w")

        self.pattern_active_vars = []

        for idx, pattern in enumerate(self.patterns):
            frame = ttk.LabelFrame(parent, text=f"Slot {idx+1}")
            frame.pack(fill="x", pady=4)

            name_var = tk.StringVar(value=pattern.name)

            def make_rename_callback(i: int, var: tk.StringVar):
                return lambda *_args: self._rename_pattern(i, var.get())

            name_var.trace_add("write", make_rename_callback(idx, name_var))

            ttk.Label(frame, text="Name").grid(row=0, column=0, sticky="w")
            ttk.Entry(frame, textvariable=name_var, width=18).grid(
                row=0, column=1, sticky="w"
            )

            ttk.Button(
                frame,
                text="Store from current",
                command=lambda i=idx: self.store_pattern(i),
            ).grid(row=0, column=2, padx=(8, 0))

            ttk.Button(
                frame,
                text="Activate",
                command=lambda i=idx: self.recall_pattern(i),
            ).grid(row=0, column=3, padx=(4, 0))

            ttk.Label(
                frame,
                text="OSC: /pattern %d" % (idx + 1),
                foreground="#666666",
            ).grid(row=0, column=4, padx=(8, 0))

            # Per-pattern lamp states: group 4 main heads and 2 mirrors, but keep
            # the controls visually tight by using small sub-frames.
            row_vars: List[tk.BooleanVar] = []

            lamps_frame = ttk.Frame(frame)
            lamps_frame.grid(row=1, column=0, columnspan=3, sticky="w")
            ttk.Label(lamps_frame, text="Lamps").pack(side="left")

            # Main fixtures (moving heads) 1–4.
            for f_idx in range(MOVING_HEAD_COUNT):
                var = tk.BooleanVar(value=pattern.active_fixtures[f_idx])
                row_vars.append(var)

                def make_cb_callback(p_index: int, f_index: int, v: tk.BooleanVar):
                    return lambda: self._set_pattern_fixture_active(
                        p_index, f_index, v.get()
                    )

                ttk.Checkbutton(
                    lamps_frame,
                    text=str(f_idx + 1),
                    variable=var,
                    command=make_cb_callback(idx, f_idx, var),
                ).pack(side="left", padx=(2, 0))

            mirrors_frame = ttk.Frame(frame)
            mirrors_frame.grid(row=1, column=3, columnspan=3, sticky="w")
            ttk.Label(mirrors_frame, text="Mirrors").pack(side="left")

            # Mirror fixtures 5–6.
            for hero_idx in range(HERO_COUNT):
                f_idx = MOVING_HEAD_COUNT + hero_idx
                var = tk.BooleanVar(value=pattern.active_fixtures[f_idx])
                row_vars.append(var)

                def make_cb_callback(p_index: int, f_index: int, v: tk.BooleanVar):
                    return lambda: self._set_pattern_fixture_active(
                        p_index, f_index, v.get()
                    )

                ttk.Checkbutton(
                    mirrors_frame,
                    text=str(f_idx + 1),
                    variable=var,
                    command=make_cb_callback(idx, f_idx, var),
                ).pack(side="left", padx=(2, 0))

            self.pattern_active_vars.append(row_vars)

        # Add-pattern button so the number of patterns is not fixed.
        ttk.Button(
            parent,
            text="Add pattern",
            command=self.add_pattern,
        ).pack(anchor="w", pady=(4, 0))

        # Global random pattern selector.
        ttk.Button(
            parent,
            text="Random pattern",
            command=self.recall_random_pattern,
        ).pack(anchor="w", pady=(8, 0))

        # Pattern sets (banks).
        sets_frame = ttk.LabelFrame(parent, text="Pattern sets")
        sets_frame.pack(fill="x", pady=(8, 0))

        ttk.Label(sets_frame, text="Name").grid(row=0, column=0, sticky="w")
        ttk.Entry(sets_frame, textvariable=self.set_name_var, width=12).grid(
            row=0, column=1, sticky="w"
        )
        ttk.Button(
            sets_frame,
            text="Store set from current",
            command=self.store_current_set,
        ).grid(row=0, column=2, padx=(8, 0))

        ttk.Label(sets_frame, text="Load").grid(
            row=1, column=0, sticky="w", pady=(4, 0)
        )
        set_names = [s.name for s in self.pattern_sets]
        set_combo = ttk.Combobox(
            sets_frame,
            textvariable=self.set_select_var,
            values=set_names,
            state="readonly",
            width=12,
        )
        set_combo.grid(row=1, column=1, sticky="w", pady=(4, 0))
        ttk.Button(
            sets_frame,
            text="Load set",
            command=self.load_selected_set,
        ).grid(row=1, column=2, padx=(8, 0), pady=(4, 0))

    # ----------------------------------------------------------------- DMX IO

    def _on_address_change(self, index: int, var: tk.IntVar) -> None:
        try:
            val = int(var.get())
        except ValueError:
            return
        self.fixture_states[index].start_address = max(1, min(512, val))

    def on_slider_change(self, channel: int) -> None:
        """
        Update current fixture state from slider changes and send a DMX snapshot.
        """
        fs = self.fixture_states[self.selected_fixture_index.get()]
        fs.slider_values[channel] = self.slider_vars[channel].get()
        fs.min_values[channel] = self.min_vars[channel].get()
        fs.max_values[channel] = self.max_vars[channel].get()
        self._update_current_fixture_actuals()
        self.send_snapshot()

    def _build_universe_frame(self) -> List[int]:
        """
        Build a 512-channel DMX frame by merging all fixtures.
        """
        frame = [0] * 512
        t = time.monotonic()
        for fs in self.fixture_states:
            values = fs.build_fixture_channels(t)
            start = fs.start_address - 1
            for i, val in enumerate(values):
                idx = start + i
                if 0 <= idx < 512:
                    frame[idx] = val
        return frame

    def send_snapshot(self) -> None:
        universe = int(self.universe_var.get())
        frame = self._build_universe_frame()
        send_single_frame(universe, frame)

    def _update_current_fixture_actuals(self) -> None:
        """
        Recompute and display the DMX values that correspond to the current
        fixture's sliders and min/max settings.
        """
        fs = self.fixture_states[self.selected_fixture_index.get()]
        # Use current time so that any LFO settings are reflected in the DMX column.
        values = fs.build_fixture_channels(time.monotonic())
        for ch, val in enumerate(values, start=1):
            if ch in self.actual_vars:
                self.actual_vars[ch].set(val)

    # ------------------------------------------------------------------ DMX tick

    def _schedule_tick(self) -> None:
        """Schedule the next DMX update tick."""
        self.root.after(self._tick_interval_ms, self._tick)

    def _tick(self) -> None:
        """
        Periodic update that keeps behaviours (e.g. LFOs) running and pushes DMX.
        Only sends frames while there is an active pattern.
        """
        try:
            if (
                self.active_pattern_index is not None
                and 0 <= self.active_pattern_index < len(self.patterns)
            ):
                pattern = self.patterns[self.active_pattern_index]
                if pattern.is_defined():
                    universe = int(self.universe_var.get())
                    frame = self._apply_active_mask(
                        self._build_universe_frame(), pattern.active_fixtures
                    )
                    send_single_frame(universe, frame)
                    # Also refresh the DMX values shown for the currently edited fixture.
                    self._update_current_fixture_actuals()
        finally:
            # Always reschedule to keep the loop running.
            self._schedule_tick()

    # --------------------------------------------------------------- Patterns

    def _rename_pattern(self, index: int, new_name: str) -> None:
        self.patterns[index].name = new_name

    def store_pattern(self, index: int) -> None:
        """
        Capture the current behaviours for all fixtures into the given pattern slot.
        """
        snapshot = copy.deepcopy(self.fixture_states)
        self.patterns[index].fixtures_state = snapshot
        self.active_pattern_index = index

    def recall_pattern(self, index: int) -> None:
        """
        Recall a stored pattern: send its DMX frame to the universe.
        """
        pattern = self.patterns[index]
        if not pattern.is_defined():
            return

        # Restore behaviours for all fixtures from the stored snapshot.
        self.fixture_states = copy.deepcopy(pattern.fixtures_state)
        for fs in self.fixture_states:
            fs.ensure_defaults()

        # Apply the active/inactive mask and send one immediate frame; ongoing
        # animation is handled by the regular tick loop.
        universe = int(self.universe_var.get())
        frame = self._apply_active_mask(self._build_universe_frame(), pattern.active_fixtures)
        send_single_frame(universe, frame)
        self.active_pattern_index = index

    def recall_random_pattern(self) -> None:
        """
        Pick a random defined pattern and activate it.
        """
        defined = [i for i, p in enumerate(self.patterns) if p.is_defined()]
        if not defined:
            return
        index = random.choice(defined)
        self.recall_pattern(index)

    def add_pattern(self) -> None:
        """
        Append a new empty pattern slot and rebuild the pattern panel.
        """
        new_index = len(self.patterns) + 1
        self.patterns.append(PatternSlot(name=f"Pattern {new_index}"))
        self._build_pattern_panel(self.pattern_panel)

    # -------------------------------------------------------------- Pattern sets

    def store_current_set(self) -> None:
        """
        Store the current list of patterns as a named set.
        If a set with the same name already exists, it is replaced.
        """
        name = self.set_name_var.get().strip() or f"Set {len(self.pattern_sets) + 1}"
        snapshot = copy.deepcopy(self.patterns)

        for s in self.pattern_sets:
            if s.name == name:
                s.patterns = snapshot
                break
        else:
            self.pattern_sets.append(PatternSet(name=name, patterns=snapshot))

        # Persist sets to disk.
        self._save_sets_to_disk()

        # Refresh the combo box by rebuilding the panel.
        self.set_select_var.set(name)
        self._build_pattern_panel(self.pattern_panel)

    def load_selected_set(self) -> None:
        """
        Load the patterns from the selected set into the controller.
        """
        name = self.set_select_var.get()
        if not name:
            return
        for s in self.pattern_sets:
            if s.name == name:
                self.patterns = copy.deepcopy(s.patterns)
                self._build_pattern_panel(self.pattern_panel)
                break

    # ---------------------------------------------------------- Persistence

    def _save_sets_to_disk(self) -> None:
        """
        Serialize all pattern sets to a JSON file so they survive restarts.
        """
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
                json.dump(data, f, indent=2)
        except OSError:
            # In gallery deployment we prefer to keep running even if disk is read-only.
            pass

    def _load_sets_from_disk(self) -> List[PatternSet]:
        """
        Load pattern sets from JSON if available.
        """
        if not os.path.exists(PATTERN_SETS_FILE):
            return []
        try:
            with open(PATTERN_SETS_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
        except (OSError, json.JSONDecodeError):
            return []

        sets: List[PatternSet] = []
        for s in data.get("sets", []):
            patterns: List[PatternSlot] = []
            for p in s.get("patterns", []):
                fixtures_state: List[FixtureState] = []
                for fs_data in p.get("fixtures", []):
                    fs = FixtureState(
                        start_address=fs_data.get("start_address", 1),
                        channel_count=fs_data.get("channel_count", 0),
                        min_values=fs_data.get("min_values", {}),
                        max_values=fs_data.get("max_values", {}),
                        slider_values=fs_data.get("slider_values", {}),
                        modes=fs_data.get("modes", {}),
                        rates=fs_data.get("rates", {}),
                        phases=fs_data.get("phases", {}),
                    )
                    fixtures_state.append(fs)

                patterns.append(
                    PatternSlot(
                        name=p.get("name", "Pattern"),
                        fixtures_state=fixtures_state if fixtures_state else None,
                        active_fixtures=p.get(
                            "active_fixtures",
                            [True for _ in range(FIXTURE_COUNT)],
                        ),
                    )
                )
            sets.append(PatternSet(name=s.get("name", "Set"), patterns=patterns))
        return sets

    # ------------------------------------------------------------------ OSC

    def start_osc(self) -> None:
        """
        Start a background OSC server listening for /pattern messages.
        """
        if self._osc_server is not None:
            return

        dispatcher = Dispatcher()
        dispatcher.map("/pattern", self._osc_pattern_handler)
        dispatcher.map("/pattern_random", self._osc_random_handler)
        dispatcher.map("/pattern/random", self._osc_random_handler)

        port = int(self.osc_port_var.get())
        server = ThreadingOSCUDPServer(("0.0.0.0", port), dispatcher)
        self._osc_server = server

        def serve() -> None:
            server.serve_forever()

        thread = threading.Thread(target=serve, daemon=True)
        self._osc_thread = thread
        thread.start()

    def _osc_pattern_handler(self, _addr, *args) -> None:
        """
        Handle OSC messages of the form:
        - /pattern <index>        (1-based pattern index)
        """
        if not args:
            return
        try:
            index = int(args[0]) - 1
        except (TypeError, ValueError):
            return
        if 0 <= index < len(self.patterns):
            # Schedule recall on the Tk thread.
            self.root.after(0, lambda i=index: self.recall_pattern(i))

    def _osc_random_handler(self, _addr, *_args) -> None:
        """
        Handle OSC message to activate a random pattern:
        - /pattern_random
        - /pattern/random
        """
        self.root.after(0, self.recall_random_pattern)

    # --------------------------------------------------------- Pattern utils

    def _set_pattern_fixture_active(
        self, pattern_index: int, fixture_index: int, active: bool
    ) -> None:
        """
        Update the stored on/off state for a given fixture inside a pattern.
        """
        self.patterns[pattern_index].active_fixtures[fixture_index] = active

    def _apply_active_mask(
        self, frame: List[int], active_fixtures: List[bool]
    ) -> List[int]:
        """
        Given a full 512-channel frame plus per-fixture active flags,
        return a new frame where inactive fixtures are forced off (DMX=0).
        """
        new_frame = list(frame)
        for idx, fs in enumerate(self.fixture_states):
            if idx >= len(active_fixtures):
                continue
            if active_fixtures[idx]:
                continue
            start = fs.start_address - 1
            end = start + fs.channel_count
            for ch in range(start, min(end, 512)):
                new_frame[ch] = 0
        return new_frame

    # ------------------------------------------------------ OLA diagnostics UI

    def check_ola_status(self) -> None:
        """
        Try to connect to the OLA daemon and update the status label.
        This does NOT change any OLA configuration; it is only a diagnostic.
        """
        try:
            wrapper = ClientWrapper()
            # Creating the client is enough to verify connectivity.
            _ = wrapper.Client()
        except OLADNotRunningException:
            self.ola_status_var.set(
                "OLAD not running on localhost (port 9010). "
                "IMOL will try to start it automatically on first DMX send."
            )
            return
        except Exception as exc:
            self.ola_status_var.set(f"OLA error: {exc}")
            return

        self.ola_status_var.set(
            f"Connected to OLAD on localhost. Sending DMX to universe {self.universe_var.get()}."
        )

    def open_ola_ui(self) -> None:
        """
        Open the OLA web UI in the default browser for advanced configuration.
        """
        try:
            webbrowser.open("http://localhost:9090")
        except Exception:
            # If opening the browser fails, just update the status label.
            self.ola_status_var.set("Could not open browser. Visit http://localhost:9090 manually.")


def main() -> None:
    fixture_def = load_fixture_definition(FIXTURES_FILE, FIXTURE_KEY)
    root = tk.Tk()
    app = PatternControllerApp(root, fixture_def)
    root.mainloop()


if __name__ == "__main__":
    main()


