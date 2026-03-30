import argparse
import subprocess
import time
from typing import List

import yaml
from ola.ClientWrapper import ClientWrapper
from ola.OlaClient import OLADNotRunningException


class DmxByteArray(bytearray):
    """
    Small compatibility wrapper so that OLA's Python bindings (which expect
    a 'tostring()' or 'tobytes()' method) work across OLA versions.
    """

    def tostring(self):
        return bytes(self)

    def tobytes(self):
        return bytes(self)


def load_fixture(path: str, fixture_name: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data["fixtures"][fixture_name]


def build_dmx_frame(
    address: int,
    total_channels: int,
    channel_values: List[int],
) -> List[int]:
    """
    Build a 512-byte DMX frame.

    address: 1-based DMX start address of the fixture.
    total_channels: number of channels used by the fixture (e.g. 14).
    channel_values: list of values (0-255) for each channel of the fixture.
    """
    frame = [0] * 512
    start_index = address - 1
    for i in range(total_channels):
        if i < len(channel_values):
            frame[start_index + i] = max(0, min(255, int(channel_values[i])))
    return frame


def _start_olad_if_needed() -> None:
    """
    Try to start the OLA daemon (olad) if it is not running.

    This is a best-effort helper so that the IMOL apps can be launched
    directly in the gallery without manually starting OLA via the web UI.
    """
    try:
        # Launch olad in the background. If it is already running this
        # should be harmless; olad will usually exit or report an error.
        subprocess.Popen(
            ["olad"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        # Give olad a brief moment to start listening.
        time.sleep(1.0)
    except OSError:
        # If olad is not found or cannot be started we just fall back to
        # the normal error path; the caller will see the OLADNotRunningException.
        pass


def send_single_frame(universe: int, frame: List[int]) -> None:
    """
    Send one DMX frame to the given universe and exit.
    """

    def dmx_sent(state):
        wrapper.Stop()

    try:
        wrapper = ClientWrapper()
    except OLADNotRunningException:
        # Attempt to start olad automatically and retry once.
        _start_olad_if_needed()
        wrapper = ClientWrapper()

    client = wrapper.Client()
    client.SendDmx(universe, DmxByteArray(frame), dmx_sent)
    wrapper.Run()


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Minimal DMX test sender for Showtec Net 2/3 and a 14-channel moving head.",
    )
    parser.add_argument(
        "--universe",
        type=int,
        default=None,
        help="OLA universe number for this fixture (default: from fixtures.yml).",
    )
    parser.add_argument(
        "--address",
        type=int,
        default=None,
        help="DMX start address of the fixture (1-512). Default: from fixtures.yml.",
    )
    parser.add_argument(
        "--fixture",
        type=str,
        default="moving_head_14ch",
        help="Fixture key in fixtures.yml.",
    )
    parser.add_argument(
        "--fixtures-file",
        type=str,
        default="fixtures.yml",
        help="Path to fixtures.yml.",
    )
    parser.add_argument(
        "--raw-channel",
        type=int,
        default=None,
        help="If set, bypass fixture mapping and send a simple frame with this DMX channel at --raw-value.",
    )
    parser.add_argument(
        "--raw-value",
        type=int,
        default=255,
        help="Value (0-255) to send on --raw-channel. Default: 255.",
    )
    args = parser.parse_args()

    # Raw test mode: send a single DMX channel value, useful for debugging.
    if args.raw_channel is not None:
        universe = args.universe if args.universe is not None else 0
        channel = max(1, min(512, args.raw_channel))
        value = max(0, min(255, args.raw_value))
        frame = [0] * 512
        frame[channel - 1] = value
        send_single_frame(universe, frame)
        return

    fixture = load_fixture(args.fixtures_file, args.fixture)
    universe = args.universe or fixture.get("default_universe", 1)
    address = args.address or fixture.get("default_address", 1)

    # Simple test pattern:
    # - Color channel: white (0-7)
    # - Strobe off
    # - Dimmer at full
    # - Pattern disk: circular pattern (0-5)
    # - Prism off
    # - Pan/tilt centered, speed medium
    channel_values = [
        0,    # 1 color: white
        0,    # 2 strobe: off
        255,  # 3 dimmer: full
        0,    # 4 pattern disk: circular pattern
        0,    # 5 prism: off
        0,    # 6 various colours: not used in this test
        127,  # 7 focus: mid
        127,  # 8 X
        127,  # 9 X fine
        127,  # 10 Y
        127,  # 11 Y fine
        127,  # 12 XY speed: medium
        0,    # 13 Auto/Sound: no auto
        0,    # 14 reset: no reset
    ]

    frame = build_dmx_frame(address=address, total_channels=len(channel_values), channel_values=channel_values)
    send_single_frame(universe, frame)


if __name__ == "__main__":
    main()


