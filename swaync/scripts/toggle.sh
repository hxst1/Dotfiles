#!/usr/bin/env bash
# Interruptores del Centro de control (swaync buttons-grid).
# Uso: toggle.sh <bt|mic|gaming> [get]
#   get  -> imprime true/false (update-command)
#   sin get -> aplica $SWAYNC_TOGGLE_STATE (command)
what=$1; mode=${2:-set}
gaming_state="${XDG_RUNTIME_DIR:-/tmp}/gaming-mode.state"

case "$what:$mode" in
    bt:get)     bluetoothctl show | grep -q "Powered: yes" && echo true || echo false ;;
    bt:set)     [[ $SWAYNC_TOGGLE_STATE == true ]] && bluetoothctl power on >/dev/null || bluetoothctl power off >/dev/null ;;
    mic:get)    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo true || echo false ;;
    mic:set)    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    gaming:get) [[ -f $gaming_state ]] && echo true || echo false ;;
    gaming:set) swaync-client -cp >/dev/null; "$HOME/.config/hypr/scripts/gaming-mode.sh" ;;
esac
