{ pkgs, lib, ... }:
let
  tokens = import ../../palette.nix;

  gtkTheme = import ./gtk.nix;
  waybarSwayncTheme = import ./waybar-swaync.nix;
  fuzzelTheme = import ./fuzzel.nix { inherit pkgs lib; };
  hyprlandTheme = import ./hyprland.nix { inherit lib; };

  darkWaybarCssDerivation = pkgs.writeText "waybar-theme-dark.css" (
    waybarSwayncTheme.mkWaybarThemeCss tokens.dark
  );
  lightWaybarCssDerivation = pkgs.writeText "waybar-theme-light.css" (
    waybarSwayncTheme.mkWaybarThemeCss tokens.light
  );

  darkGtkCssDerivation = pkgs.writeText "gtk-theme-dark.css" (gtkTheme.mkFullGtkCss tokens.dark);
  lightGtkCssDerivation = pkgs.writeText "gtk-theme-light.css" (gtkTheme.mkFullGtkCss tokens.light);

  darkFuzzelDerivation = pkgs.writeText "fuzzel-theme-dark.ini" (fuzzelTheme.mkFuzzelIni tokens.dark);
  lightFuzzelDerivation = pkgs.writeText "fuzzel-theme-light.ini" (
    fuzzelTheme.mkFuzzelIni tokens.light
  );

  darkHyprlandDerivation = pkgs.writeText "hyprland-theme-dark.lua" (
    hyprlandTheme.mkHyprlandThemeLua tokens.dark
  );
  lightHyprlandDerivation = pkgs.writeText "hyprland-theme-light.lua" (
    hyprlandTheme.mkHyprlandThemeLua tokens.light
  );

  getTheme = pkgs.writeShellScriptBin "get-theme" ''
    if [ "$(cat "$HOME/.config/timcha-theme/mode" 2>/dev/null)" = "light" ]; then
      echo '{"text":"Light","class":"light","tooltip":"Theme: Light\nClick to toggle"}'
    else
      echo '{"text":"Dark","class":"dark","tooltip":"Theme: Dark\nClick to toggle"}'
    fi
  '';

  toggleTheme = pkgs.writeShellScriptBin "toggle-theme" ''
    MODE="$1"
    STATE_DIR="$HOME/.config/timcha-theme"
    STATE_FILE="$STATE_DIR/mode"

    mkdir -p "$STATE_DIR" "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/fuzzel" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/hypr"

    CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
    [ "$MODE" = "toggle" ] || [ -z "$MODE" ] && { [ "$CURRENT" = "dark" ] && MODE="light" || MODE="dark"; }
    echo "$MODE" > "$STATE_FILE"

    case "$MODE" in
      light)
        CSS="${lightWaybarCssDerivation}"
        GTK_CSS="${lightGtkCssDerivation}"
        FUZZEL="${lightFuzzelDerivation}"
        HYPR_LUA="${lightHyprlandDerivation}"
        GTK="${tokens.light.gtkColorScheme}"
        GTK_THEME="adw-gtk3"
        ;;
      *)
        CSS="${darkWaybarCssDerivation}"
        GTK_CSS="${darkGtkCssDerivation}"
        FUZZEL="${darkFuzzelDerivation}"
        HYPR_LUA="${darkHyprlandDerivation}"
        GTK="${tokens.dark.gtkColorScheme}"
        GTK_THEME="adw-gtk3-dark"
        ;;
    esac

    ln -sf "$CSS" "$HOME/.config/waybar/theme.css"
    ln -sf "$CSS" "$HOME/.config/swaync/theme.css"
    ln -sf "$GTK_CSS" "$HOME/.config/gtk-3.0/gtk.css"
    ln -sf "$GTK_CSS" "$HOME/.config/gtk-4.0/gtk.css"
    ln -sf "$FUZZEL" "$HOME/.config/fuzzel/fuzzel.ini"
    ln -sf "$HYPR_LUA" "$HOME/.config/hypr/theme.lua"

    export GSETTINGS_SCHEMA_DIR="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "$GTK" 2>/dev/null || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'$GTK'" 2>/dev/null || true
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'" 2>/dev/null || true

    ${pkgs.hyprland}/bin/hyprctl eval "dofile(os.getenv('HOME') .. '/.config/hypr/theme.lua')" >/dev/null 2>&1 || true
    ${pkgs.libnotify}/bin/notify-send -t 800 -h string:x-canonical-private-synchronous:theme-notify -u low "󱎖 THEME" "$MODE" >/dev/null 2>&1 &

    ${pkgs.procps}/bin/pkill -SIGUSR2 waybar 2>/dev/null || true
    ${pkgs.procps}/bin/pkill -RTMIN+8 waybar 2>/dev/null || true
    ${pkgs.swaynotificationcenter}/bin/swaync-client -R -rs >/dev/null 2>&1 &
  '';
in
{
  home.packages = [
    getTheme
    toggleTheme
  ];

  # Initialization via Home-Manager activation
  home.activation.initTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/fuzzel" "$HOME/.config/timcha-theme" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/hypr"
    if [ ! -f "$HOME/.config/waybar/theme.css" ]; then
      ln -sf "${darkWaybarCssDerivation}" "$HOME/.config/waybar/theme.css"
    fi
    if [ ! -f "$HOME/.config/swaync/theme.css" ]; then
      ln -sf "${darkWaybarCssDerivation}" "$HOME/.config/swaync/theme.css"
    fi
    if [ ! -f "$HOME/.config/gtk-3.0/gtk.css" ]; then
      ln -sf "${darkGtkCssDerivation}" "$HOME/.config/gtk-3.0/gtk.css"
    fi
    if [ ! -f "$HOME/.config/gtk-4.0/gtk.css" ]; then
      ln -sf "${darkGtkCssDerivation}" "$HOME/.config/gtk-4.0/gtk.css"
    fi
    if [ ! -f "$HOME/.config/fuzzel/fuzzel.ini" ]; then
      ln -sf "${darkFuzzelDerivation}" "$HOME/.config/fuzzel/fuzzel.ini"
    fi
    if [ ! -f "$HOME/.config/hypr/theme.lua" ]; then
      ln -sf "${darkHyprlandDerivation}" "$HOME/.config/hypr/theme.lua"
    fi
  '';
}
