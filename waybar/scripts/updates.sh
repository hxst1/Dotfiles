#!/usr/bin/env bash
# Waybar: actualizaciones pendientes (repos oficiales). Oculto si no hay.
# Clic → terminal flotante con yay -Syu.
n=$(checkupdates 2>/dev/null | wc -l)
(( n == 0 )) && { echo '{"text":""}'; exit; }
printf '{"text":"\U000f03d5  %d","tooltip":"%d actualizaciones pendientes\\nclic: actualizar el sistema","class":"pending"}\n' "$n" "$n"
