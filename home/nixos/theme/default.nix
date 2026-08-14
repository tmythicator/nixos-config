{ pkgs, lib, ... }:
let
  tokens = import ../../palette.nix;

  gtkTheme = import ./gtk.nix;
  waybarSwayncTheme = import ./waybar-swaync.nix;
  alacrittyTheme = import ./alacritty.nix;
  fuzzelTheme = import ./fuzzel.nix { inherit pkgs lib; };

  darkWaybarCssDerivation = pkgs.writeText "waybar-theme-dark.css" (
    waybarSwayncTheme.mkWaybarThemeCss tokens.dark
  );
  lightWaybarCssDerivation = pkgs.writeText "waybar-theme-light.css" (
    waybarSwayncTheme.mkWaybarThemeCss tokens.light
  );

  darkGtkCssDerivation = pkgs.writeText "gtk-theme-dark.css" (
    gtkTheme.mkFullGtkCss tokens.dark
  );
  lightGtkCssDerivation = pkgs.writeText "gtk-theme-light.css" (
    gtkTheme.mkFullGtkCss tokens.light
  );

  darkAlacrittyDerivation = pkgs.writeText "alacritty-theme-dark.toml" (
    alacrittyTheme.mkAlacrittyToml tokens.dark
  );
  lightAlacrittyDerivation = pkgs.writeText "alacritty-theme-light.toml" (
    alacrittyTheme.mkAlacrittyToml tokens.light
  );

  darkFuzzelDerivation = pkgs.writeText "fuzzel-theme-dark.ini" (
    fuzzelTheme.mkFuzzelIni tokens.dark
  );
  lightFuzzelDerivation = pkgs.writeText "fuzzel-theme-light.ini" (
    fuzzelTheme.mkFuzzelIni tokens.light
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

    mkdir -p "$STATE_DIR" "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/alacritty" "$HOME/.config/fuzzel" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

    CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
    [ "$MODE" = "toggle" ] || [ -z "$MODE" ] && { [ "$CURRENT" = "dark" ] && MODE="light" || MODE="dark"; }
    echo "$MODE" > "$STATE_FILE"

    case "$MODE" in
      light)
        CSS="${lightWaybarCssDerivation}"
        GTK_CSS="${lightGtkCssDerivation}"
        TOML="${lightAlacrittyDerivation}"
        FUZZEL="${lightFuzzelDerivation}"
        GTK="${tokens.light.gtkColorScheme}"
        GTK_THEME="adw-gtk3"
        HYPR_BORDER="${tokens.light.hyprActiveBorder}"
        HYPR_INACTIVE="${tokens.light.hyprInactiveBorder}"
        HYPR_GRP_ACTIVE="${tokens.light.hyprGroupBorderActive}"
        HYPR_GRP_INACTIVE="${tokens.light.hyprGroupBorderInactive}"
        HYPR_BG="${tokens.light.hyprBackground}"
        ;;
      *)
        CSS="${darkWaybarCssDerivation}"
        GTK_CSS="${darkGtkCssDerivation}"
        TOML="${darkAlacrittyDerivation}"
        FUZZEL="${darkFuzzelDerivation}"
        GTK="${tokens.dark.gtkColorScheme}"
        GTK_THEME="adw-gtk3-dark"
        HYPR_BORDER="${tokens.dark.hyprActiveBorder}"
        HYPR_INACTIVE="${tokens.dark.hyprInactiveBorder}"
        HYPR_GRP_ACTIVE="${tokens.dark.hyprGroupBorderActive}"
        HYPR_GRP_INACTIVE="${tokens.dark.hyprGroupBorderInactive}"
        HYPR_BG="${tokens.dark.hyprBackground}"
        ;;
    esac

    ln -sf "$CSS" "$HOME/.config/waybar/theme.css"
    ln -sf "$CSS" "$HOME/.config/swaync/theme.css"
    ln -sf "$GTK_CSS" "$HOME/.config/gtk-3.0/gtk.css"
    ln -sf "$GTK_CSS" "$HOME/.config/gtk-4.0/gtk.css"
    ln -sf "$TOML" "$HOME/.config/alacritty/theme.toml"
    ln -sf "$FUZZEL" "$HOME/.config/fuzzel/fuzzel.ini"

    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "$GTK" 2>/dev/null || true
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'$GTK'" 2>/dev/null || true
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'" 2>/dev/null || true

    ${pkgs.hyprland}/bin/hyprctl --batch "dispatch keyword general:col.active_border '$HYPR_BORDER'; dispatch keyword general:col.inactive_border '$HYPR_INACTIVE'; dispatch keyword group:col.border_active '$HYPR_GRP_ACTIVE'; dispatch keyword group:col.border_inactive '$HYPR_GRP_INACTIVE'; dispatch keyword misc:background_color '$HYPR_BG'" 2>/dev/null || true
    ${pkgs.libnotify}/bin/notify-send -t 800 -h string:x-canonical-private-synchronous:theme-notify -u low "󱎖 THEME" "$MODE"

    ${pkgs.procps}/bin/pkill -SIGUSR2 waybar 2>/dev/null || true
    ${pkgs.procps}/bin/pkill -RTMIN+8 waybar 2>/dev/null || true
    ${pkgs.swaynotificationcenter}/bin/swaync-client -R -rs 2>/dev/null || true
  '';
in
{
  home.packages = [
    getTheme
    toggleTheme
  ];

  # Initialization via Home-Manager activation
  home.activation.initTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/alacritty" "$HOME/.config/fuzzel" "$HOME/.config/timcha-theme" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
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
    if [ ! -f "$HOME/.config/alacritty/theme.toml" ]; then
      ln -sf "${darkAlacrittyDerivation}" "$HOME/.config/alacritty/theme.toml"
    fi
    if [ ! -f "$HOME/.config/fuzzel/fuzzel.ini" ]; then
      ln -sf "${darkFuzzelDerivation}" "$HOME/.config/fuzzel/fuzzel.ini"
    fi
  '';
}
