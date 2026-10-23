"""
CV State Analyzer - Machine Learning for Computer Vision State Detection

This module analyzes CV detections (blobs, tracks) and learns patterns to assign
states (1-14) using MiniBatchKMeans clustering. It extracts spatial, temporal,
and activity features from the CV stream.

The learned model is persisted so it can continue learning across sessions.
"""

import json
import time
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import numpy as np

try:
    from sklearn.cluster import MiniBatchKMeans
    SKLEARN_AVAILABLE = True
except ImportError:
    SKLEARN_AVAILABLE = False
    print("[CV_STATE] Warning: scikit-learn not available, falling back to rule-based")


class CvStateAnalyzer:
    """
    Analyzes CV detection stream and assigns states (1-14) using online ML.
    
    Features extracted per frame:
    - blob_count: number of detected lights
    - total_area: sum of all blob areas (normalized)
    - spatial_spread: std deviation of blob centers
    - mean_velocity: average motion magnitude
    - mean_intensity: average brightness
    - left_right_balance: spatial symmetry
    - top_bottom_balance: vertical distribution
    - cluster_density: how grouped/scattered blobs are
    
    ML: MiniBatchKMeans with k=14, learns online, persists to disk.
    """
    
    def __init__(
        self,
        *,
        n_states: int = 14,
        frame_width: int = 640,
        frame_height: int = 360,
        model_path: Optional[Path] = None,
        learning_rate: float = 0.1,
        smoothing_tau: float = 1.0,
        use_ml: bool = True,
    ):
        self.n_states = int(n_states)
        self.frame_w = int(frame_width)
        self.frame_h = int(frame_height)
        self.model_path = Path(model_path) if model_path else Path("cv_state_model.json")
        self.learning_rate = float(learning_rate)
        self.smoothing_tau = float(smoothing_tau)
        self.use_ml = bool(use_ml) and SKLEARN_AVAILABLE
        
        # Feature vector dimension (8 features currently)
        self.feature_dim = 8
        
        # ML model (MiniBatchKMeans)
        self.kmeans: Optional[MiniBatchKMeans] = None
        self.cluster_stats: Dict[int, Dict] = {}  # cluster_id -> {count, last_seen, mean_activity}
        self.frame_count: int = 0
        self.training_frames: int = 0
        
        # State smoothing (prevent rapid jumps)
        self.current_state: int = 1
        self.state_history: List[int] = []
        self.state_dwell_frames: int = 0
        self.min_dwell_frames: int = 2  # Must stay in state for N frames before switching (reduced for faster response)
        
        # Activity level computation (for OSC mode selection)
        self.activity_level: float = 0.0
        self.activity_smooth: float = 0.0
        self.activity_tau: float = 2.0  # seconds
        self.activity_last_update: float = time.monotonic()
        
        # Previous frame state (for velocity computation)
        self.prev_centers: List[Tuple[float, float]] = []
        
        # Initialize or load model
        if self.use_ml:
            self._init_or_load_model()
        
        print(f"[CV_STATE] Initialized: n_states={self.n_states}, use_ml={self.use_ml}, model={self.model_path}")
    
    def _init_or_load_model(self) -> None:
        """Initialize MiniBatchKMeans or load from disk if available."""
        if not SKLEARN_AVAILABLE:
            self.use_ml = False
            return
        
        loaded = False
        if self.model_path.exists():
            try:
                loaded = self._load_model()
            except Exception as e:
                print(f"[CV_STATE] Failed to load model: {e}")
        
        if not loaded:
            # Initialize with sensible cluster centers (spanning feature space)
            # Features: [blob_count, total_area, spread, velocity, intensity, lr_bal, tb_bal, density]
            # Each normalized 0-1, seed clusters MORE VARIED across the space
            init_centers = []
            for i in range(self.n_states):
                t = float(i) / float(max(1, self.n_states - 1))
                
                # Create distinct regions in feature space
                # Use different patterns for low/mid/high states
                if t < 0.33:  # Low activity states (1-5)
                    center = [
                        t * 0.4,                      # blob_count (few blobs)
                        t * 0.3,                      # total_area (small)
                        0.2 + t * 0.3,                # spread (tight to medium)
                        t * 0.2,                      # velocity (slow)
                        0.4 + t * 0.3,                # intensity (medium-bright)
                        0.5 + 0.2 * np.sin(t * 4 * np.pi),  # lr_balance (varied)
                        0.5 + 0.2 * np.cos(t * 4 * np.pi),  # tb_balance (varied)
                        0.7 - t * 0.3,                # density (tight clusters)
                    ]
                elif t < 0.67:  # Medium activity states (6-9)
                    center = [
                        0.3 + (t - 0.33) * 0.6,       # blob_count (medium)
                        0.3 + (t - 0.33) * 0.5,       # total_area (medium)
                        0.4 + (t - 0.33) * 0.4,       # spread (medium to wide)
                        0.2 + (t - 0.33) * 0.5,       # velocity (medium)
                        0.5 + (t - 0.33) * 0.3,       # intensity (bright)
                        0.5 + 0.3 * np.sin(t * 3 * np.pi),
                        0.5 + 0.3 * np.cos(t * 3 * np.pi),
                        0.5 - (t - 0.33) * 0.2,       # density (medium)
                    ]
                else:  # High activity states (10-14)
                    center = [
                        0.6 + (t - 0.67) * 1.0,       # blob_count (many)
                        0.6 + (t - 0.67) * 1.0,       # total_area (large)
                        0.6 + (t - 0.67) * 1.0,       # spread (wide)
                        0.5 + (t - 0.67) * 1.5,       # velocity (fast)
                        0.6 + (t - 0.67) * 0.4,       # intensity (very bright)
                        0.5 + 0.4 * np.sin(t * 2 * np.pi),
                        0.5 + 0.4 * np.cos(t * 2 * np.pi),
                        0.3 - (t - 0.67) * 0.3,       # density (scattered)
                    ]
                
                init_centers.append(center)
            
            init_centers_array = np.array(init_centers, dtype=np.float32)
            
            self.kmeans = MiniBatchKMeans(
                n_clusters=self.n_states,
                init=init_centers_array,
                batch_size=32,  # Increased for faster convergence
                max_iter=100,
                random_state=42,
                n_init=1,
                reassignment_ratio=0.01,  # Allow more reassignment for faster adaptation
            )
            
            # Warm-start with the init centers (partial_fit with synthetic data)
            self.kmeans.partial_fit(init_centers_array)
            
            # Initialize cluster stats
            for i in range(self.n_states):
                self.cluster_stats[i] = {
                    'count': 1,
                    'last_seen': time.monotonic(),
                    'mean_activity': float(i) / float(max(1, self.n_states - 1)),
                }
            
            print(f"[CV_STATE] Initialized new MiniBatchKMeans model with {self.n_states} clusters")
    
    def _save_model(self) -> None:
        """Persist the learned model to disk."""
        if not self.use_ml or self.kmeans is None:
            return
        
        try:
            data = {
                'n_states': self.n_states,
                'frame_count': self.frame_count,
                'training_frames': self.training_frames,
                'cluster_centers': self.kmeans.cluster_centers_.tolist(),
                'cluster_stats': {
                    str(k): {
                        'count': int(v['count']),
                        'mean_activity': float(v['mean_activity']),
                    }
                    for k, v in self.cluster_stats.items()
                },
            }
            
            with open(self.model_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2)
            
            print(f"[CV_STATE] Model saved: {self.training_frames} training frames")
        except Exception as e:
            print(f"[CV_STATE] Failed to save model: {e}")
    
    def _load_model(self) -> bool:
        """Load a previously learned model from disk."""
        if not self.use_ml or not self.model_path.exists():
            return False
        
        try:
            with open(self.model_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            if data.get('n_states') != self.n_states:
                print(f"[CV_STATE] Model state count mismatch: {data.get('n_states')} vs {self.n_states}")
                return False
            
            centers = np.array(data['cluster_centers'], dtype=np.float32)
            
            self.kmeans = MiniBatchKMeans(
                n_clusters=self.n_states,
                init=centers,
                batch_size=10,
                max_iter=100,
                random_state=42,
                n_init=1,
            )
            
            # Warm-start
            self.kmeans.partial_fit(centers)
            
            self.frame_count = int(data.get('frame_count', 0))
            self.training_frames = int(data.get('training_frames', 0))
            
            # Load cluster stats
            stats = data.get('cluster_stats', {})
            for k_str, v in stats.items():
                k = int(k_str)
                self.cluster_stats[k] = {
                    'count': int(v.get('count', 1)),
                    'last_seen': time.monotonic(),
                    'mean_activity': float(v.get('mean_activity', 0.5)),
                }
            
            print(f"[CV_STATE] Model loaded: {self.training_frames} training frames")
            return True
        except Exception as e:
            print(f"[CV_STATE] Load model exception: {e}")
            return False
    
    def analyze_frame(
        self,
        detections: List[Dict],
        frame_width: int,
        frame_height: int,
    ) -> Tuple[int, float, Dict]:
        """
        Analyze a frame of CV detections and return (state, activity_level, debug_info).
        
        Args:
            detections: list of detection dicts with 'bbox', 'center', 'area', 'intensity'
            frame_width, frame_height: frame dimensions for normalization
        
        Returns:
            (state: int 1-14, activity_level: float 0-1, debug: dict)
        """
        self.frame_count += 1
        self.frame_w = int(frame_width) if frame_width > 0 else self.frame_w
        self.frame_h = int(frame_height) if frame_height > 0 else self.frame_h
        
        # Extract features
        features = self._extract_features(detections)
        feature_vec = self._features_to_vector(features)
        
        # Update activity level (for OSC mode selection)
        self._update_activity(features)
        
        # Warmup period: train multiple times per frame for faster initial learning
        warmup_frames = 300  # First ~10 seconds at 30fps
        if self.use_ml and self.kmeans is not None and self.frame_count < warmup_frames:
            # Train 3x per frame during warmup for rapid cluster formation
            for _ in range(3):
                self.kmeans.partial_fit(feature_vec)
                self.training_frames += 1
        
        # Assign state
        if self.use_ml and self.kmeans is not None:
            state = self._ml_state_assignment(feature_vec, features)
        else:
            state = self._rule_based_state(features)
        
        # Smooth state transitions (hysteresis)
        state = self._smooth_state(state)
        
        # Periodically save model
        if self.use_ml and self.frame_count % 300 == 0:  # Every ~10 seconds at 30 FPS
            self._save_model()
        
        debug = {
            'blob_count': features['blob_count'],
            'mean_velocity': features['mean_velocity'],
            'spatial_spread': features['spatial_spread'],
            'activity_raw': self.activity_level,
            'activity_smooth': self.activity_smooth,
            'state_raw': state,
            'state_smoothed': self.current_state,
            'training_frames': self.training_frames,
        }
        
        return self.current_state, self.activity_smooth, debug
    
    def _extract_features(self, detections: List[Dict]) -> Dict:
        """Extract normalized feature set from detections."""
        n = len(detections)
        
        if n == 0:
            # Return minimal activity (not pure zero - some baseline presence)
            return {
                'blob_count': 0.0,
                'total_area': 0.0,
                'spatial_spread': 0.0,
                'mean_velocity': 0.0,
                'mean_intensity': 0.0,
                'left_right_balance': 0.5,
                'top_bottom_balance': 0.5,
                'cluster_density': 0.0,
            }
        
        # Raw values
        total_area = sum(d.get('area', 0) for d in detections)
        centers = [d.get('center', (0, 0)) for d in detections]
        intensities = [d.get('intensity', 128) for d in detections]
        
        # Spatial spread (std of positions)
        centers_arr = np.array(centers, dtype=np.float32)
        if len(centers_arr) > 1:
            spread_x = float(np.std(centers_arr[:, 0]))
            spread_y = float(np.std(centers_arr[:, 1]))
            spatial_spread = float(np.sqrt(spread_x**2 + spread_y**2))
        else:
            spatial_spread = 0.0
        
        # Velocity (difference from previous frame)
        velocities = []
        if len(self.prev_centers) == len(centers):
            for (cx, cy), (px, py) in zip(centers, self.prev_centers):
                vx = float(cx - px)
                vy = float(cy - py)
                velocities.append(float(np.sqrt(vx**2 + vy**2)))
        self.prev_centers = centers.copy()
        mean_velocity = float(np.mean(velocities)) if velocities else 0.0
        
        # Left/Right balance
        frame_cx = float(self.frame_w) / 2.0
        left_area = sum(d.get('area', 0) for d in detections if d.get('center', (0, 0))[0] < frame_cx)
        right_area = sum(d.get('area', 0) for d in detections if d.get('center', (0, 0))[0] >= frame_cx)
        total = left_area + right_area
        lr_balance = float(left_area) / float(max(1, total)) if total > 0 else 0.5
        
        # Top/Bottom balance
        frame_cy = float(self.frame_h) / 2.0
        top_area = sum(d.get('area', 0) for d in detections if d.get('center', (0, 0))[1] < frame_cy)
        bottom_area = sum(d.get('area', 0) for d in detections if d.get('center', (0, 0))[1] >= frame_cy)
        total = top_area + bottom_area
        tb_balance = float(top_area) / float(max(1, total)) if total > 0 else 0.5
        
        # Cluster density (inverse of spread, normalized)
        max_spread = float(np.sqrt(self.frame_w**2 + self.frame_h**2))
        density = 1.0 - float(np.clip(spatial_spread / max(1.0, max_spread), 0.0, 1.0))
        
        # Mean intensity
        mean_intensity = float(np.mean(intensities)) if intensities else 128.0
        
        # Normalize
        max_blobs = 15.0  # assume max ~15 detections (tighter range for more sensitivity)
        max_area = float(self.frame_w * self.frame_h * 0.3)  # max 30% coverage (more realistic)
        max_velocity = 30.0  # pixels per frame (more sensitive to motion)
        max_spread = float(np.sqrt(self.frame_w**2 + self.frame_h**2) * 0.5)  # half diagonal
        
        return {
            'blob_count': float(np.clip(n / max_blobs, 0.0, 1.0)),
            'total_area': float(np.clip(total_area / max_area, 0.0, 1.0)),
            'spatial_spread': float(np.clip(spatial_spread / max(1.0, max_spread), 0.0, 1.0)),
            'mean_velocity': float(np.clip(mean_velocity / max_velocity, 0.0, 1.0)),
            'mean_intensity': float(np.clip(mean_intensity / 255.0, 0.0, 1.0)),
            'left_right_balance': float(lr_balance),
            'top_bottom_balance': float(tb_balance),
            'cluster_density': float(density),
        }
    
    def _features_to_vector(self, features: Dict) -> np.ndarray:
        """Convert feature dict to numpy vector for ML."""
        return np.array([
            features['blob_count'],
            features['total_area'],
            features['spatial_spread'],
            features['mean_velocity'],
            features['mean_intensity'],
            features['left_right_balance'],
            features['top_bottom_balance'],
            features['cluster_density'],
        ], dtype=np.float32).reshape(1, -1)
    
    def _ml_state_assignment(self, feature_vec: np.ndarray, features: Dict) -> int:
        """
        Map CV patterns to states (1-14) using multiple features for full range coverage.
        
        Uses a combination of:
        - Cluster ID (from ML): Primary pattern identifier
        - Activity level: Fine-grained modulation
        - Blob count + Velocity: Secondary features for variety
        
        This ensures all 14 states are accessible based on actual CV patterns.
        """
        if self.kmeans is None:
            return 1
        
        # Continue training clusters in background
        cluster_id = int(self.kmeans.predict(feature_vec)[0])
        self.kmeans.partial_fit(feature_vec)
        self.training_frames += 1
        
        # Update cluster stats
        if cluster_id not in self.cluster_stats:
            self.cluster_stats[cluster_id] = {'count': 0, 'last_seen': 0.0, 'mean_activity': 0.5}
        
        self.cluster_stats[cluster_id]['count'] += 1
        self.cluster_stats[cluster_id]['last_seen'] = time.monotonic()
        alpha = 0.3
        old_activity = self.cluster_stats[cluster_id]['mean_activity']
        self.cluster_stats[cluster_id]['mean_activity'] = (
            (1.0 - alpha) * old_activity + alpha * self.activity_level
        )
        
        # ENHANCED MAPPING: Use multiple features to spread across 1-14
        
        # 1. Base state from cluster (map 14 clusters → 1-14 states)
        # Since we have 14 clusters, map them directly
        cluster_state = (cluster_id % self.n_states) + 1
        
        # 2. Activity modulation (expand the range)
        # Map activity 0-1 to a wider multiplier (0.7 to 1.3)
        activity_mult = 0.7 + (self.activity_level * 0.6)
        
        # 3. Add feature-based offset for more variety
        # Use blob_count and velocity to shift within ±3 states
        blob_factor = features.get('blob_count', 0.5)  # 0-1
        velocity_factor = features.get('mean_velocity', 0.0)  # 0-1
        
        # Combine: blob_count biases lower states, velocity biases higher states
        feature_offset = int((velocity_factor - blob_factor * 0.3) * 3.0)  # -1 to +3
        
        # 4. Compute final state
        final_state = int(cluster_state * activity_mult) + feature_offset
        final_state = int(np.clip(final_state, 1, self.n_states))
        
        return final_state
    
    def _rule_based_state(self, features: Dict) -> int:
        """Fallback rule-based state assignment when ML is unavailable."""
        # Simple heuristic: combine blob_count + velocity + area
        activity = (
            features['blob_count'] * 0.4 +
            features['mean_velocity'] * 0.3 +
            features['total_area'] * 0.3
        )
        
        # Map activity (0-1) to state (1-14)
        state = int(np.clip(activity * self.n_states, 0.999, self.n_states - 0.001)) + 1
        return int(np.clip(state, 1, self.n_states))
    
    def _update_activity(self, features: Dict) -> None:
        """Compute and smooth activity level (0-1) for OSC mode selection."""
        # Activity = weighted combination of features (emphasize motion and count)
        raw_activity = (
            features['blob_count'] * 0.35 +       # Increased weight on blob count
            features['mean_velocity'] * 0.45 +    # Increased weight on motion
            features['spatial_spread'] * 0.20     # Less weight on spread
        )
        
        self.activity_level = float(np.clip(raw_activity, 0.0, 1.0))
        
        # Exponential smoothing (prevents rapid mode switching)
        now = time.monotonic()
        dt = float(now - self.activity_last_update)
        self.activity_last_update = now
        
        if dt > 0.0 and dt < 1.0:  # Sanity check
            alpha = 1.0 - np.exp(-dt / max(0.001, self.activity_tau))
            self.activity_smooth = (
                (1.0 - alpha) * self.activity_smooth + alpha * self.activity_level
            )
        else:
            self.activity_smooth = self.activity_level
    
    def _smooth_state(self, new_state: int) -> int:
        """Apply hysteresis to prevent rapid state jumping."""
        # TEMPORARILY DISABLED FOR DEBUGGING - return new state immediately
        self.current_state = new_state
        self.state_dwell_frames = 0
        return self.current_state
        
        # Original smoothing logic (commented out for debugging)
        # if new_state == self.current_state:
        #     self.state_dwell_frames += 1
        #     return self.current_state
        # 
        # # State wants to change
        # if self.state_dwell_frames < self.min_dwell_frames:
        #     # Haven't dwelled long enough, stay in current
        #     return self.current_state
        # 
        # # Allow change
        # self.current_state = new_state
        # self.state_dwell_frames = 0
        # self.state_history.append(new_state)
        # if len(self.state_history) > 100:
        #     self.state_history.pop(0)
        # 
        # return self.current_state
    
    def get_state_stats(self) -> Dict:
        """Return diagnostics about learned states."""
        if not self.use_ml or not self.cluster_stats:
            return {}
        
        return {
            'total_frames': self.frame_count,
            'training_frames': self.training_frames,
            'clusters': {
                cid: {
                    'count': stats['count'],
                    'mean_activity': round(stats['mean_activity'], 3),
                }
                for cid, stats in self.cluster_stats.items()
            },
            'state_history': self.state_history[-20:],  # Last 20 states
        }
    
    def shutdown(self) -> None:
        """Save model on shutdown."""
        if self.use_ml:
            self._save_model()
            print("[CV_STATE] Shutdown: model saved")
