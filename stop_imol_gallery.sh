#!/bin/bash
#
# IMOL Gallery Stop Script
# =========================
# Cleanly stops all IMOL components
#
# Usage:
#   ./stop_imol_gallery.sh
#

set -e

log() {
    echo "[$(date +'%H:%M:%S')] $1"
}

log "=========================================="
log "Stopping IMOL Gallery Components"
log "=========================================="

# Stop Python applications
log "Stopping Python applications..."

# Pattern matches both IMOL_CV_GRAPHIC_SCORE_QT.py and IMOL_CV_GRAPHIC_SCORE_QT_V2.py
SCORE_PIDS=$(pgrep -f "IMOL_CV_GRAPHIC_SCORE_QT")
CONTROLLER_PIDS=$(pgrep -f "IMOL_PATTERN_CONTROLLER_QT")

if [ -n "$SCORE_PIDS" ]; then
    log "  Stopping Score app (PIDs: $SCORE_PIDS)"
    echo "$SCORE_PIDS" | xargs kill 2>/dev/null || true
    sleep 1
else
    log "  Score app not running"
fi

if [ -n "$CONTROLLER_PIDS" ]; then
    log "  Stopping Controller (PIDs: $CONTROLLER_PIDS)"
    echo "$CONTROLLER_PIDS" | xargs kill 2>/dev/null || true
    sleep 1
else
    log "  Controller not running"
fi

# Check if processes are still alive (force kill if needed)
SCORE_PIDS=$(pgrep -f "IMOL_CV_GRAPHIC_SCORE_QT")
CONTROLLER_PIDS=$(pgrep -f "IMOL_PATTERN_CONTROLLER_QT")

if [ -n "$SCORE_PIDS" ]; then
    log "  Force stopping Score app..."
    echo "$SCORE_PIDS" | xargs kill -9 2>/dev/null || true
fi

if [ -n "$CONTROLLER_PIDS" ]; then
    log "  Force stopping Controller..."
    echo "$CONTROLLER_PIDS" | xargs kill -9 2>/dev/null || true
fi

# Note about Max patches
log ""
log "Note: Max patches must be closed manually"
log "  (Or use: osascript -e 'quit app \"Max\"')"

# Optional: Stop OLA daemon (uncomment if you want to stop DMX too)
# log ""
# log "Stopping OLA daemon..."
# if pgrep -x "olad" > /dev/null; then
#     killall olad
#     log "  OLA daemon stopped"
# else
#     log "  OLA daemon not running"
# fi

log ""
log "=========================================="
log "IMOL components stopped"
log "=========================================="
