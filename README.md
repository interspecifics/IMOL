An Instrument Made of Light
============================

This repository contains the software components for **An Instrument Made of Light**, a light-based audio-visual instrument and graphic score.

The system is composed of four main subsystems:

- Audio & ML Analysis Engine (Max/MSP + FluCoMa)
- Autonomous Light Pattern System (Python + OLA + Showtec Net 2/3)
- Computer Vision & Score Extraction (Python or Max/MSP)
- Spectral Configuration & GUI (Max/MSP)

For a high-level description of the concept and architecture, see:

- `IMOL_Arquitecture.md`
- `docs/concept.md`


## Python light engine tools

- `python-light-engine/IMOL_FIXTURE_TESTER.py`
  - Local tester for a single fixture definition (`fixtures.yml`).
  - Per-channel faders with editable min/max thresholds.
  - Compact DMX monitor grid for quick visual debugging.
- `python-light-engine/IMOL_PATTERN_CONTROLLER_QT.py`
  - **Main gallery controller** (Qt / PySide6) for the IMOL light engine.
  - Controls **9 fixtures** on one universe:
    - 4 moving-head spots (`moving_head_14ch`).
    - 2 Varytec Hero mirror fixtures (`varytec_hero_mirror_8ch`).
    - 2 MBM40D mirror-ball motors (`mbm40d_mirror_motor_1ch`).
    - 1 fog machine (`af150_fog_1ch`).
  - Fixture setup:
    - `FIXTURES ADD` panel with `f1..f9` DMX start addresses.
    - Per-fixture editor with channels laid out from `fixtures.yml`.
  - Per-channel **behaviours**:
    - Parameters: Min, Max, Ctl (manual offset), Mode, Rate, DMX (live value).
    - Modes: `off`, `static`, `sine`, `square`, `saw`.
    - Rate: floating-point LFO speed in Hz (e.g. `0.050`, `1.250`).
  - Patterns:
    - Slots that store **full FixtureState behaviours** for all fixtures, not just DMX snapshots.
    - Per-slot on/off mask for Lamps (1–4), Mirrors (5–6), Motors (7–8), Fog (9).
    - Background DMX tick loop continuously animates behaviours between Min/Max.
  - Pattern control:
    - Activate directly from the GUI (per-slot `Activate`).
    - `Add pattern` / `Random pattern` buttons, with the pattern list in a scrollable area.
    - OSC:
      - `/pattern N` → activate pattern N (1-based).
      - `/pattern 0` → stop (clears the active pattern; does not automatically blackout).
      - `/pattern_random` or `/pattern/random` → activate a random stored pattern.
      - `/blackout` → hard reset (all fixtures off).
      - Incoming OSC is shown in an **OSC IN** monitor inside the UI.
  - Pattern sets:
    - Named banks of patterns stored in `python-light-engine/pattern_sets.json`.
    - `Store set from current` and `Load set` for fast gallery deployment.
  - OLA / network integration:
    - Universe selector (`u:`) and OSC port selector (`osc:`).
    - `OLA SERVICES` panel: `CHECK`, `OPEN UI`, `STOP`, `RESTART`, `START` (via `brew services`).
    - Automatic attempt to start `olad` if DMX send fails.
    - DMX sending is handled by a persistent background sender to avoid macOS `select()` fd-range errors.
  - Engine / external control:
    - Live **DMX FPS** readout.
    - Toggle to enable/disable external OSC pattern control (from Max or other tools).
    - `/link/*` OSC hooks for Ableton Link style sync via a bridge:
      - `/link/enable 0|1`
      - `/link/tempo <bpm>`
      - `/link/beat <beat_position>`
    - `Hard reset (all fixtures off)` button that immediately stops behaviours and sends a black DMX frame.
  - UI / theme:
    - Dark, gallery-friendly theme with green accent colour.
    - Scrollable pattern panel to keep the layout stable even with many patterns.

