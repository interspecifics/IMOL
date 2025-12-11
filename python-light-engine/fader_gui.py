import tkinter as tk
from tkinter import ttk
from tkinter import font as tkfont

import yaml

from main import build_dmx_frame, send_single_frame


FIXTURES_FILE = "fixtures.yml"
DEFAULT_FIXTURE = "moving_head_14ch"


def load_fixtures(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data["fixtures"]


class FaderApp:
    def __init__(self, root: tk.Tk, fixtures: dict, fixture_name: str) -> None:
        self.root = root
        self.fixtures = fixtures
        self.fixture_name_var = tk.StringVar(value=fixture_name)

        fixture = fixtures[fixture_name]
        self.universe_var = tk.IntVar(value=fixture.get("default_universe", 0))
        self.address_var = tk.IntVar(value=fixture.get("default_address", 1))

        self._load_fixture_channels()

        self.slider_vars = {}
        self.min_vars = {}
        self.max_vars = {}

        # DMX monitor state: last full 512-channel frame.
        self.dmx_values = [0] * 512
        self.monitor_labels = {}

        self._build_ui()

    def _build_ui(self) -> None:
        self.root.title("IMOL DMX Faders")

        header = ttk.Frame(self.root)
        header.pack(fill="x", padx=8, pady=4)

        ttk.Label(header, text="Fixture").grid(row=0, column=0, sticky="w")
        fixture_names = sorted(self.fixtures.keys())
        fixture_combo = ttk.Combobox(
            header,
            textvariable=self.fixture_name_var,
            values=fixture_names,
            state="readonly",
            width=18,
        )
        fixture_combo.grid(row=0, column=1, sticky="w")
        fixture_combo.bind("<<ComboboxSelected>>", self.on_fixture_change)

        ttk.Label(header, text="Universe").grid(row=0, column=2, padx=(12, 0))
        ttk.Entry(header, textvariable=self.universe_var, width=5).grid(
            row=0, column=3, sticky="w"
        )

        ttk.Label(header, text="Start address").grid(row=0, column=4, padx=(12, 0))
        ttk.Entry(header, textvariable=self.address_var, width=5).grid(
            row=0, column=5, sticky="w"
        )

        ttk.Label(
            header, text="Drag faders; values are mapped through per-channel min/max."
        ).grid(row=1, column=0, columnspan=6, sticky="w", pady=(4, 0))

        self.body = ttk.Frame(self.root)
        self.body.pack(fill="both", expand=True, padx=8, pady=4)

        self._build_body()

        self.monitor = ttk.Frame(self.root)
        self.monitor.pack(fill="both", expand=False, padx=8, pady=(0, 8))
        self._build_monitor()

        footer = ttk.Frame(self.root)
        footer.pack(fill="x", padx=8, pady=4)
        ttk.Button(footer, text="Send snapshot", command=self.send_snapshot).pack(
            side="left"
        )

    def _build_body(self) -> None:
        for child in self.body.winfo_children():
            child.destroy()

        ttk.Label(self.body, text="Fixture Ch").grid(row=0, column=0, sticky="w")
        ttk.Label(self.body, text="DMX Ch").grid(row=0, column=1, sticky="w")
        ttk.Label(self.body, text="Name").grid(row=0, column=2, sticky="w")
        ttk.Label(self.body, text="Min").grid(row=0, column=3, sticky="w")
        ttk.Label(self.body, text="Max").grid(row=0, column=4, sticky="w")
        ttk.Label(self.body, text="Slider").grid(row=0, column=5, sticky="w")
        ttk.Label(self.body, text="Val").grid(row=0, column=6, sticky="w")

        base_address = int(self.address_var.get())

        for row_index, ch in enumerate(self.channel_numbers, start=1):
            cfg = self.channel_config.get(ch, {})
            name = cfg.get("name", "")
            dmx_channel = base_address + ch - 1

            ttk.Label(self.body, text=str(ch)).grid(
                row=row_index, column=0, sticky="w"
            )
            ttk.Label(self.body, text=str(dmx_channel)).grid(
                row=row_index, column=1, sticky="w"
            )
            ttk.Label(self.body, text=name).grid(
                row=row_index, column=2, sticky="w"
            )

            min_var = self.min_vars.get(ch) or tk.IntVar(value=0)
            max_var = self.max_vars.get(ch) or tk.IntVar(value=255)
            self.min_vars[ch] = min_var
            self.max_vars[ch] = max_var

            ttk.Entry(self.body, textvariable=min_var, width=5).grid(
                row=row_index, column=3, sticky="w"
            )
            ttk.Entry(self.body, textvariable=max_var, width=5).grid(
                row=row_index, column=4, sticky="w"
            )

            slider_var = self.slider_vars.get(ch) or tk.IntVar(value=0)
            self.slider_vars[ch] = slider_var
            slider = ttk.Scale(
                self.body,
                from_=0,
                to=255,
                orient="horizontal",
                variable=slider_var,
                command=lambda _val, ch_num=ch: self.on_slider_change(ch_num),
            )
            slider.grid(row=row_index, column=5, sticky="we", padx=(4, 0))

            # Numeric view / edit for the slider value (0-255)
            ttk.Entry(self.body, textvariable=slider_var, width=4).grid(
                row=row_index, column=6, sticky="w", padx=(4, 0)
            )

        self.body.columnconfigure(5, weight=1)

    def _build_monitor(self) -> None:
        for child in self.monitor.winfo_children():
            child.destroy()

        header_font = tkfont.nametofont("TkDefaultFont").copy()
        header_font.configure(size=9)
        cell_font = tkfont.nametofont("TkDefaultFont").copy()
        cell_font.configure(size=7)

        ttk.Label(
            self.monitor,
            text="DMX Monitor (Universe snapshot)",
            font=header_font,
        ).grid(row=0, column=0, columnspan=16, sticky="w")

        self.monitor_labels = {}
        columns = 16
        for ch in range(1, 513):
            row = (ch - 1) // columns + 1
            col = (ch - 1) % columns
            val = self.dmx_values[ch - 1]
            text = f"{val:3}"
            lbl = ttk.Label(
                self.monitor,
                text=text,
                relief="groove",
                padding=1,
                font=cell_font,
            )
            lbl.grid(row=row, column=col, padx=1, pady=1, sticky="nsew")
            self.monitor_labels[ch] = lbl

        for c in range(columns):
            self.monitor.columnconfigure(c, weight=1)

    def _load_fixture_channels(self) -> None:
        fixture = self.fixtures[self.fixture_name_var.get()]
        self.channel_config = fixture["channels"]
        # Use all declared channels; this defines the footprint.
        self.channel_numbers = sorted(self.channel_config.keys())

    def _build_channel_values(self) -> list:
        total_channels = max(self.channel_numbers)
        values = [0] * total_channels

        for ch in self.channel_numbers:
            slider_val = self.slider_vars[ch].get()
            try:
                min_v = int(self.min_vars[ch].get())
            except ValueError:
                min_v = 0
            try:
                max_v = int(self.max_vars[ch].get())
            except ValueError:
                max_v = 255

            min_v = max(0, min(255, min_v))
            max_v = max(0, min(255, max_v))
            if max_v < min_v:
                max_v, min_v = min_v, max_v

            # Map slider 0-255 into [min_v, max_v]
            if max_v == min_v:
                actual = min_v
            else:
                ratio = slider_val / 255.0
                actual = int(round(min_v + ratio * (max_v - min_v)))

            values[ch - 1] = actual

        return values

    def send_snapshot(self) -> None:
        universe = int(self.universe_var.get())
        address = int(self.address_var.get())
        channel_values = self._build_channel_values()
        frame = build_dmx_frame(
            address=address,
            total_channels=len(channel_values),
            channel_values=channel_values,
        )
        # Store full DMX frame for monitor (ensure length 512).
        if len(frame) < 512:
            frame = frame + [0] * (512 - len(frame))
        self.dmx_values = frame[:512]
        self._update_dmx_monitor()
        send_single_frame(universe, frame)

    def on_slider_change(self, _channel: int) -> None:
        # For now, send a snapshot on any slider change.
        self.send_snapshot()

    def on_fixture_change(self, _event=None) -> None:
        fixture = self.fixtures[self.fixture_name_var.get()]
        self.universe_var.set(fixture.get("default_universe", 0))
        self.address_var.set(fixture.get("default_address", 1))
        self.min_vars.clear()
        self.max_vars.clear()
        self.slider_vars.clear()
        self._load_fixture_channels()
        self._build_body()

    def _update_dmx_monitor(self) -> None:
        for ch, lbl in self.monitor_labels.items():
            val = self.dmx_values[ch - 1]
            lbl.config(text=f"{val:3}")


def main() -> None:
    fixtures = load_fixtures(FIXTURES_FILE)
    root = tk.Tk()
    FaderApp(root, fixtures, DEFAULT_FIXTURE)
    root.mainloop()


if __name__ == "__main__":
    main()


