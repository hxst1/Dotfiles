#!/usr/bin/env bash
# Waybar: notificaciones sin leer de GitHub (PRs, reviews, menciones). Oculto si 0.
# Clic → github.com/notifications.
n=$(gh api notifications --jq 'length' 2>/dev/null) || { echo '{"text":""}'; exit; }
(( n == 0 )) && { echo '{"text":""}'; exit; }
tip=$(gh api notifications --jq '.[:8][] | "\(.repository.name) · \(.subject.title)"' 2>/dev/null | sed 's/"/\\"/g; s/&/&amp;/g; s/</\&lt;/g' | awk '{printf "%s\\n", $0}')
printf '{"text":"\U000f02a4  %d","tooltip":"%sclic: abrir notificaciones","class":"unread"}\n' "$n" "$tip"
