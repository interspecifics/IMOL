"""
Adaptive OSC Controller - Activity-Driven Transmission Modes

This module adjusts OSC transmission rates and smoothing based on detected activity level.
Three modes:
  A) STATIC    - Low activity: slow rates, high smoothing, large deltas
  B) SMOOTH    - Medium activity: LFO-like smooth evolution
  C) DYNAMIC   - High activity: fast rates, low smoothing, catch all changes

The controller smoothly interpolates parameters when switching modes to avoid jumps.
"""

import time
from typing import Dict, Optional
import numpy as np


class AdaptiveOscController:
    """
    Manages OSC transmission parameters based on activity level.
    
    Activity-driven modes:
    - Mode A (STATIC):   activity < low_threshold  → almost static transmission
    - Mode B (SMOOTH):   activity < high_threshold → smooth LFO-like
    - Mode C (DYNAMIC):  activity >= high_threshold → highly responsive
    
    Parameters adjusted per mode:
    - system_state_rate_hz: /system/state send rate
    - stateB_rate_hz: /system/stateB send rate
    - stateB_tau_s: smoothing time constant for stateB
    - vel_value_rate_hz: /vel/value send rate
    - feat_rate_hz: /feat/* send rate
    - min_delta: minimum change threshold to send updates
    """
    
    def __init__(
        self,
        *,
        mode_a_threshold: float = 0.3,
        mode_c_threshold: float = 0.7,
        transition_tau: float = 3.0,
    ):
        """
        Args:
            mode_a_threshold: activity below this → Mode A (STATIC)
            mode_c_threshold: activity above this → Mode C (DYNAMIC)
            transition_tau: smoothing time for mode transitions (seconds)
        """
        self.mode_a_threshold = float(mode_a_threshold)
        self.mode_c_threshold = float(mode_c_threshold)
        self.transition_tau = float(transition_tau)
        
        # Current mode
        self.current_mode: str = "B"  # A, B, or C
        self.mode_entry_time: float = time.monotonic()
        
        # Activity level input
        self.activity_level: float = 0.0
        self.activity_smooth: float = 0.0
        self.activity_last_update: float = time.monotonic()
        
        # Current OSC parameters (smoothly interpolated)
        self.system_state_rate_hz: float = 5.0
        self.stateB_rate_hz: float = 2.0
        self.stateB_tau_s: float = 10.0
        self.vel_value_rate_hz: float = 5.0
        self.feat_rate_hz: float = 3.0
        self.system_min_delta: float = 0.02
        self.vel_min_delta: float = 0.02
        self.feat_min_delta: float = 0.03
        
        # Target parameters per mode (defined below)
        self.mode_params: Dict[str, Dict] = {
            'A': {  # STATIC - almost motionless (very slow)
                'system_state_rate_hz': 0.1,    # 1 msg every 10 seconds
                'stateB_rate_hz': 0.02,         # 1 msg every 50 seconds
                'stateB_tau_s': 60.0,
                'vel_value_rate_hz': 0.2,       # 1 msg every 5 seconds
                'feat_rate_hz': 0.1,            # 1 msg every 10 seconds
                'system_min_delta': 0.1,
                'vel_min_delta': 0.08,
                'feat_min_delta': 0.1,
            },
            'B': {  # SMOOTH - LFO-like evolution (slow)
                'system_state_rate_hz': 0.5,    # 1 msg every 2 seconds
                'stateB_rate_hz': 0.1,          # 1 msg every 10 seconds
                'stateB_tau_s': 20.0,
                'vel_value_rate_hz': 1.0,       # 1 msg per second
                'feat_rate_hz': 0.5,            # 1 msg every 2 seconds
                'system_min_delta': 0.03,
                'vel_min_delta': 0.03,
                'feat_min_delta': 0.04,
            },
            'C': {  # DYNAMIC - highly responsive (moderate)
                'system_state_rate_hz': 2.0,    # 2 msgs per second
                'stateB_rate_hz': 0.5,          # 1 msg every 2 seconds
                'stateB_tau_s': 5.0,
                'vel_value_rate_hz': 2.0,       # 2 msgs per second
                'feat_rate_hz': 1.0,            # 1 msg per second
                'system_min_delta': 0.005,
                'vel_min_delta': 0.01,
                'feat_min_delta': 0.01,
            },
        }
        
        # Interpolation state (for smooth transitions)
        self.target_params: Dict = self.mode_params['B'].copy()
        self.interp_alpha: float = 0.0
        
        print(f"[OSC_ADAPTIVE] Initialized: A<{self.mode_a_threshold}, C>{self.mode_c_threshold}, tau={self.transition_tau}s")
    
    def update_activity(self, activity_level: float) -> None:
        """
        Update activity level and recompute mode if needed.
        
        Args:
            activity_level: float 0-1, current activity from CV
        """
        self.activity_level = float(np.clip(activity_level, 0.0, 1.0))
        
        # Determine target mode based on activity with hysteresis
        new_mode = self._select_mode(self.activity_level)
        
        if new_mode != self.current_mode:
            self._switch_mode(new_mode)
        
        # Interpolate parameters toward target
        self._interpolate_params()
    
    def _select_mode(self, activity: float) -> str:
        """Select mode with hysteresis to avoid rapid switching."""
        hyst = 0.05  # Hysteresis band
        
        # If currently in A, need activity > threshold + hyst to leave
        if self.current_mode == 'A':
            if activity > (self.mode_a_threshold + hyst):
                if activity >= (self.mode_c_threshold - hyst):
                    return 'C'
                else:
                    return 'B'
            else:
                return 'A'
        
        # If currently in C, need activity < threshold - hyst to leave
        elif self.current_mode == 'C':
            if activity < (self.mode_c_threshold - hyst):
                if activity <= (self.mode_a_threshold + hyst):
                    return 'A'
                else:
                    return 'B'
            else:
                return 'C'
        
        # Currently in B
        else:
            if activity <= (self.mode_a_threshold - hyst):
                return 'A'
            elif activity >= (self.mode_c_threshold + hyst):
                return 'C'
            else:
                return 'B'
    
    def _switch_mode(self, new_mode: str) -> None:
        """Switch to a new mode and set target parameters."""
        old_mode = self.current_mode
        self.current_mode = new_mode
        self.mode_entry_time = time.monotonic()
        self.target_params = self.mode_params[new_mode].copy()
        
        print(f"[OSC_ADAPTIVE] Mode switch: {old_mode} → {new_mode} (activity={self.activity_level:.2f})")
    
    def _interpolate_params(self) -> None:
        """Smoothly interpolate current params toward target."""
        now = time.monotonic()
        dt = float(now - self.activity_last_update)
        self.activity_last_update = now
        
        if dt <= 0.0 or dt > 1.0:
            return
        
        # Exponential smoothing toward target
        alpha = 1.0 - np.exp(-dt / max(0.001, self.transition_tau))
        
        for key in self.target_params:
            target = float(self.target_params[key])
            current = float(getattr(self, key, target))
            new_val = (1.0 - alpha) * current + alpha * target
            setattr(self, key, float(new_val))
    
    def get_params(self) -> Dict:
        """Return current OSC parameters."""
        return {
            'mode': self.current_mode,
            'activity_level': round(self.activity_level, 3),
            'system_state_rate_hz': round(self.system_state_rate_hz, 2),
            'stateB_rate_hz': round(self.stateB_rate_hz, 2),
            'stateB_tau_s': round(self.stateB_tau_s, 2),
            'vel_value_rate_hz': round(self.vel_value_rate_hz, 2),
            'feat_rate_hz': round(self.feat_rate_hz, 2),
            'system_min_delta': round(self.system_min_delta, 4),
            'vel_min_delta': round(self.vel_min_delta, 4),
            'feat_min_delta': round(self.feat_min_delta, 4),
        }
    
    def should_send(
        self,
        address: str,
        current_value: float,
        last_value: Optional[float],
        last_send_time: float,
        now: float,
    ) -> bool:
        """
        Check if an OSC message should be sent based on rate + delta.
        
        Args:
            address: OSC address (e.g., '/system/state', '/vel/value')
            current_value: current value to send
            last_value: last sent value (None if never sent)
            last_send_time: monotonic time of last send
            now: current monotonic time
        
        Returns:
            True if message should be sent
        """
        # Determine rate and min_delta for this address
        if 'state' in address and 'stateB' not in address:
            rate_hz = self.system_state_rate_hz
            min_delta = self.system_min_delta
        elif 'stateB' in address:
            rate_hz = self.stateB_rate_hz
            min_delta = self.system_min_delta  # Use same delta as state
        elif 'vel' in address:
            rate_hz = self.vel_value_rate_hz
            min_delta = self.vel_min_delta
        elif 'feat' in address:
            rate_hz = self.feat_rate_hz
            min_delta = self.feat_min_delta
        else:
            # Unknown address, use default
            rate_hz = 5.0
            min_delta = 0.02
        
        # Check rate limit
        min_dt = 1.0 / float(max(0.01, rate_hz))
        if (now - last_send_time) < min_dt:
            return False
        
        # Check min_delta (if last_value is available)
        if last_value is not None:
            delta = abs(float(current_value) - float(last_value))
            if delta < min_delta:
                return False
        
        return True
    
    def get_status_string(self) -> str:
        """Return a human-readable status string."""
        mode_labels = {'A': 'STATIC', 'B': 'SMOOTH', 'C': 'DYNAMIC'}
        label = mode_labels.get(self.current_mode, self.current_mode)
        return f"Mode {self.current_mode} ({label}) | activity={self.activity_level:.2f} | state_rate={self.system_state_rate_hz:.1f}Hz"
