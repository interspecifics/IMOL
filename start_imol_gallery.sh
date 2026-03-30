#!/bin/bash
#
# IMOL Gallery Auto-Start Script
# ================================
# Launches all IMOL components for gallery installation:
# - Score app (projector, fullscreen)
# - Light controller (laptop screen)
# - Max patches (3 files)
#
# Usage:
#   ./start_imol_gallery.sh
#
# For auto-start on boot:
#   System Preferences → Users & Groups → Login Items → Add this script
#

set -e  # Exit on error

# ============================================================================
# CONFIGURATION
# ============================================================================

# Project paths
IMOL_DIR="/Users/microhm/Desktop/01_Proyectos/IMOL"
PYTHON_ENGINE="$IMOL_DIR/python-light-engine"
MAX_DIR="$IMOL_DIR/max_resynth"

# Python virtual environment
VENV="$IMOL_DIR/imol-venv"

# Max application path (adjust if Max is installed elsewhere)
MAX_APP="/Applications/Max.app/Contents/MacOS/Max"

# Log directory
LOG_DIR="$IMOL_DIR/logs"
mkdir -p "$LOG_DIR"

# Timestamp for log files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log() {
    echo "[$(date +'%H:%M:%S')] $1"
}

wait_for_process() {
    local name="$1"
    local max_wait="$2"
    local waited=0
    
    log "Waiting for $name to initialize..."
    while [ $waited -lt $max_wait ]; do
        sleep 1
        waited=$((waited + 1))
    done
}

# ============================================================================
# PRE-FLIGHT CHECKS
# ============================================================================

log "=========================================="
log "IMOL Gallery Auto-Start"
log "=========================================="

# Check if we're in the right directory
if [ ! -d "$IMOL_DIR" ]; then
    log "ERROR: IMOL directory not found: $IMOL_DIR"
    exit 1
fi

cd "$IMOL_DIR"
log "Working directory: $(pwd)"

# ============================================================================
# 1. START OLA DAEMON (DMX control)
# ============================================================================

log "Starting OLA daemon..."

# Check if olad is already running
if pgrep -x "olad" > /dev/null; then
    log "OLA daemon already running"
else
    olad -l 3 > "$LOG_DIR/olad_${TIMESTAMP}.log" 2>&1 &
    wait_for_process "OLA" 2
    log "OLA daemon started"
fi

# ============================================================================
# 2. WAIT FOR CAMERAS TO INITIALIZE
# ============================================================================

log "Waiting for camera devices to initialize..."
sleep 3

# ============================================================================
# 3. START PYTHON APPLICATIONS
# ============================================================================

# Activate virtual environment
if [ -d "$VENV" ]; then
    log "Activating Python virtual environment..."
    source "$VENV/bin/activate"
else
    log "ERROR: Virtual environment not found: $VENV"
    exit 1
fi

cd "$PYTHON_ENGINE"

# 3a. Score App → EPSON PJ Projector (Display 1, fullscreen, hidden cursor)
log "Starting Score app (EPSON PJ projector, Display 1)..."
python3 IMOL_CV_GRAPHIC_SCORE_QT_V2.py \
    --display 1 \
    --hide-cursor \
    --audio-folder "$IMOL_DIR/audio/archives" \
    > "$LOG_DIR/score_${TIMESTAMP}.log" 2>&1 &
SCORE_PID=$!
log "Score app started (PID: $SCORE_PID)"

# Wait a moment for the score to initialize
sleep 2

# 3b. Light Controller → Mac mini screen (Display 0, windowed)
log "Starting Light Controller (23MB35 screen, Display 0)..."
python3 IMOL_PATTERN_CONTROLLER_QT.py \
    --display 0 \
    --fog-autostart \
    > "$LOG_DIR/controller_${TIMESTAMP}.log" 2>&1 &
CONTROLLER_PID=$!
log "Light Controller started (PID: $CONTROLLER_PID)"

# ============================================================================
# 4. START MAX PATCHES
# ============================================================================

cd "$MAX_DIR"

# Max patch files here:
MAX_PATCHES=(
    "SpectralSynthesis.maxpat"
    "Sampler_md.maxpat"
    "granulStrig.maxpat"
)

log "Starting Max patches..."

for patch in "${MAX_PATCHES[@]}"; do
    if [ -f "$patch" ]; then
        log "  Opening: $patch"
        open -a "$MAX_APP" "$patch"
        sleep 1  # Stagger launches to avoid overwhelm
    else
        log "  WARNING: Patch not found: $patch"
    fi
done

# ============================================================================
# DONE
# ============================================================================

log "=========================================="
log "All IMOL components launched!"
log "=========================================="
log ""
log "Running processes:"
log "  - Score app (PID: $SCORE_PID) → Projector"
log "  - Controller (PID: $CONTROLLER_PID) → Laptop screen"
log "  - Max patches: ${#MAX_PATCHES[@]} opened"
log ""
log "Logs saved to: $LOG_DIR"
log ""
log "To stop all processes:"
log "  kill $SCORE_PID $CONTROLLER_PID"
log "  (then close Max patches manually)"
log ""

# Optional: Keep this terminal open to see status
# Uncomment if you want the terminal to stay visible:
# log "Press Ctrl+C to view this status, or close this window."
# wait

# Optional: Exit immediately (for background Launch Agent mode)
# Uncomment for silent background launch:
# exit 0
