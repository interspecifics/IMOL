"""
Light Geometry Analyzer for IMOL
---------------------------------

Advanced CV pipeline for extracting geometric features from light patterns
created by prisms, mirrors, and moving heads.

Pipeline:
1. Preprocessing: isolate "light ink" from background
2. Geometry extraction: lines, curves, symmetry, topology
3. Temporal tracking: optical flow, stability metrics
"""

import cv2
import numpy as np
from collections import deque
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
import math


@dataclass
class GeometricFeatures:
    """Container for extracted geometric features from one frame."""
    
    # Lines/rays
    lines: List[Tuple[float, float, float, float]] = None  # (x1, y1, x2, y2)
    line_angles: List[float] = None
    
    # Curves/contours
    contours: List[np.ndarray] = None
    contour_areas: List[float] = None
    contour_perimeters: List[float] = None
    
    # Topology (graph from skeleton)
    num_nodes: int = 0
    num_branches: int = 0
    longest_path: float = 0.0
    
    # Symmetry
    dominant_angle: float = 0.0
    symmetry_score: float = 0.0
    
    # Overall metrics
    total_light_area: float = 0.0
    centroid: Tuple[float, float] = (0.0, 0.0)
    
    # Motion/stability
    motion_magnitude: float = 0.0
    stability_score: float = 1.0
    
    def __post_init__(self):
        if self.lines is None:
            self.lines = []
        if self.line_angles is None:
            self.line_angles = []
        if self.contours is None:
            self.contours = []
        if self.contour_areas is None:
            self.contour_areas = []
        if self.contour_perimeters is None:
            self.contour_perimeters = []


