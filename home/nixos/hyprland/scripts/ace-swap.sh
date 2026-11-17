WS=$(hyprctl activeworkspace -j | jq -r '.id')
TARGET_ADDR=$(hyprctl clients -j | jq -r --arg ws "$WS" '[.[] | select(.workspace.id == ($ws | tonumber) and .mapped == true)] | to_entries | .[] | "[\(.key + 1)] \(.value.title) — \(.value.class) | \(.value.address)"' | fuzzel -d --prompt "swap with [1..9]: " | awk -F' \\| ' '{print $NF}')
if [ -n "$TARGET_ADDR" ]; then
  hyprctl dispatch "hl.dsp.window.swap({ target = 'address:$TARGET_ADDR' })"
fi