- `python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py`
  - Qt-based **computer vision graphic score** tool (PySide6 + OpenCV).
  - Top row:
    - Left: CV view (adjustable contrast / brightness / gamma) + detection overlays.
    - Right: Audio panel:
      - Select a folder (loads a random file).
      - Shows waveform + spectrogram + context text from matching `.rtf` / `.txt`.
      - Feature playback uses a monotonic timebase (smooth timing even if UI drops frames).
      - Extracted features are clustered into **7 patterns** (k-means on windowed feature vectors) and sent via OSC as `/pattern N`.
      - Spectrogram now includes a minimal **Hz frequency scale** (0..Nyquist) for readability.
  - Bottom row:
    - Scrolling **graphic score** that accumulates the light field over time.
    - Optional **spectrogram-style rendering** (paper texture + energy-based drawing).

## Quick start: CV Graphic Score (dual OSC by default)

`IMOL_CV_GRAPHIC_SCORE_QT.py` now runs with a gallery-friendly default preset and OSC routing:

- Lights (pattern controller): `/pattern <int>` → `127.0.0.1:9000`
- Max (tracker stream): `/system/state`, `/state/N`, optional `/track/*` → `127.0.0.1:9001`
- Default preset: `spectro_mean`

Run:

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py
```

### OSC overrides / escape hatches

- **Disable all OSC**:

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py --osc-out-disable
```

- **Disable `/track/A..F`** (keep `/system/state` + `/state/N`):

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py --osc-out-no-tracks
```

### Spectrogram-style score rendering

Defaults are already tuned via the `spectro_mean` preset, but you can still override rendering:

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py --score-style spectrogram --score-spectro-render-mode profile
```

### Repository note: large local media is ignored

The `audio/` folder (archives + processed audio) is **intentionally not tracked** and is ignored by git for repository size/privacy reasons. Use the Audio panel inside `IMOL_CV_GRAPHIC_SCORE_QT.py` to select your local audio folder at runtime.

### Max patches

`max_resynth/` is tracked in this repo and contains Max/MSP materials used in the spectral resynthesis part of the system.

## Max: partials loader + tracker-to-notes

### Partials file loader → `coll my_partials_bank`

- **Loader**: `max_resynth/partials_bank_to_coll.js`
  - **Outlet 0**: connect to `coll my_partials_bank` (sends `clear` + `store <key> <triplets...>`)
  - **Outlet 1**: status/debug (safe to connect to UI/print)

Core commands (sent to the `js` object):

- `setfolder /Users/microhm/Desktop/01_Proyectos/IMOL/max_resynth`
- `scan .txt`
- `jump` (pick a random file from the scanned list and ingest it)
- `setautonext 1` (after ingest finishes, automatically `jump` again)
- `setautonextdelay 150` (ms)

Status verbosity controls:

- `setfilelist 0` (default: `files <count>` only)
- `setfilelist 1` (also send full file paths list)
- `setprogressinterval 120` (rate limit for progress updates)

### Loader status UI (recommended): `dict.view`

`jsui` can be fragile in Max; the reliable approach is a dict-based status panel.

- **Bridge**: `max_resynth/partials_loader_status_to_dict.js`
  - Connect loader outlet 1 → bridge inlet
  - Bridge writes Dict named `partials_loader_status` and outputs a `bang` when updated

Minimal patch:

- `dict partials_loader_status`
- `dict.view partials_loader_status`
- Wire: `partials_loader_status_to_dict.js` outlet 0 → `dict.view partials_loader_status`

### Tracker → Jitter "note" pulses (SpectralSynthesis)

To use the OSC tracker stream (port 9001) to trigger momentary "notes" in the Jitter amplitude system:

- **Script**: `max_resynth/osc_to_jitter_notes.js`
  - Pulses the two `jit.bfg` controls used in `SpectralSynthesis.maxpat`:
    - `offset $1 0. 0., bang`
    - `scale $1, bang`
  - Selects a playable bin using the current `jit.spill` (83 floats) list.
  - Supports delta-triggering from a smooth `/system/state` float and randomized sustain/delay presets.