class LightGeometryAnalyzer:
    """
    Advanced analyzer for extracting geometric signatures from light patterns.
    """
    
    def __init__(self, history_size: int = 30):
        self.history_size = history_size
        self.feature_history = deque(maxlen=history_size)
        
        # Background subtractor
        self.bg_subtractor = cv2.createBackgroundSubtractorMOG2(
            history=500, varThreshold=16, detectShadows=False
        )
        
        # For optical flow
        self.prev_gray = None
        self.flow_history = deque(maxlen=10)
        
        # Morphological kernels
        self.kernel_small = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
        self.kernel_medium = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))
    
    def preprocess_light_mask(self, frame: np.ndarray, use_bg_subtract: bool = True) -> np.ndarray:
        """
        Step 1: Isolate 'light ink' from background.
        
        Returns binary mask of where light exists.
        """
        # Convert to HSV for better light isolation
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
        h, s, v = cv2.split(hsv)
        
        # Strategy 1: Brightness + optional saturation gating
        # High brightness = light
        bright_mask = cv2.threshold(v, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
        
        # Optional: gate by saturation to catch colored light (prism refractions)
        saturated_mask = cv2.threshold(s, 40, 255, cv2.THRESH_BINARY)[1]
        
        # Combine: bright OR saturated (catches white beams + colored refractions)
        mask = cv2.bitwise_or(bright_mask, saturated_mask)
        
        # Strategy 2: Background subtraction (if camera is fixed)
        if use_bg_subtract:
            fg_mask = self.bg_subtractor.apply(frame, learningRate=0.001)
            fg_mask = cv2.threshold(fg_mask, 127, 255, cv2.THRESH_BINARY)[1]
            
            # Combine with brightness mask
            mask = cv2.bitwise_and(mask, fg_mask)
        
        # Morphology: clean up noise
        # Open: remove small noise
        mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, self.kernel_small, iterations=1)
        
        # Close: connect nearby light regions
        mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, self.kernel_medium, iterations=2)
        
        return mask
    
    def extract_lines_rays(self, mask: np.ndarray) -> Tuple[List, List[float]]:
        """
        Extract line segments and their orientations (for beam aesthetics).
        
        Returns: (lines, angles)
        """
        # Edge detection
        edges = cv2.Canny(mask, 50, 150)
        
        # Probabilistic Hough Line Transform
        lines = cv2.HoughLinesP(
            edges,
            rho=1,
            theta=np.pi/180,
            threshold=30,
            minLineLength=20,
            maxLineGap=10
        )
        
        line_segments = []
        angles = []
        
        if lines is not None:
            for line in lines:
                x1, y1, x2, y2 = line[0]
                line_segments.append((x1, y1, x2, y2))
                
                # Calculate angle
                angle = math.atan2(y2 - y1, x2 - x1) * 180 / math.pi
                angles.append(angle)
        
        return line_segments, angles
    
    def extract_curves_caustics(self, mask: np.ndarray) -> Tuple[List, List[float], List[float]]:
        """
        Extract contours (for refraction caustics, curved boundaries).
        
        Returns: (contours, areas, perimeters)
        """
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        areas = []
        perimeters = []
        significant_contours = []
        
        for cnt in contours:
            area = cv2.contourArea(cnt)
            if area < 50:  # Filter tiny noise
                continue
            
            perimeter = cv2.arcLength(cnt, True)
            
            significant_contours.append(cnt)
            areas.append(area)
            perimeters.append(perimeter)
        
        return significant_contours, areas, perimeters
    
    def extract_skeleton_topology(self, mask: np.ndarray) -> Dict:
        """
        Extract graph-like topology from skeletonized mask.
        Great for understanding pattern structure (nodes, branches, connectivity).
        
        Returns: dict with topology metrics
        """
        # Skeletonize to 1-pixel centerlines
        skeleton = cv2.ximgproc.thinning(mask)
        
        # Find junction points (nodes with degree > 2)
        # Use a 3x3 kernel to count neighbors
        kernel = np.ones((3, 3), np.uint8)
        neighbor_count = cv2.filter2D(skeleton // 255, -1, kernel) * (skeleton // 255)
        
        # Nodes = pixels with 3+ neighbors (junctions)
        nodes = np.sum(neighbor_count >= 3)
        
        # Branches ≈ connected components after removing nodes
        # Simple approximation: count contours in skeleton
        contours, _ = cv2.findContours(skeleton, cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        branches = len(contours)
        
        # Longest path: find longest contour
        longest_path = 0.0
        if contours:
            longest_path = max(cv2.arcLength(cnt, False) for cnt in contours)
        
        return {
            'num_nodes': int(nodes),
            'num_branches': branches,
            'longest_path': longest_path,
            'skeleton': skeleton
        }
    
    def compute_symmetry(self, mask: np.ndarray, angles: List[float]) -> Tuple[float, float]:
        """
        Compute angular distribution and symmetry score.
        
        Returns: (dominant_angle, symmetry_score)
        """
        if not angles:
            return 0.0, 0.0
        
        # Dominant angle from histogram of orientations
        hist, bin_edges = np.histogram(angles, bins=36, range=(-180, 180))
        dominant_bin = np.argmax(hist)
        dominant_angle = (bin_edges[dominant_bin] + bin_edges[dominant_bin + 1]) / 2
        
        # Symmetry score: test rotational symmetry by correlating rotated masks
        # Simple version: check if dominant angle has a complement (e.g., 45° and 135°)
        complementary_angle = (dominant_angle + 90) % 180
        
        # Find histogram values near complementary angles
        symmetry_score = 0.0
        for i, edge in enumerate(bin_edges[:-1]):
            if abs(edge - complementary_angle) < 10 or abs(edge - (complementary_angle + 180)) < 10:
                symmetry_score = hist[i] / (hist[dominant_bin] + 1e-6)
                break
        
        return dominant_angle, min(symmetry_score, 1.0)
    
    def compute_optical_flow(self, gray: np.ndarray) -> float:
        """
        Compute optical flow to measure motion/dynamics.
        
        Returns: average motion magnitude
        """
        if self.prev_gray is None:
            self.prev_gray = gray.copy()
            return 0.0
        
        # Farnebäck optical flow
        flow = cv2.calcOpticalFlowFarneback(
            self.prev_gray, gray,
            None, 0.5, 3, 15, 3, 5, 1.2, 0
        )
        
        # Compute magnitude
        mag, _ = cv2.cartToPolar(flow[..., 0], flow[..., 1])
        motion_magnitude = float(np.mean(mag))
        
        self.flow_history.append(motion_magnitude)
        self.prev_gray = gray.copy()
        
        return motion_magnitude
    
    def analyze_frame(self, frame: np.ndarray, use_bg_subtract: bool = True) -> GeometricFeatures:
        """
        Full pipeline: analyze one frame and extract all geometric features.
        """
        features = GeometricFeatures()
        
        # Step 1: Preprocessing - get light mask
        mask = self.preprocess_light_mask(frame, use_bg_subtract)
        
        # Overall metrics
        features.total_light_area = float(np.sum(mask > 0))
        
        if features.total_light_area > 100:  # Only analyze if significant light present
            # Centroid
            moments = cv2.moments(mask)
            if moments['m00'] > 0:
                cx = moments['m10'] / moments['m00']
                cy = moments['m01'] / moments['m00']
                features.centroid = (cx, cy)
            
            # Step 2A: Extract lines/rays
            features.lines, features.line_angles = self.extract_lines_rays(mask)
            
            # Step 2B: Extract curves/caustics
            features.contours, features.contour_areas, features.contour_perimeters = \
                self.extract_curves_caustics(mask)
            
            # Step 2C: Extract topology
            try:
                topology = self.extract_skeleton_topology(mask)
                features.num_nodes = topology['num_nodes']
                features.num_branches = topology['num_branches']
                features.longest_path = topology['longest_path']
            except:
                pass  # Skeletonization can fail on some masks
            
            # Step 2D: Symmetry analysis
            if features.line_angles:
                features.dominant_angle, features.symmetry_score = \
                    self.compute_symmetry(mask, features.line_angles)
        
        # Step 3: Temporal tracking (optical flow)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        features.motion_magnitude = self.compute_optical_flow(gray)
        
        # Stability score: inverse of motion variance over time
        if len(self.flow_history) > 5:
            motion_variance = float(np.var(list(self.flow_history)))
            features.stability_score = 1.0 / (1.0 + motion_variance)
        
        # Add to history
        self.feature_history.append(features)
        
        return features
    
    def get_temporal_state(self) -> str:
        """
        Classify temporal behavior based on recent history.
        """
        if len(self.feature_history) < 5:
            return "initializing"
        
        recent = list(self.feature_history)[-10:]
        
        avg_motion = np.mean([f.motion_magnitude for f in recent])
        avg_stability = np.mean([f.stability_score for f in recent])
        
        # Topology changes
        topology_changes = 0
        for i in range(1, len(recent)):
            if abs(recent[i].num_branches - recent[i-1].num_branches) > 1:
                topology_changes += 1
        
        if avg_motion < 0.5 and avg_stability > 0.8:
            return "stable"
        elif topology_changes > 3:
            return "morphing"
        elif avg_motion > 2.0:
            return "turbulent"
        elif avg_motion > 0.5:
            return "flowing"
        else:
            return "calm"
    
    def create_debug_visualization(self, frame: np.ndarray, mask: np.ndarray, 
                                   features: GeometricFeatures) -> np.ndarray:
        """
        Create annotated visualization showing extracted geometry.
        """
        vis = frame.copy()
        
        # Draw mask overlay (semi-transparent)
        mask_colored = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)
        mask_colored[:, :, 0] = 0  # Remove blue channel
        vis = cv2.addWeighted(vis, 0.7, mask_colored, 0.3, 0)
        
        # Draw lines in cyan
        for line in features.lines:
            x1, y1, x2, y2 = [int(v) for v in line]
            cv2.line(vis, (x1, y1), (x2, y2), (255, 255, 0), 2)
        
        # Draw contours in yellow
        if features.contours:
            cv2.drawContours(vis, features.contours, -1, (0, 255, 255), 2)
        
        # Draw centroid
        if features.centroid != (0.0, 0.0):
            cx, cy = [int(v) for v in features.centroid]
            cv2.circle(vis, (cx, cy), 8, (0, 0, 255), -1)
            cv2.circle(vis, (cx, cy), 10, (255, 255, 255), 2)
        
        # Add text info
        info_y = 30
        cv2.rectangle(vis, (5, 5), (300, 180), (0, 0, 0), -1)
        
        cv2.putText(vis, f"Lines: {len(features.lines)}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Contours: {len(features.contours)}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Nodes: {features.num_nodes}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Branches: {features.num_branches}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Angle: {features.dominant_angle:.1f}°", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Symmetry: {features.symmetry_score:.2f}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Motion: {features.motion_magnitude:.2f}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        info_y += 20
        
        cv2.putText(vis, f"Stability: {features.stability_score:.2f}", (10, info_y),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
        
        return vis

