#!/usr/bin/env bash
set -euo pipefail
IMOL_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec /usr/bin/python3 "$IMOL_ROOT/tools/autostart_ubuntu.py" "$@"
