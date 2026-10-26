#!/usr/bin/env bash
# Workspaces paginados para waybar: página 1 = escritorios 1-5, página 2 = 6-10.
# Punto lleno blanco = activo · punto gris = con ventanas · punto tenue = vacío.
# El chevron se ilumina si hay ventanas en la otra página.
# Uso: sin args = stream JSON para waybar · toggle = saltar de página · next/prev = ciclar

ACTIVE=$'\U000f0765'   # nf-md-circle
OCC=$'\U000f09de'      # nf-md-circle-medium
EMPTY=$'\U000f09df'    # nf-md-circle-small
NEXT=$'\U000f0142'     # nf-md-chevron-right
PREV=$'\U000f0141'     # nf-md-chevron-left

# Paleta Niebla
C_ACTIVE="#f4f5f6"     # blanco — activo
C_OCC="#8a8f93"        # niebla — ocupado
C_EMPTY="#5b5e60"      # apagado — vacío
C_HINT="#c8ccd0"       # plata — hay ventanas en la otra página

cur_ws() { hyprctl -j activeworkspace | jq '.id'; }

case "$1" in
    toggle)
        cur=$(cur_ws)
        if (( cur > 5 )); then hyprctl dispatch workspace $(( cur - 5 ))
        else hyprctl dispatch workspace $(( cur + 5 )); fi
        exit ;;
    next)
        hyprctl dispatch workspace $(( $(cur_ws) % 10 + 1 )); exit ;;
    prev)
        hyprctl dispatch workspace $(( ($(cur_ws) + 8) % 10 + 1 )); exit ;;
esac

print_state() {
    local cur ids start i icon color out="" chevron
    cur=$(cur_ws) || return
    # workspaces existentes = con ventanas (no hay persistencia en Hyprland)
    ids=" $(hyprctl -j workspaces | jq -r '[.[].id] | join(" ")') "

    if (( cur >= 6 && cur <= 10 )); then start=6; else start=1; fi

    # ¿Hay ventanas en la otra página? → chevron iluminado
    chevron=$C_EMPTY
    local lo hi
    if (( start == 1 )); then lo=6 hi=10; else lo=1 hi=5; fi
    for (( i = lo; i <= hi; i++ )); do
        [[ $ids == *" $i "* ]] && chevron=$C_HINT && break
    done

    if (( start == 6 )); then
        out+="<span foreground='$chevron'>$PREV</span> "
    fi
    for (( i = start; i < start + 5; i++ )); do
        if (( i == cur )); then icon=$ACTIVE; color=$C_ACTIVE
        elif [[ $ids == *" $i "* ]]; then icon=$OCC; color=$C_OCC
        else icon=$EMPTY; color=$C_EMPTY; fi
        out+="<span foreground='$color'>$icon</span> "
    done
    if (( start == 1 )); then
        out+="<span foreground='$chevron'>$NEXT</span>"
    fi

    printf '{"text":"%s","tooltip":"Página %s · Escritorio %s\\nclic: cambiar de página · rueda: ciclar"}\n' \
        "${out% }" "$(( start == 1 ? 1 : 2 ))" "$cur"
}

print_state
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - |
while read -r line; do
    case $line in
        workspace*|createworkspace*|destroyworkspace*|openwindow*|closewindow*|movewindow*|focusedmon*)
            print_state ;;
    esac
done
