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
  - Controls **4 identical fixtures** on one universe.
  - Each fixture keeps its own configuration and thresholds.
  - Patterns = snapshots of all 4 fixtures **plus** per-lamp on/off state.
  - Patterns can be:
    - Activated from the GUI.
    - Selected at random (Random pattern button).
    - Recalled via OSC:
      - `/pattern N` → activate pattern N (1-based).
      - `/pattern_random` or `/pattern/random` → activate a random stored pattern.


