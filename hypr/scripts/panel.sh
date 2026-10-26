#!/usr/bin/env bash
# Paneles flotantes de cristal (tema Niebla) lanzados desde waybar / swaync.
# Toggle: si el panel ya está abierto, lo cierra.
# Las clases float-* flotan, se centran y se dimensionan vía windowrule en hyprland.conf.
# Uso: panel.sh bluetooth | audio | docker | updates

open_tui() {  # $1 = clase, resto = comando
    local class=$1; shift
    local addr
    addr=$(hyprctl -j clients | jq -r --arg c "$class" '.[] | select(.class == $c) | .address' | head -1)
    if [[ -n $addr ]]; then
        hyprctl dispatch closewindow "address:$addr" >/dev/null
        exit 0
    fi
    swaync-client -cp >/dev/null 2>&1   # cierra el centro de control si estaba abierto
    setsid kitty --class "$class" -o background_opacity=0.62 "$@" >/dev/null 2>&1 &
}

case "$1" in
    bluetooth)
        if command -v bluetui >/dev/null; then open_tui float-bluetooth bluetui
        else swaync-client -cp >/dev/null 2>&1; setsid blueman-manager >/dev/null 2>&1 & fi ;;
    audio)
        if command -v wiremix >/dev/null; then open_tui float-audio wiremix
        else swaync-client -cp >/dev/null 2>&1; setsid pavucontrol >/dev/null 2>&1 & fi ;;
    docker)
        if command -v lazydocker >/dev/null; then open_tui float-docker lazydocker
        else open_tui float-docker sh -c 'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"; read -n1 -rp "Pulsa una tecla para cerrar…"'; fi ;;
    updates)
        open_tui float-updates sh -c 'yay -Syu; read -n1 -rp "Pulsa una tecla para cerrar…"' ;;
    *)
        echo "uso: $0 bluetooth|audio|docker|updates" >&2; exit 1 ;;
esac
