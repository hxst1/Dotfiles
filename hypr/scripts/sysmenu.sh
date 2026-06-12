#!/usr/bin/env bash
# Mini-monitor del sistema (CPU / RAM / TEMP / DISCO) — estética lila.
# Se refresca cada 2s; q para cerrar.

R=$'\033[0m'; B=$'\033[1m'
L1=$'\033[38;2;201;168;212m'; L2=$'\033[38;2;179;136;196m'
DIM=$'\033[38;2;125;115;135m'; TXT=$'\033[38;2;223;218;230m'
YEL=$'\033[38;2;224;175;104m'; RED=$'\033[38;2;255;107;129m'

bar() {  # $1 = porcentaje
    local p=${1%.*} w=22 f i out="" col=$L1
    (( p<0 )) && p=0; (( p>100 )) && p=100
    (( p>=85 )) && col=$RED || { (( p>=65 )) && col=$YEL; }
    f=$(( p*w/100 ))
    for ((i=0;i<w;i++)); do (( i<f )) && out+="${col}█" || out+="${DIM}░"; done
    printf "%s%s" "$out" "$R"
}
tcol() { local t=$1; (( t>=80 )) && printf "$RED" || { (( t>=65 )) && printf "$YEL" || printf "$L1"; }; }

read_cpu() { local a b c d e f g; read -r _ a b c d e f g _ < /proc/stat; echo "$((a+b+c+d+e+f+g)) $d"; }

prev=($(read_cpu))
printf '\033[?1049h'; tput civis 2>/dev/null; stty -echo 2>/dev/null
trap 'stty echo 2>/dev/null; tput cnorm 2>/dev/null; printf "\033[?1049l"' EXIT INT TERM

while true; do
    cur=($(read_cpu)); dt=$(( ${cur[0]} - ${prev[0]} )); di=$(( ${cur[1]} - ${prev[1]} ))
    cpu=0; (( dt>0 )) && cpu=$(( (dt-di)*100/dt )); prev=("${cur[@]}")

    read -r memt memu < <(free -m | awk '/^Mem:/{print $2, $3}')
    rampct=$(( memu*100/memt ))
    ramg=$(awk "BEGIN{printf \"%.1f/%.1f\", $memu/1024, $memt/1024}")

    ctemp=$(( $(cat /sys/class/hwmon/hwmon0/temp1_input 2>/dev/null || echo 0)/1000 ))
    gtemp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)
    [ -z "$gtemp" ] && gtemp="--"

    read -r dused dtot dpct < <(df -h --output=used,size,pcent / | tail -1)
    dnum=${dpct%\%}

    printf '\033[H\033[2J'
    printf "\n   ${L2}╭──────────────────────────────────────────╮${R}\n"
    printf   "   ${L2}│${R}   ${L1}${B}  Sistema${R}                                 ${L2}│${R}\n"
    printf   "   ${L2}╰──────────────────────────────────────────╯${R}\n\n"
    printf "    ${L2}${B}CPU${R}    $(bar $cpu)  ${TXT}%3s%%${R}\n\n"        "$cpu"
    printf "    ${L2}${B}RAM${R}    $(bar $rampct)  ${TXT}%3s%%${R}  ${DIM}%s GiB${R}\n\n" "$rampct" "$ramg"
    printf "    ${L2}${B}TEMP${R}   $(tcol $ctemp)CPU %s°${R}    $(tcol ${gtemp//[!0-9]/0})GPU %s°${R}\n\n" "$ctemp" "$gtemp"
    printf "    ${L2}${B}DISCO${R}  $(bar $dnum)  ${TXT}%4s${R}  ${DIM}%s/%s${R}\n\n" "$dpct" "$dused" "$dtot"
    printf "   ${DIM}────────────────────────────────────────────${R}\n"
    printf "   ${DIM}q  cerrar   ·   se actualiza cada 2s${R}"

    read -rsn1 -t 2 k && [[ $k == q ]] && break
done
