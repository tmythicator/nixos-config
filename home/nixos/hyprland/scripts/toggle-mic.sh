IDS=$(wpctl status | awk '/Sources:/,/Filters:/' | grep -oE '[0-9]+\.' | tr -d '.')
if [ -n "$IDS" ]; then
  MUTED=0
  for id in $IDS; do
    wpctl set-mute "$id" toggle
    if wpctl get-volume "$id" | grep -q '\[MUTED\]'; then
      MUTED=1
    fi
  done
  if [ "$MUTED" -eq 1 ]; then
    notify-send -t 800 -h string:x-canonical-private-synchronous:mic-notify -u low "󰍭 MIC" "Muted"
  else
    notify-send -t 800 -h string:x-canonical-private-synchronous:mic-notify -u low "󰍬 MIC" "Unmuted"
  fi
else
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle 2>/dev/null || true
fi
