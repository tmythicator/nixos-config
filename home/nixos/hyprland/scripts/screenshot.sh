MODE="${1:-region}"
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"

if [ "$MODE" = "full" ]; then
  grim "$FILE"
  notify-send -t 1200 -u low "SCREENSHOT" "Fullscreen captured & copied to clipboard"
else
  GEOM=$(slurp) || exit 0
  grim -g "$GEOM" "$FILE"
  notify-send -t 1200 -u low "SCREENSHOT" "Saved to ~/Pictures/Screenshots & copied to clipboard"
fi

wl-copy < "$FILE"
