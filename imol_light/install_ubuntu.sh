#!/usr/bin/env bash
# Run as the desktop user. Only apt operations request sudo.
set -euo pipefail
IMOL_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -x /usr/bin/python3 ]]; then
  echo 'Falta Python del sistema. Instalar con: sudo apt install python3' >&2
  exit 1
fi
exec /usr/bin/python3 "$IMOL_ROOT/tools/install_ubuntu.py" "$@"
