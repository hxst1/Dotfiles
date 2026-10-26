#!/usr/bin/env bash
# Modo presencia para waybar: mantiene Slack/Teams/etc. en "activo".
# Esas apps te ponen ausente cuando el sistema lleva un rato sin teclado ni ratón
# (Slack: 30 min). Activado, cada 4 min mueve el ratón 1 px y lo devuelve con
# ydotool (eventos de entrada reales vía uinput): imperceptible, pero cuenta como
# actividad. Además, mientras está activo se detiene hypridle: ni bloqueo
# automático ni apagado de pantalla (SUPER+L sigue bloqueando a mano).
#
# Uso: presencia.sh            → estado JSON para waybar
#      presencia.sh toggle     → activar/desactivar
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/presencia.pid"
EVERY=240   # segundos entre "movimientos"

ON=$'\U000f0176'    # nf-md-coffee
OFF=$'\U000f06ca'   # nf-md-coffee_outline

running() { [[ -f $PIDFILE ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; }

case "$1" in
    toggle)
        if running; then
            kill "$(cat "$PIDFILE")" 2>/dev/null; rm -f "$PIDFILE"
            pgrep -x hypridle >/dev/null || setsid hypridle >/dev/null 2>&1 &   # vuelven bloqueo y apagado
            notify-send -a "Presencia" -i user-away "Modo presencia desactivado" "Vuelven el bloqueo y el apagado de pantalla automáticos."
        else
            if ! command -v ydotool >/dev/null || ! systemctl --user is-active -q ydotool; then
                notify-send -a "Presencia" -u critical "No se puede activar" "Falta ydotool o su servicio (systemctl --user start ydotool)."
                exit 1
            fi
            # Un microevento real (cuenta como actividad) y el cursor vuelve a su
            # posición exacta: la aceleración del puntero haría que 1 px no fuese 1 px.
            setsid bash -c "while :; do pos=\$(hyprctl cursorpos); ydotool mousemove -x 1 -y 0 >/dev/null 2>&1; sleep 0.05; hyprctl dispatch movecursor \${pos/,/} >/dev/null; sleep $EVERY; done" >/dev/null 2>&1 &
            echo $! > "$PIDFILE"
            pkill -x hypridle   # sin bloqueo ni apagado de pantalla mientras dure
            notify-send -a "Presencia" -i user-available "Modo presencia activado" "Siempre activo en Slack · sin bloqueo ni apagado de pantalla."
        fi
        pkill -RTMIN+9 waybar   # refresca el icono al momento
        ;;
    *)
        if running; then
            printf '{"text":"%s","class":"on","tooltip":"Presencia: siempre activo, sin bloqueo ni apagado de pantalla\\nclic: desactivar"}\n' "$ON"
        else
            printf '{"text":"%s","class":"off","tooltip":"Presencia: normal\\nclic: mantenerme siempre activo"}\n' "$OFF"
        fi
        ;;
esac
