#!/usr/bin/env bash
# Pill de Waybar: detecta servidores de desarrollo escuchando en estos puertos.
# Uso:
#   devserver.sh           -> imprime JSON para Waybar (oculto si no hay ninguno)
#   devserver.sh open      -> abre el de menor puerto en Google Chrome
#   devserver.sh kill      -> mata los servidores detectados
#
# Añade/quita puertos aquí (típicos de Next, que sube 3000→3001→…, y Vite):
PORTS=(3000 3001 3002 5173)

# Devuelve los puertos en escucha (de mi usuario) en orden ascendente.
active_ports() {
    local p
    for p in "${PORTS[@]}"; do
        if ss -tlnH "( sport = :$p )" 2>/dev/null | grep -q .; then
            echo "$p"
        fi
    done
}

case "$1" in
    open)
        port=$(active_ports | head -1)
        [ -n "$port" ] && setsid google-chrome-stable "http://localhost:$port" >/dev/null 2>&1 &
        ;;
    kill)
        for port in $(active_ports); do
            fuser -k "${port}/tcp" >/dev/null 2>&1
        done
        ;;
    *)
        ports=$(active_ports | paste -sd ' ')
        if [ -z "$ports" ]; then
            echo '{"text":""}'
        else
            list=$(echo "$ports" | sed 's/ /, /g')
            printf '{"text":"   %s","class":"active","tooltip":"Servidor dev activo en: %s\\nclic = abrir en Chrome · clic dcho = cerrar"}\n' \
                   "$(echo "$ports" | awk '{print $1}')" "$list"
        fi
        ;;
esac
