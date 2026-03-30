# IMOL — Mac mini setup: OLA + Art-Net (DMX) (step-by-step)

This guide is the **repeatable setup** for running this exact IMOL project on a new macOS machine (e.g. a Mac mini) and ensuring **OLA DMX output works reliably**.

IMOL sends DMX using OLA’s Python client (`ClientWrapper` → `SendDmx`) and targets an **OLA universe number** (the UI label `u:` in `IMOL_PATTERN_CONTROLLER_QT.py`). OLA is responsible for mapping that universe to the physical/network output (Art-Net → your node → DMX port).

## 0) What you need (hardware + assumptions)

- A Mac mini on the same network as your Art-Net node (e.g. Showtec Net 2/3).
- You know which **DMX port** on the node you want to drive (Port 1, Port 2, etc).
- You can access the node’s configuration UI (usually via its IP + browser).

### Your current known-good values (for this IMOL rig)

- **Node (Showtec Net 2/3) IP**: `2.0.0.1`
- **Universe used by this repo**: `0` (default in `fixtures.yml`, and the `u:` control in the Qt controller)

## 1) Install OLA (Homebrew)

1. Install Homebrew (if needed).
2. Install OLA:

```bash
brew install ola
```

3. Start OLA as a background service:

```bash
brew services start ola
```

4. Confirm it’s running:

```bash
brew services list | grep ola
```

Notes:
- IMOL expects to talk to `olad` on **localhost:9010** (OLA RPC).
- OLA’s Web UI is typically available at `http://localhost:9090`.

## 2) Configure macOS network for Art-Net (critical)

Art-Net commonly uses a **2.x.x.x** IPv4 scheme.

1. Choose the network interface you’ll use (Ethernet strongly recommended).
2. In **System Settings → Network → (Ethernet)**:
   - Set **Configure IPv4**: *Manually*
   - Set an IP on the Art-Net subnet (must be unique; do **not** reuse the node’s `2.0.0.1`), e.g.:
     - IP: `2.0.0.10` (Mac mini)
     - Subnet mask: `255.0.0.0`
     - Router: (usually blank for isolated Art-Net networks)
3. Confirm the interface has the expected IP:

```bash
ifconfig | grep -n "inet 2\\."
```

If your node uses a different subnet, match that instead. The key is: **Mac + node must be routable on the same L2/L3 network**.

## 3) Configure OLA Art-Net plugin (the “ola-artnet.conf” part)

OLA stores per-user configs under `~/.ola/`. On your current machine we found:

- `~/.ola/ola-artnet.conf`

On the Mac mini you have two options:

### Option A (recommended): configure via OLA Web UI and let it write `~/.ola/*`

1. Open the OLA Web UI: `http://localhost:9090`
2. Go to **Plugins → ArtNet**
3. Ensure:
   - Art-Net plugin is **enabled**
   - The plugin is bound to the **correct interface/IP**
   - Output ports count matches what you need (commonly 4)
4. Apply/save.

### Option B: copy your known-good config from the old machine

Copy the entire `~/.ola/` folder from the old machine to the Mac mini user:

```bash
rsync -av /path/to/old/.ola/ /Users/<your_user>/.ola/
```

Then restart OLA:

```bash
brew services restart ola
```

Important (exact-copy gotcha):
- `~/.ola/ola-artnet.conf` typically contains an `ip = ...` field.
- That `ip` must match the **Mac mini’s own interface IP** on the Art-Net network (for example, `2.0.0.10`), not the node’s `2.0.0.1`.
- If you copy `~/.ola/` from another machine, make sure to update that `ip` value (or re-save via the OLA Web UI).

## 4) Patch the OLA Universe to the Art-Net output port (most common “it doesn’t output” cause)

IMOL sends to an **OLA universe number** (default in this repo is typically `0` in `fixtures.yml`).

You must ensure that universe is patched to an output.

In OLA Web UI:
1. Go to **Universe**
2. Find your target universe (e.g. **Universe 0**)
3. Patch its output to **ArtNet** and select the correct output port
4. Confirm the universe shows a patched output (not “unpatched”)

If you don’t patch, IMOL can “send successfully” but nothing leaves the computer.

## 5) macOS firewall / permission gotchas

- If prompted, allow incoming connections for `olad`.
- If you run a dedicated Art-Net network (no router), keep Wi‑Fi disabled to avoid routing surprises.

## 6) Set up the IMOL Python environment on the Mac mini

From the repo root:

1. Create/activate a venv (example):

```bash
python3 -m venv imol-venv
source imol-venv/bin/activate
```

2. Install dependencies:

```bash
pip install -r python-light-engine/requirements.txt
```

## 7) Verify end-to-end DMX output (do this before opening the GUI)

### 7.1 Verify OLA is reachable from Python

Run a **raw single-channel** test using IMOL’s own sender (`python-light-engine/main.py`):

```bash
python python-light-engine/main.py --universe 0 --raw-channel 1 --raw-value 255
```

Expected:
- No crash.
- Your node should output DMX on the patched port, and a fixture addressed at channel 1 should respond.

If it fails with “OLAD not running”:
- Start OLA (`brew services start ola`)
- Or run `olad` manually once to inspect logs.

### 7.2 Verify from the main IMOL controller

Run:

```bash
python python-light-engine/IMOL_PATTERN_CONTROLLER_QT.py
```

Then:
- Set `u:` to the universe you patched (commonly `0`).
- Use a simple channel (e.g. Dimmer) to confirm response.
- If nothing responds:
  - Re-check Universe patching in OLA UI
  - Re-check the Mac mini interface IP/subnet
  - Re-check the Art-Net node port mapping

## 8) “Known-good” IMOL expectations (important details)

- IMOL always sends a **512-byte DMX frame** and expects 1-based fixture addressing.
- The Qt controller uses a **persistent OLA sender thread** to avoid macOS `select()` fd-range errors.
- If DMX send fails, IMOL will attempt to start `olad` automatically, but the most reliable path is still `brew services start ola`.

## 9) Troubleshooting checklist (fast)

If DMX does not reach the node:
- Confirm Mac mini has `2.x.x.x` IP (or whatever subnet your node uses).
- Confirm OLA Art-Net plugin is **enabled**.
- Confirm your target universe is **patched** to Art-Net output.
- Confirm node is on the same subnet and the correct DMX port is selected on the node.
- Use the raw send test:
  - `python python-light-engine/main.py --universe 0 --raw-channel 1 --raw-value 255`

