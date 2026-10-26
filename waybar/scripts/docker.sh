#!/usr/bin/env bash
# Waybar: contenedores Docker en marcha, agrupados por proyecto compose.
# Oculto si no hay ninguno. Clic → panel flotante (lazydocker).
command -v docker >/dev/null || { echo '{"text":""}'; exit; }
mapfile -t rows < <(docker ps --format '{{.Label "com.docker.compose.project"}}|{{.Names}}' 2>/dev/null)
n=${#rows[@]}
(( n == 0 )) && { echo '{"text":"","class":"empty"}'; exit; }
tip=$(printf '%s\n' "${rows[@]}" | awk -F'|' '{p=($1==""?$2:$1); c[p]++} END {for (k in c) printf "%s · %d\\n", k, c[k]}' | sort)
printf '{"text":"\U000f0868  %d","tooltip":"Docker en marcha\\n%sclic: gestionar","class":"running"}\n' "$n" "$tip"
