#!/usr/bin/env bash
# Abre el mini-monitor en una ventana flotante y centrada (lo usa el clic en runcat).
# Si ya está abierto, lo cierra (toggle).
if pkill -f "hypr/scripts/sysmenu.sh"; then exit 0; fi

kitty --class sysmenu-flotante -e "$HOME/.config/hypr/scripts/sysmenu.sh" &
sleep 0.3
hyprctl dispatch togglefloating active     >/dev/null 2>&1 || true
hyprctl dispatch resizeactive exact 560 420 >/dev/null 2>&1 || true
hyprctl dispatch centerwindow               >/dev/null 2>&1 || true
