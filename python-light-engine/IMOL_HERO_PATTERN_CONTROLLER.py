"""
IMOL_HERO_PATTERN_CONTROLLER
---------------------------

Dedicated controller for **two Varytec Hero Mirror** fixtures in 8‑channel DMX
mode (`varytec_hero_mirror_8ch` in `fixtures.yml`).

This file prototypes the behaviour-based approach discussed in the main
controller:
- Each channel has: min, max, control (0–255), mode, rate.
- Modes:
  - "static": DMX is just the control value mapped into [min, max].
  - "lfo": DMX oscillates between [min, max] using a sine LFO at `rate` Hz.
- Patterns store the **behaviours**, not only the raw DMX frame.
"""

import math
import time
import copy
from dataclasses import dataclass, field
from typing import Dict, List

import tkinter as tk
from tkinter import ttk
import yaml

from main import build_dmx_frame, send_single_frame


FIXTURES_FILE = "fixtures.yml"
FIXTURE_KEY = "varytec_hero_mirror_8ch"
HERO_FIXTURE_COUNT = 2


def load_fixture_definition(path: str, fixture_key: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data["fixtures"][fixture_key]


@dataclass
class ChannelBehaviour:
    min: int = 0
    max: int = 255
    control: int = 0  # 0–255
    mode: str = "static"  # "static" or "lfo"
    rate: float = 0.1  # Hz
    phase: float = 0.0  # 0–1


@dataclass
class HeroFixtureState:
    start_address: int
    channel_count: int
    channels: Dict[int, ChannelBehaviour] = field(default_factory=dict)

    def ensure_channels(self) -> None:
        for ch in range(1, self.channel_count + 1):
            self.channels.setdefault(ch, ChannelBehaviour())


@dataclass
class HeroPattern:
    name: str
    fixtures: List[HeroFixtureState]
    active_fixtures: List[bool]


class HeroControllerApp:
    def __init__(self, root: tk.Tk, fixture_def: dict) -> None:
        self.root = root
        self.fixture_def = fixture_def
        self.channel_count = len(fixture_def["channels"])

        self.universe_var = tk.IntVar(value=fixture_def.get("default_universe", 0))

        # Two hero fixtures.
        self.fixtures: List[HeroFixtureState] = []
        start_addr = fixture_def.get("default_address", 1)
        for i in range(HERO_FIXTURE_COUNT):
            fs = HeroFixtureState(
                start_address=start_addr + i * self.channel_count,
                channel_count=self.channel_count,
            )
            fs.ensure_channels()
            self.fixtures.append(fs)

        self.selected_fixture = tk.IntVar(value=0)

        # Behaviours UI state.
        self.min_vars: Dict[int, tk.IntVar] = {}
        self.max_vars: Dict[int, tk.IntVar] = {}
        self.ctrl_vars: Dict[int, tk.IntVar] = {}
        self.mode_vars: Dict[int, tk.StringVar] = {}
        self.rate_vars: Dict[int, tk.DoubleVar] = {}
        self.dmx_vars: Dict[int, tk.IntVar] = {}

        # Patterns: start with 4 empty.
        self.patterns: List[HeroPattern] = [
            HeroPattern(
                name=f"Pattern {i+1}",
                fixtures=copy.deepcopy(self.fixtures),
                active_fixtures=[True] * HERO_FIXTURE_COUNT,
            )
            for i in range(4)
        ]

        self._build_ui()

        # Animation loop.
        self._last_time = time.monotonic()
        self._running = True
        self.root.after(33, self._tick)

    # ------------------------------------------------------------------ GUI

    def _build_ui(self) -> None:
        self.root.title("IMOL Hero Pattern Controller (2 mirrors)")

        top = ttk.Frame(self.root)
        top.pack(fill="x", padx=8, pady=4)

        ttk.Label(top, text="Universe").grid(row=0, column=0, sticky="w")
        ttk.Entry(top, textvariable=self.universe_var, width=5).grid(
            row=0, column=1, sticky="w"
        )

        # Fixture addresses.
        for i in range(HERO_FIXTURE_COUNT):
            fs = self.fixtures[i]
            addr_var = tk.IntVar(value=fs.start_address)

            def make_cb(idx: int, v: tk.IntVar):
                return lambda *_: self._update_fixture_address(idx, v)

            addr_var.trace_add("write", make_cb(i, addr_var))
            ttk.Label(top, text=f"Hero {i+1} addr").grid(
                row=0, column=2 + i * 2, padx=(12 if i == 0 else 4, 0)
            )
            ttk.Entry(top, textvariable=addr_var, width=5).grid(
                row=0, column=3 + i * 2, sticky="w"
            )

        body = ttk.Frame(self.root)
        body.pack(fill="both", expand=True, padx=8, pady=4)

        left = ttk.Frame(body)
        left.pack(side="left", fill="both", expand=True)

        right = ttk.Frame(body)
        right.pack(side="right", fill="both", expand=True, padx=(8, 0))

        # Fixture selector.
        sel = ttk.Frame(left)
        sel.pack(fill="x", pady=(0, 4))
        ttk.Label(sel, text="Fixture").grid(row=0, column=0, sticky="w")
        for i in range(HERO_FIXTURE_COUNT):
            ttk.Radiobutton(
                sel,
                text=str(i + 1),
                value=i,
                variable=self.selected_fixture,
                command=self._rebuild_channel_editor,
            ).grid(row=0, column=1 + i, sticky="w")

        self.channel_frame = ttk.Frame(left)
        self.channel_frame.pack(fill="both", expand=True)
        self._rebuild_channel_editor()

        # Simple pattern buttons on the right.
        ttk.Label(right, text="Patterns").pack(anchor="w")
        for idx, pat in enumerate(self.patterns):
            frame = ttk.Frame(right)
            frame.pack(fill="x", pady=2)
            ttk.Label(frame, text=f"{idx+1}.").grid(row=0, column=0, sticky="w")
            ttk.Label(frame, text=pat.name).grid(row=0, column=1, sticky="w")
            ttk.Button(
                frame, text="Store", command=lambda i=idx: self.store_pattern(i)
            ).grid(row=0, column=2, padx=(4, 0))
            ttk.Button(
                frame, text="Activate", command=lambda i=idx: self.activate_pattern(i)
            ).grid(row=0, column=3, padx=(4, 0))

    def _rebuild_channel_editor(self) -> None:
        for child in self.channel_frame.winfo_children():
            child.destroy()

        fs = self.fixtures[self.selected_fixture.get()]
        fs.ensure_channels()

        ttk.Label(self.channel_frame, text="Ch").grid(row=0, column=0, sticky="w")
        ttk.Label(self.channel_frame, text="Name").grid(row=0, column=1, sticky="w")
        ttk.Label(self.channel_frame, text="Min").grid(row=0, column=2, sticky="w")
        ttk.Label(self.channel_frame, text="Max").grid(row=0, column=3, sticky="w")
        ttk.Label(self.channel_frame, text="Ctl").grid(row=0, column=4, sticky="w")
        ttk.Label(self.channel_frame, text="Mode").grid(row=0, column=5, sticky="w")
        ttk.Label(self.channel_frame, text="Rate Hz").grid(row=0, column=6, sticky="w")
        ttk.Label(self.channel_frame, text="DMX").grid(row=0, column=7, sticky="w")

        channels = self.fixture_def["channels"]
        self.min_vars.clear()
        self.max_vars.clear()
        self.ctrl_vars.clear()
        self.mode_vars.clear()
        self.rate_vars.clear()
        self.dmx_vars.clear()

        for row_index, ch in enumerate(sorted(channels.keys()), start=1):
            beh = fs.channels[ch]
            name = channels[ch].get("name", "")

            ttk.Label(self.channel_frame, text=str(ch)).grid(
                row=row_index, column=0, sticky="w"
            )
            ttk.Label(self.channel_frame, text=name).grid(
                row=row_index, column=1, sticky="w"
            )

            min_var = tk.IntVar(value=beh.min)
            max_var = tk.IntVar(value=beh.max)
            ctrl_var = tk.IntVar(value=beh.control)
            mode_var = tk.StringVar(value=beh.mode)
            rate_var = tk.DoubleVar(value=beh.rate)
            dmx_var = tk.IntVar(value=0)

            self.min_vars[ch] = min_var
            self.max_vars[ch] = max_var
            self.ctrl_vars[ch] = ctrl_var
            self.mode_vars[ch] = mode_var
            self.rate_vars[ch] = rate_var
            self.dmx_vars[ch] = dmx_var

            ttk.Entry(self.channel_frame, textvariable=min_var, width=4).grid(
                row=row_index, column=2, sticky="w"
            )
            ttk.Entry(self.channel_frame, textvariable=max_var, width=4).grid(
                row=row_index, column=3, sticky="w"
            )
            ttk.Scale(
                self.channel_frame,
                from_=0,
                to=255,
                orient="horizontal",
                variable=ctrl_var,
            ).grid(row=row_index, column=4, sticky="we", padx=(4, 0))

            mode_cb = ttk.Combobox(
                self.channel_frame,
                textvariable=mode_var,
                values=["static", "lfo"],
                state="readonly",
                width=7,
            )
            mode_cb.grid(row=row_index, column=5, sticky="w")

            ttk.Entry(self.channel_frame, textvariable=rate_var, width=6).grid(
                row=row_index, column=6, sticky="w"
            )

            ttk.Label(self.channel_frame, textvariable=dmx_var, width=4).grid(
                row=row_index, column=7, sticky="w"
            )

        self.channel_frame.columnconfigure(4, weight=1)

    # ----------------------------------------------------------------- DMX / behaviour

    def _update_fixture_address(self, index: int, var: tk.IntVar) -> None:
        try:
            val = int(var.get())
        except ValueError:
            return
        self.fixtures[index].start_address = max(1, min(512, val))

    def _compute_channel_value(self, beh: ChannelBehaviour, t: float) -> int:
        # Normalize 0–1 based on mode.
        if beh.mode == "lfo":
            phase = beh.phase + beh.rate * t
            norm = 0.5 + 0.5 * math.sin(2 * math.pi * phase)
        else:  # static
            norm = beh.control / 255.0

        norm = max(0.0, min(1.0, norm))
        return int(round(beh.min + (beh.max - beh.min) * norm))

    def _build_universe_frame(self, t: float) -> List[int]:
        frame = [0] * 512
        for fs in self.fixtures:
            fs.ensure_channels()
            local_vals: List[int] = []
            for ch in range(1, fs.channel_count + 1):
                beh = fs.channels[ch]
                # sync behaviour from UI if this is the selected fixture
                if fs is self.fixtures[self.selected_fixture.get()] and ch in self.min_vars:
                    beh.min = int(self.min_vars[ch].get())
                    beh.max = int(self.max_vars[ch].get())
                    beh.control = int(self.ctrl_vars[ch].get())
                    beh.mode = self.mode_vars[ch].get()
                    beh.rate = float(self.rate_vars[ch].get())
                val = self._compute_channel_value(beh, t)
                local_vals.append(val)
                if fs is self.fixtures[self.selected_fixture.get()] and ch in self.dmx_vars:
                    self.dmx_vars[ch].set(val)

            # Map into 512-frame via build_dmx_frame helper.
            partial = build_dmx_frame(
                address=fs.start_address,
                total_channels=fs.channel_count,
                channel_values=local_vals,
            )
            for i in range(512):
                if partial[i]:
                    frame[i] = partial[i]
        return frame

    def _tick(self) -> None:
        if not self._running:
            return
        now = time.monotonic()
        t = now  # absolute time; rate handles frequency
        frame = self._build_universe_frame(t)
        send_single_frame(int(self.universe_var.get()), frame)
        self.root.after(33, self._tick)

    # ----------------------------------------------------------------- Patterns

    def store_pattern(self, index: int) -> None:
        # Deep-copy current behaviours into the pattern.
        self.patterns[index] = HeroPattern(
            name=self.patterns[index].name,
            fixtures=copy.deepcopy(self.fixtures),
            active_fixtures=self.patterns[index].active_fixtures[:],
        )

    def activate_pattern(self, index: int) -> None:
        # Replace current fixtures with behaviours from the pattern.
        pat = self.patterns[index]
        self.fixtures = copy.deepcopy(pat.fixtures)
        self._rebuild_channel_editor()


def main() -> None:
    fixture_def = load_fixture_definition(FIXTURES_FILE, FIXTURE_KEY)
    root = tk.Tk()
    app = HeroControllerApp(root, fixture_def)
    root.mainloop()


if __name__ == "__main__":
    main()

