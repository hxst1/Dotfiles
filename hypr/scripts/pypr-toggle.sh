#!/usr/bin/env bash
# Toggle del scratchpad de pyprland, auto-reparador:
# si el daemon se cayó (socket huérfano), lo limpia y lo relanza antes de abrir.
scratch="${1:-term}"

if ! pypr reload >/dev/null 2>&1; then
    sig="${HYPRLAND_INSTANCE_SIGNATURE:-$(ls /run/user/$(id -u)/hypr/ 2>/dev/null | head -1)}"
    rm -f "/run/user/$(id -u)/hypr/$sig/.pyprland.sock"
    pypr >/dev/null 2>&1 &
    sleep 1
fi

pypr toggle "$scratch"
