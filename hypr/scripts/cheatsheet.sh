#!/usr/bin/env bash
# Guía de atajos — estética lila a juego con los bordes de Hyprland.
# Se abre en una ventana flotante de kitty (ver ~/.local/bin/teclas).
# Scroll: ↑/↓ o j/k, PgUp/PgDn o espacio, g/G inicio/fin, q para salir.

# Paleta (24-bit) tomada del gradiente de bordes: c9a8d4 / b388c4
R=$'\033[0m'; B=$'\033[1m'
L1=$'\033[38;2;201;168;212m'   # lila claro
L2=$'\033[38;2;179;136;196m'   # púrpura
DIM=$'\033[38;2;125;115;135m'  # apagado
TXT=$'\033[38;2;223;218;230m'  # texto

sec() { printf "\n   ${L2}${B}%b  %s${R}\n" "$1" "$2"; }
# Pad por nº de caracteres (${#key}), no por bytes: así las flechas ←↑↓→ alinean.
row() {
    local key="$1" pad=$(( 22 - ${#1} ))
    (( pad < 1 )) && pad=1
    printf "     ${L1}%s${R}%*s${TXT}%s${R}\n" "$key" "$pad" "" "$2"
}

render() {
printf "\n   ${L2}╭────────────────────────────────────────────────────────────╮${R}\n"
printf "   ${L2}│${R}   ${L1}${B}  Arch + Hyprland${R}  ${DIM}·${R}  ${TXT}Guía de atajos${R}                     ${L2}│${R}\n"
printf "   ${L2}╰────────────────────────────────────────────────────────────╯${R}\n"

sec "" "HYPRLAND · Ventanas & sesión"
row "SUPER + Q"            "Abrir terminal (kitty)"
row "SUPER + T"            "Terminal desplegable (Quake)"
row "SUPER + A"            "Claude Code desplegable (Quake)"
row "SUPER + R"            "Lanzador de apps (wofi)"
row "SUPER + C"            "Cerrar ventana activa"
row "SUPER + V"            "Ventana flotante on/off"
row "SUPER + F"            "Pantalla completa"
row "SUPER + L"            "Bloquear pantalla (hyprlock)"
row "SUPER + M"            "Salir de Hyprland"

sec "" "HYPRLAND · Foco, mover y tamaño"
row "SUPER + ←↑↓→"         "Mover el foco entre ventanas"
row "SUPER + SHIFT + ←↑↓→" "Mover la ventana de sitio"
row "SUPER + CTRL + ←↑↓→"  "Redimensionar (mantén pulsado)"
row "SUPER + ratón izq."   "Arrastrar la ventana"
row "SUPER + ratón der."   "Redimensionar con el ratón"

sec "" "HYPRLAND · Escritorios"
row "SUPER + 1…0"          "Ir al escritorio (1–10)"
row "SUPER + SHIFT + 1…0"  "Enviar la ventana al escritorio"

sec "" "UTILIDADES"
row "Print"               "Captura completa → portapapeles"
row "SUPER + SHIFT + S"   "Captura de región → swappy"
row "SUPER + SHIFT + V"   "Historial de portapapeles"
row "SUPER + SHIFT + C"   "Cuentagotas de color"
row "SUPER + N"           "Notas rápidas"
row "SUPER + SHIFT + H"   "Esta guía"
row "Teclas multimedia"   "Volumen / silencio / play-pausa"

sec "" "NOTAS  (nano)"
row "Ctrl + O"            "Guardar"
row "Ctrl + X"            "Salir"
row "Ctrl + K / U"        "Cortar / pegar línea"
row "Ctrl + W"            "Buscar"

sec "" "KITTY  (terminal)"
row "Ctrl+Shift + C / V"  "Copiar / pegar"
row "Ctrl+Shift + T"      "Nueva pestaña"
row "Ctrl+Shift + Enter"  "Nueva ventana"
row "Ctrl+Shift + + / -"  "Tamaño de la fuente"

sec "" "WOFI · SWAYNC"
row "wofi: escribir"      "Filtra · Enter lanza · Esc cierra"
row "Campana (waybar)"    "Centro de notificaciones"

printf "\n   ${DIM}─────────────────────────────────────────────────────────────${R}\n"
}

# --- Paginador con scroll por flechas (en bash puro, sin dependencias) ---
pager() {
    mapfile -t LINES < <(render)
    local n=${#LINES[@]} top=0 rows view max i k k2 k3 saved
    saved=$(stty -g 2>/dev/null)                           # guardar estado tty
    stty -echo 2>/dev/null                                 # sin eco (evita que respuestas del terminal, ej. "21", se pinten)
    printf '\033[?1049h'                                   # pantalla alternativa
    tput civis 2>/dev/null                                 # ocultar cursor
    trap 'stty "$saved" 2>/dev/null; tput cnorm 2>/dev/null; printf "\033[?1049l"' EXIT INT TERM
    read -rsn64 -t 0.05 _ 2>/dev/null                      # vaciar entrada pendiente (respuestas del terminal)

    while true; do
        rows=$(tput lines 2>/dev/null || echo 40); view=$(( rows - 1 ))
        (( view < 1 )) && view=1
        max=$(( n - view )); (( max < 0 )) && max=0
        (( top > max )) && top=$max; (( top < 0 )) && top=0

        printf '\033[H\033[2J'
        for (( i=top; i<top+view && i<n; i++ )); do printf '%s\n' "${LINES[i]}"; done
        printf '\033[7m%s\033[0m' "  ↑ ↓  desplazar   ·   q  salir   ·   $((top+1))/$n  "

        IFS= read -rsn1 k || break
        if [[ $k == $'\033' ]]; then
            read -rsn1 -t 0.05 k2
            if [[ $k2 == '[' ]]; then
                read -rsn1 -t 0.05 k3
                case $k3 in
                    A) k=up;; B) k=down;;
                    5) read -rsn1 -t 0.05 _; k=pgup;;
                    6) read -rsn1 -t 0.05 _; k=pgdn;;
                    H) k=home;; F) k=end;;
                esac
            else
                k=quit   # ESC suelto = salir
            fi
        fi
        case $k in
            up|k)        (( top-- ));;
            down|j)      (( top++ ));;
            pgup)        (( top -= view ));;
            pgdn|' ')    (( top += view ));;
            home|g)      top=0;;
            end|G)       top=$max;;
            q|quit)      break;;
        esac
    done
}

# less da mejor experiencia (búsqueda, ratón) si lo tienes; si no, paginador propio.
if command -v less >/dev/null 2>&1; then
    render | less -R --tilde -P '   ↑ ↓  desplazar   ·   PgUp/PgDn   ·   q  salir '
else
    pager
fi
