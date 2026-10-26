#!/usr/bin/env bash
# gaming-mode.sh — Modo Gaming (toggle con SUPER+G)
# Libera recursos para que el PC se centre 100% en el juego:
#   · Cierra navegadores y apps pesadas (Chrome, Discord, Spotify...)
#   · Mata servidores de desarrollo (Next.js/Vite/Webpack...)
#   · Para servicios web de usuario (sakura-tv) — NUNCA toca hyprterm
#   · Para contenedores Docker
#   · Gobernador de CPU a 'performance' + libera caché RAM (vía helper root)
# Volver a pulsar SUPER+G lo desactiva y restaura todo.
set -uo pipefail

STATE="${XDG_RUNTIME_DIR:-/tmp}/gaming-mode.state"
ROOT_HELPER="/usr/local/bin/gaming-mode-root"

# --- Apps pesadas a cerrar (navegadores + Electron). Edita a tu gusto ---
APPS=(chrome chromium brave firefox vivaldi
      discord slack spotify telegram-desktop)
# --- Servidores de desarrollo (Next.js/React/Three.js dev) ---
DEV=(next-server vite webpack esbuild turbo nodemon "pnpm dev" "npm run dev")
# --- Servicios systemd de usuario a parar (NUNCA incluyas hyprterm) ---
SERVICES=(sakura-tv.service)

notify() { notify-send -a "Modo Gaming" "$1" "${2:-}" 2>/dev/null || true; }

# Procesos que NUNCA se matan aunque coincidan con un patrón.
# OJO: Steam usa Chromium/CEF (steamwebhelper lleva '--enable-chrome-runtime'),
# así que sin esto un patrón como 'chrome' tumbaría Steam entero.
PROTECT='steam|hyprterm|gaming-mode'

# Mata procesos cuya cmdline contiene "$1", saltándose lo protegido y este script.
# Devuelve 0 si mató algo (para añadirlo a la lista 'killed').
kill_safe() {
    local pat="$1" found=1 pid cmd
    for pid in $(pgrep -fi -- "$pat" 2>/dev/null); do
        [ "$pid" = "$$" ] || [ "$pid" = "$PPID" ] && continue
        cmd=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)
        echo "$cmd" | grep -qiE -- "$PROTECT" && continue
        kill -TERM "$pid" 2>/dev/null && found=0
    done
    return $found
}

enable_mode() {
    local killed=()
    for a in "${APPS[@]}"; do
        kill_safe "$a" && killed+=("$a")
    done
    for d in "${DEV[@]}"; do
        kill_safe "$d" && killed+=("$d")
    done
    for s in "${SERVICES[@]}"; do
        if systemctl --user is-active --quiet "$s"; then
            systemctl --user stop "$s" && killed+=("${s%.service}")
        fi
    done
    if command -v docker >/dev/null 2>&1 && [ -n "$(docker ps -q 2>/dev/null)" ]; then
        docker stop $(docker ps -q) >/dev/null 2>&1 && killed+=("docker")
    fi
    # Hyprland: fuera efectos visuales (blur/sombras/animaciones/bordes) + tearing
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl --batch "keyword decoration:blur:enabled false ; keyword decoration:shadow:enabled false ; keyword decoration:rounding 0 ; keyword animations:enabled false ; keyword general:allow_tearing true ; keyword misc:vfr false" >/dev/null 2>&1 || true
    fi
    # Optimización root (gobernador + caché + NVIDIA). Silencioso si no hay permiso sudoers.
    sudo -n "$ROOT_HELPER" on >/dev/null 2>&1 || true

    echo "on" > "$STATE"
    local msg="CPU a rendimiento máximo, caché RAM liberada."
    [ ${#killed[@]} -gt 0 ] && msg="Cerrado: ${killed[*]}. $msg"
    notify "🎮 Modo Gaming ACTIVADO" "$msg"
}

disable_mode() {
    sudo -n "$ROOT_HELPER" off >/dev/null 2>&1 || true
    # Restaura los efectos de Hyprland recargando tu config
    command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
    for s in "${SERVICES[@]}"; do
        systemctl --user start "$s" 2>/dev/null || true
    done
    rm -f "$STATE"
    notify "🌙 Modo Gaming DESACTIVADO" "CPU normal (schedutil), servicios reanudados."
}

if [ -f "$STATE" ]; then
    disable_mode
else
    enable_mode
fi
