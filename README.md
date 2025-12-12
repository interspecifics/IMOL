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
- `python-light-engine/IMOL_PATTERN_CONTROLLER.py`
  - Controls **6 fixtures** on one universe:
    - 4 moving-head spots (`moving_head_14ch`).
    - 2 Varytec Hero mirror fixtures (`varytec_hero_mirror_8ch`).
  - Each fixture keeps its own configuration and thresholds (Min/Max/Ctl + DMX feedback).
  - Per-channel **behaviours**:
    - Mode: `off`, `static`, `sine`.
    - Rate: LFO speed in Hz for `sine` mode.
  - Patterns:
    - Store full fixture behaviours (not only DMX snapshots) **plus** per-lamp on/off state.
    - Behaviours are animated in real time via a background DMX tick loop.
  - Patterns can be:
    - Activated from the GUI.
    - Selected at random (Random pattern button).
    - Recalled via OSC:
      - `/pattern N` → activate pattern N (1-based).
      - `/pattern_random` or `/pattern/random` → activate a random stored pattern.
  - Pattern sets:
    - Named banks of patterns (e.g. "Intro", "Dense") stored in `pattern_sets.json`.
    - Can be stored and reloaded for fast gallery deployment.


