CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.name // empty')
CURRENT_JSON=$(hyprctl activewindow -j)
CURRENT_ADDR=$(echo "$CURRENT_JSON" | jq -r '.address // empty')

# List other visible windows (excluding active window)
CLIENTS_JSON=$(hyprctl clients -j)
SELECTED=$(echo "$CLIENTS_JSON" | jq -r --arg cur "$CURRENT_ADDR" \
  '.[] | select(.address != $cur and .mapped == true) | "\(.title) — \(.class) [ws \(.workspace.name)] | \(.address)"' \
  | fuzzel -d --prompt "switch buffer: ")

TARGET_ADDR=$(echo "$SELECTED" | awk -F' \\| ' '{print $NF}')

dismiss_special() {
  SPECIAL_OPEN=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .specialWorkspace.name // empty')
  if [ -n "$SPECIAL_OPEN" ]; then
    SPECIAL_NAME="${SPECIAL_OPEN#special:}"
    hyprctl dispatch "hl.dsp.workspace.toggle_special('$SPECIAL_NAME')"
  fi
}

if [ -n "$TARGET_ADDR" ]; then
  TARGET_WS=$(echo "$CLIENTS_JSON" | jq -r --arg addr "$TARGET_ADDR" '.[] | select(.address == $addr) | .workspace.name')

  if [ -n "$CURRENT_ADDR" ] && [ -n "$CURRENT_WS" ]; then
    if [ "$TARGET_WS" != "$CURRENT_WS" ]; then
      # True Emacs replace: move current window to target's old workspace, and target to current workspace
      hyprctl dispatch "hl.dsp.window.move({ window = 'address:$CURRENT_ADDR', workspace = '$TARGET_WS' })"
      hyprctl dispatch "hl.dsp.window.move({ window = 'address:$TARGET_ADDR', workspace = '$CURRENT_WS' })"
      dismiss_special
      hyprctl dispatch "hl.dsp.focus({ window = 'address:$TARGET_ADDR' })"
    else
      # Same workspace: swap positions and focus
      hyprctl dispatch "hl.dsp.window.swap({ target = 'address:$TARGET_ADDR' })"
      hyprctl dispatch "hl.dsp.focus({ window = 'address:$TARGET_ADDR' })"
    fi
  else
    if [ -n "$CURRENT_WS" ]; then
      hyprctl dispatch "hl.dsp.window.move({ window = 'address:$TARGET_ADDR', workspace = '$CURRENT_WS' })"
      dismiss_special
    fi
    hyprctl dispatch "hl.dsp.focus({ window = 'address:$TARGET_ADDR' })"
  fi
fi
