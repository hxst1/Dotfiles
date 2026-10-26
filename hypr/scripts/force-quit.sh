#!/usr/bin/env bash
# force-quit.sh — Cierra COMPLETAMENTE la app de la ventana activa
# (no solo la ventana: mata el proceso entero, para que no quede en segundo plano).
# Atajo: SUPER+SHIFT+Q
set -uo pipefail

info=$(hyprctl activewindow -j 2>/dev/null)
pid=$(echo "$info" | python3 -c "import sys,json
try: print(json.load(sys.stdin).get('pid',''))
except: print('')" 2>/dev/null)
class=$(echo "$info" | python3 -c "import sys,json
try: print(json.load(sys.stdin).get('class','').lower())
except: print('')" 2>/dev/null)

[ -z "$pid" ] && exit 0

case "$class" in
  *steam*)
    # Steam: apagado limpio (cierra también la bandeja)
    steam -shutdown >/dev/null 2>&1 &
    ;;
  *)
    # Resto: matar el grupo de procesos completo (cubre Chrome y sus hijos)
    pgid=$(ps -o pgid= -p "$pid" 2>/dev/null | tr -d ' ')
    if [ -n "$pgid" ]; then
      kill -TERM -"$pgid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null
      # si en 3s sigue vivo, forzar
      ( sleep 3; kill -0 "$pid" 2>/dev/null && kill -KILL -"$pgid" 2>/dev/null ) &
    else
      kill -TERM "$pid" 2>/dev/null
    fi
    ;;
esac
