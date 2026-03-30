# OSC Addresses (Draft)

Proposed OSC namespaces (to align with IMOL_Arquitecture.md):

- /ml_state intensity texture_id pattern_mode
- /score/cluster_count
- /score/brightness_map
- /score/constellation_id
- /score/motion_energy
- /score/region_activity[0..N]

This file will be the canonical reference for all OSC endpoints used in the system.

## Tracker stream (Score app -> Max)

Sent by `python-light-engine/IMOL_CV_GRAPHIC_SCORE_QT.py` in `--osc-out-format tracker` to the **track OSC** destination (default `127.0.0.1:9001`).

- **`/pattern <int>`**: current detected state index (0..N). (Used for lights and for general debugging.)
- **`/state/<N> <0|1>`**: one-hot toggles; when state changes, previous goes to 0 and new goes to 1.
- **`/system/state <float>`**: continuous smoothed state value (fast/normal smoothing).
- **`/system/stateB <float>`**: continuous smoothed state value with **very slow evolution** (glide/slew) to avoid jumps in Max.
  - Controlled by CLI:
    - `--osc-tracker-systemB-tau-s <seconds>` (bigger = slower; default 8.0)
    - `--osc-tracker-systemB-rate-hz <Hz>` (rate limit; default 5.0)
    - `--osc-tracker-systemB-min-delta <float>` (min change to send; default 0.01)
    - `--osc-tracker-systemB-disable` to disable entirely

Optional energy/features:

- **`/vel/<0..4> <0|1>`**: discrete energy level toggles derived from RMS.
- **`/vel/value <0..1>`**: continuous RMS energy value (rate-limited + min-delta).
- **`/feat/* <0..1>`**: normalized features (only if enabled via `--osc-out-send-features`).


