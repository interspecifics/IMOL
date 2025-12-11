"""
IMOL_PATTERN_CONTROLLER
-----------------------

High-level controller for four moving-head fixtures.

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

import yaml
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import ThreadingOSCUDPServer

from main import build_dmx_frame, send_single_frame


FIXTURES_FILE = "fixtures.yml"
FIXTURE_KEY = "moving_head_14ch"
FIXTURE_COUNT = 4
DEFAULT_OSC_PORT = 9000


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

    def ensure_defaults(self) -> None:
        for ch in range(1, self.channel_count + 1):
            self.min_values.setdefault(ch, 0)
            self.max_values.setdefault(ch, 255)
            self.slider_values.setdefault(ch, 0)

    def build_fixture_channels(self) -> List[int]:
        """
        Convert slider values + thresholds to concrete DMX values for this fixture.
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

            if max_v == min_v:
                actual = min_v
            else:
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
    dmx_frame: Optional[List[int]] = None
    active_fixtures: List[bool] = field(
        default_factory=lambda: [True for _ in range(FIXTURE_COUNT)]
    )

    def is_defined(self) -> bool:
        return self.dmx_frame is not None


class PatternControllerApp:
    def __init__(self, root: tk.Tk, fixture_def: dict) -> None:
        self.root = root
        self.fixture_def = fixture_def
        self.channel_count = len(fixture_def["channels"])

        self.universe_var = tk.IntVar(value=fixture_def.get("default_universe", 0))
        self.osc_port_var = tk.IntVar(value=DEFAULT_OSC_PORT)

        # Four fixtures, each with its own start address.
        self.fixture_states: List[FixtureState] = []
        for i in range(FIXTURE_COUNT):
            start_addr = fixture_def.get("default_address", 1) + i * self.channel_count
            self.fixture_states.append(
                FixtureState(
                    start_address=start_addr,
                    channel_count=self.channel_count,
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

        # GUI state for the per-channel editor.
        self.slider_vars: Dict[int, tk.IntVar] = {}
        self.min_vars: Dict[int, tk.IntVar] = {}
        self.max_vars: Dict[int, tk.IntVar] = {}

        # OSC server thread handle.
        self._osc_server: Optional[ThreadingOSCUDPServer] = None
        self._osc_thread: Optional[threading.Thread] = None

        self._build_ui()

    # ------------------------------------------------------------------ GUI

    def _build_ui(self) -> None:
        self.root.title("IMOL Pattern Controller (4 fixtures)")

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
        self._build_pattern_panel(right)

    def _rebuild_channel_editor(self) -> None:
        for child in self.channel_frame.winfo_children():
            child.destroy()

        fs = self.fixture_states[self.selected_fixture_index.get()]

        ttk.Label(self.channel_frame, text="Ch").grid(row=0, column=0, sticky="w")
        ttk.Label(self.channel_frame, text="Name").grid(row=0, column=1, sticky="w")
        ttk.Label(self.channel_frame, text="Min").grid(row=0, column=2, sticky="w")
        ttk.Label(self.channel_frame, text="Max").grid(row=0, column=3, sticky="w")
        ttk.Label(self.channel_frame, text="Val").grid(row=0, column=4, sticky="w")

        channels = self.fixture_def["channels"]
        self.slider_vars.clear()
        self.min_vars.clear()
        self.max_vars.clear()

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

            self.min_vars[ch] = min_var
            self.max_vars[ch] = max_var
            self.slider_vars[ch] = slider_var

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

        self.channel_frame.columnconfigure(4, weight=1)

    def _build_pattern_panel(self, parent: ttk.Frame) -> None:
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

            # Per-pattern lamp states (on/off for each of the four fixtures).
            ttk.Label(frame, text="Lamps").grid(row=1, column=0, sticky="w")
            row_vars: List[tk.BooleanVar] = []
            for f_idx in range(FIXTURE_COUNT):
                var = tk.BooleanVar(value=pattern.active_fixtures[f_idx])
                row_vars.append(var)

                def make_cb_callback(p_index: int, f_index: int, v: tk.BooleanVar):
                    return lambda: self._set_pattern_fixture_active(
                        p_index, f_index, v.get()
                    )

                ttk.Checkbutton(
                    frame,
                    text=str(f_idx + 1),
                    variable=var,
                    command=make_cb_callback(idx, f_idx, var),
                ).grid(row=1, column=1 + f_idx, sticky="w")

            self.pattern_active_vars.append(row_vars)

        # Global random pattern selector.
        ttk.Button(
            parent,
            text="Random pattern",
            command=self.recall_random_pattern,
        ).pack(anchor="w", pady=(8, 0))

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
        self.send_snapshot()

    def _build_universe_frame(self) -> List[int]:
        """
        Build a 512-channel DMX frame by merging all fixtures.
        """
        frame = [0] * 512
        for fs in self.fixture_states:
            values = fs.build_fixture_channels()
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

    # --------------------------------------------------------------- Patterns

    def _rename_pattern(self, index: int, new_name: str) -> None:
        self.patterns[index].name = new_name

    def store_pattern(self, index: int) -> None:
        """
        Capture the current DMX universe into the given pattern slot.
        """
        frame = self._build_universe_frame()
        self.patterns[index].dmx_frame = frame
        self.active_pattern_index = index

    def recall_pattern(self, index: int) -> None:
        """
        Recall a stored pattern: send its DMX frame to the universe.
        """
        pattern = self.patterns[index]
        if not pattern.is_defined():
            return
        universe = int(self.universe_var.get())
        frame = self._apply_active_mask(pattern.dmx_frame, pattern.active_fixtures)
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


def main() -> None:
    fixture_def = load_fixture_definition(FIXTURES_FILE, FIXTURE_KEY)
    root = tk.Tk()
    app = PatternControllerApp(root, fixture_def)
    root.mainloop()


if __name__ == "__main__":
    main()


