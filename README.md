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

### Run the CV Graphic Score

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py --camera-index 0
```

#### Spectrogram-style score rendering (energy + paper texture)

- **Profile mode** (continuous energy bands):

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py --score-style spectrogram --score-spectro-render-mode profile
```

- **Slice mode** (preserves more visible light shapes inside the spectrogram field):

```bash
python python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py --score-style spectrogram --score-spectro-render-mode slice --score-spectro-slices-per-frame 3 --score-spectro-slice-step 6
```

### Repository note: large local media is ignored

The `audio/` folder (archives + processed audio) is **intentionally not tracked** and is ignored by git for repository size/privacy reasons. Use the Audio panel inside `IMOL_CV_GRAPHIC_SCORE_QT.py` to select your local audio folder at runtime.

### Max patches

`max_resynth/` is tracked in this repo and contains Max/MSP materials used in the spectral resynthesis part of the system.

