#!/bin/bash
set -e
IMOL_LIGHT_ROOT="$(cd "$(dirname "$0")" && pwd)"
exec python3 "$IMOL_LIGHT_ROOT/tools/launch.py" "$@"
