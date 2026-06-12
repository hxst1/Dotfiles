#!/usr/bin/env bash
# Notas rápidas: abre una ventana flotante y centrada con el fichero de notas.
# Escribe -> Ctrl+O para guardar -> Ctrl+X para salir.
set -euo pipefail

NOTES_DIR="$HOME/notas"
NOTES="$NOTES_DIR/notas.md"

mkdir -p "$NOTES_DIR"
[ -f "$NOTES" ] || printf '# Notas rápidas\n\n' > "$NOTES"

# Lanza kitty con nano al final del fichero, listo para escribir.
kitty --class notas-flotante -e nano +99999 "$NOTES" &

# Espera a que la ventana se mapee y la flota/redimensiona/centra
# (sin window rules: 0.55 las migró a Lua y aquí no hacen falta).
sleep 0.3
hyprctl dispatch togglefloating active        >/dev/null 2>&1 || true
hyprctl dispatch resizeactive exact 820 560    >/dev/null 2>&1 || true
hyprctl dispatch centerwindow                  >/dev/null 2>&1 || true
