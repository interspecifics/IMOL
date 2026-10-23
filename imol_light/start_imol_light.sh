#!/usr/bin/env bash
set -euo pipefail
IMOL_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$IMOL_ROOT"
if [[ "${EUID}" -eq 0 ]]; then
  echo 'Iniciar IMOL con el usuario del escritorio, sin sudo.' >&2
  exit 1
fi
if [[ ! -x "$IMOL_ROOT/.venv/bin/python" ]]; then
  echo 'Primero ejecutar: bash install_ubuntu.sh' >&2
  exit 1
fi
mkdir -p runtime
# Checking imports and files does not require an audio service or desktop.
for imol_arg in "$@"; do
  if [[ "$imol_arg" == --check || "$imol_arg" == --help || "$imol_arg" == -h ]]; then
    exec "$IMOL_ROOT/.venv/bin/python" "$IMOL_ROOT/tools/launch.py" "$@"
  fi
done
if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
  echo 'Abrir una terminal dentro de la sesión gráfica de Ubuntu.' >&2
  exit 1
fi
imol_backend="${IMOL_AUDIO_BACKEND:-}"
if [[ -z "$imol_backend" && -f runtime/ubuntu_audio_mode ]]; then
  read -r imol_backend < runtime/ubuntu_audio_mode
fi
case "${imol_backend:-pipewire}" in
  pipewire)
    if ! command -v pw-jack >/dev/null 2>&1; then
      echo 'Falta pw-jack. Volver a ejecutar: bash install_ubuntu.sh' >&2
      exit 1
    fi
    exec pw-jack "$IMOL_ROOT/.venv/bin/python" "$IMOL_ROOT/tools/launch.py" --display 0 "$@"
    ;;
  jack)
    exec "$IMOL_ROOT/.venv/bin/python" "$IMOL_ROOT/tools/launch.py" --display 0 "$@"
    ;;
  *) echo 'IMOL_AUDIO_BACKEND debe ser pipewire o jack.' >&2; exit 1 ;;
esac
