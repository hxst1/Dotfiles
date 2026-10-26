#!/usr/bin/env bash
# Indicador de conectividad REAL a internet para Waybar.
# El PC va por cable (eno1), así que mirar solo el enlace no sirve: seguiría
# "conectado" aunque se caiga el router/ISP. Por eso hacemos un ping de verdad.
#   · Hay internet  -> icono wifi lleno   (clase "online")
#   · No hay internet -> icono wifi tachado (clase "offline", se pinta en rosa)

ICON_ON=$(printf '\U000F05A9')   # 󰖩  nf-md-wifi      (lleno)
ICON_OFF=$(printf '\U000F05AA')  # 󰖪  nf-md-wifi_off  (tachado)

# Ping rápido (1s timeout) a dos hosts fiables que responden ICMP.
if ping -c1 -W1 1.1.1.1 >/dev/null 2>&1 || ping -c1 -W1 8.8.8.8 >/dev/null 2>&1; then
    printf '{"text":"%s","class":"online","tooltip":"Internet: conectado"}\n' "$ICON_ON"
else
    printf '{"text":"%s","class":"offline","tooltip":"Internet: SIN conexión"}\n' "$ICON_OFF"
fi
