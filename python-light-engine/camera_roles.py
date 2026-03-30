"""
camera_roles.py
---------------

Small, dependency-free helpers to keep two identical webcams stable by role.

We store a perceptual hash (dHash) per role ("score", "motor") in a JSON file.
On startup we can probe camera indices and pick the one whose live frame hash
best matches the saved role hash (robust to index swapping).
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import cv2
import numpy as np


DEFAULT_ROLES_PATH = Path(__file__).resolve().parent / "camera_roles.json"


@dataclass
class CameraRoleEntry:
    role: str
    dhash_hex: str
    index_hint: Optional[int] = None


def _dhash_from_gray(gray: np.ndarray, *, hash_size: int = 8) -> int:
    """
    Compute a simple dHash (difference hash) from a grayscale image.
    Returns an integer with hash_size*hash_size bits.
    """
    if gray is None or gray.size == 0:
        return 0
    h = int(hash_size)
    w = int(hash_size) + 1
    small = cv2.resize(gray, (w, h), interpolation=cv2.INTER_AREA)
    diff = small[:, 1:] > small[:, :-1]
    bits = diff.astype(np.uint8).flatten()
    out = 0
    for b in bits.tolist():
        out = (out << 1) | int(b)
    return int(out)


def dhash_hex_from_bgr(frame_bgr: np.ndarray, *, hash_size: int = 8) -> str:
    gray = cv2.cvtColor(frame_bgr, cv2.COLOR_BGR2GRAY)
    v = _dhash_from_gray(gray, hash_size=hash_size)
    width = (hash_size * hash_size + 3) // 4
    return f"{v:0{width}x}"


def hamming_hex(a_hex: str, b_hex: str) -> int:
    try:
        a = int(str(a_hex).strip(), 16)
        b = int(str(b_hex).strip(), 16)
    except Exception:
        return 10**9
    return int((a ^ b).bit_count())


def load_roles(path: Path = DEFAULT_ROLES_PATH) -> dict[str, CameraRoleEntry]:
    try:
        if not path.exists():
            return {}
        data = json.loads(path.read_text(encoding="utf-8"))
        out: dict[str, CameraRoleEntry] = {}
        if isinstance(data, dict):
            for role, v in data.items():
                if not isinstance(v, dict):
                    continue
                dh = v.get("dhash_hex")
                if not isinstance(dh, str) or not dh:
                    continue
                idx = v.get("index_hint")
                idx_i = None
                try:
                    if idx is not None:
                        idx_i = int(idx)
                except Exception:
                    idx_i = None
                out[str(role)] = CameraRoleEntry(role=str(role), dhash_hex=str(dh), index_hint=idx_i)
        return out
    except Exception:
        return {}


def save_role(role: str, dhash_hex: str, *, index_hint: Optional[int] = None, path: Path = DEFAULT_ROLES_PATH) -> None:
    role = str(role).strip().lower()
    if not role:
        return
    roles = load_roles(path)
    roles[role] = CameraRoleEntry(role=role, dhash_hex=str(dhash_hex), index_hint=index_hint)
    out = {k: {"dhash_hex": v.dhash_hex, "index_hint": v.index_hint} for k, v in roles.items()}
    path.write_text(json.dumps(out, indent=2, sort_keys=True), encoding="utf-8")


def probe_best_index_for_role(
    role: str,
    *,
    max_index: int = 8,
    warmup_frames: int = 2,
    read_timeout_s: float = 0.6,
    path: Path = DEFAULT_ROLES_PATH,
) -> Optional[int]:
    """
    Try indices 0..max_index and return the index that best matches the saved role dhash.
    Returns None if role isn't calibrated or no camera can be read.
    """
    role = str(role).strip().lower()
    roles = load_roles(path)
    entry = roles.get(role)
    if entry is None:
        return None

    best_idx: Optional[int] = None
    best_dist = 10**9

    idx_order = list(range(0, int(max_index) + 1))
    if entry.index_hint is not None and int(entry.index_hint) in idx_order:
        idx_order.remove(int(entry.index_hint))
        idx_order.insert(0, int(entry.index_hint))

    for idx in idx_order:
        cap = None
        try:
            cap = cv2.VideoCapture(int(idx), cv2.CAP_ANY)
            if cap is None or not cap.isOpened():
                continue
            t0 = cv2.getTickCount()
            frame = None
            for _ in range(int(max(1, warmup_frames))):
                ok, fr = cap.read()
                if ok and fr is not None:
                    frame = fr
                t = (cv2.getTickCount() - t0) / cv2.getTickFrequency()
                if t > float(read_timeout_s):
                    break
            if frame is None:
                continue
            h = dhash_hex_from_bgr(frame)
            d = hamming_hex(entry.dhash_hex, h)
            if d < best_dist:
                best_dist = d
                best_idx = int(idx)
        except Exception:
            continue
        finally:
            try:
                if cap is not None:
                    cap.release()
            except Exception:
                pass

    return best_idx

