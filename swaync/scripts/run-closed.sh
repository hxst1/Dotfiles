#!/usr/bin/env bash
# Cierra el Centro de control y después lanza la acción (para que no salga en la captura/cuentagotas).
swaync-client -cp >/dev/null
sleep 0.35
case "$1" in
    grim-region) grim -g "$(slurp)" - | swappy -f - ;;
    picker)      hyprpicker -a ;;
    lock)        hyprlock ;;
esac
