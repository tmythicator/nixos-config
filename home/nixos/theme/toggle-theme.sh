MODE="${1:-}"
STATE_DIR="$HOME/.config/timcha-theme"
STATE_FILE="$STATE_DIR/mode"

mkdir -p "$STATE_DIR" "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/fuzzel" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/hypr"

CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
if [ "$MODE" = "toggle" ] || [ -z "$MODE" ]; then
  if [ "$CURRENT" = "dark" ]; then
    MODE="light"
  else
    MODE="dark"
  fi
fi
echo "$MODE" > "$STATE_FILE"

case "$MODE" in
  light)
    CSS="@lightWaybarCss@"
    GTK_CSS="@lightGtkCss@"
    FUZZEL="@lightFuzzel@"
    HYPR_LUA="@lightHyprland@"
    GTK="@lightGtkColorScheme@"
    GTK_THEME="adw-gtk3"
    BG="@lightBarBg@"
    ;;
  *)
    CSS="@darkWaybarCss@"
    GTK_CSS="@darkGtkCss@"
    FUZZEL="@darkFuzzel@"
    HYPR_LUA="@darkHyprland@"
    GTK="@darkGtkColorScheme@"
    GTK_THEME="adw-gtk3-dark"
    BG="@darkBarBg@"
    ;;
esac

ln -sf "$CSS" "$HOME/.config/waybar/theme.css"
ln -sf "$CSS" "$HOME/.config/swaync/theme.css"
ln -sf "$GTK_CSS" "$HOME/.config/gtk-3.0/gtk.css"
ln -sf "$GTK_CSS" "$HOME/.config/gtk-4.0/gtk.css"
ln -sf "$FUZZEL" "$HOME/.config/fuzzel/fuzzel.ini"
ln -sf "$HYPR_LUA" "$HOME/.config/hypr/theme.lua"

export GSETTINGS_SCHEMA_DIR="@schemaDir@"
gsettings set org.gnome.desktop.interface color-scheme "$GTK" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/color-scheme "'$GTK'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'" 2>/dev/null || true

hyprctl eval "dofile(os.getenv('HOME') .. '/.config/hypr/theme.lua')" >/dev/null 2>&1 || true
pkill -x .swaybg-wrapped 2>/dev/null || pkill -x swaybg 2>/dev/null || true
swaybg -c "$BG" >/dev/null 2>&1 &
notify-send -t 800 -h string:x-canonical-private-synchronous:theme-notify -u low "󱎖 THEME" "$MODE" >/dev/null 2>&1 &

pkill -SIGUSR2 waybar 2>/dev/null || true
pkill -RTMIN+8 waybar 2>/dev/null || true
swaync-client -R -rs >/dev/null 2>&1 &
