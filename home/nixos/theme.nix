{ pkgs, lib, ... }:
let
  tokens = import ../palette.nix;

  mkGtkThemeCss = t: ''
    @define-color bar_bg ${t.barBg};
    @define-color text_main ${t.textMain};
    @define-color text_muted ${t.textMuted};
    @define-color text_secondary ${t.textSecondary};
    @define-color border_normal ${t.borderNormal};
    @define-color border_active ${t.borderActive};
    @define-color shadow_color ${t.shadowColor};
    @define-color card_bg ${t.cardBg};
    @define-color card_hover ${t.cardHover};
    @define-color accent_cyan ${t.accentPrimary};
    @define-color accent_fuchsia ${t.accentSecondary};
    @define-color accent_green ${t.accentGreen};
    @define-color accent_yellow ${t.accentYellow};
    @define-color accent_red ${t.accentRed};
    @define-color active_btn_bg ${t.activeBtnBg};
    @define-color active_btn_text ${t.activeBtnText};
    @define-color active_btn_shadow ${t.activeBtnShadow};
  '';

  mkAlacrittyToml = t: ''
    [colors.primary]
    background = "${t.barBg}"
    foreground = "${t.textMain}"

    [colors.selection]
    text = "${t.activeBtnText}"
    background = "${t.activeBtnBg}"

    [colors.normal]
    black = "${t.cardBg}"
    red = "${t.accentRed}"
    green = "${t.accentGreen}"
    yellow = "${t.accentYellow}"
    blue = "${t.accentBlue}"
    magenta = "${t.accentMagenta}"
    cyan = "${t.accentCyan}"
    white = "${t.textSecondary}"

    [colors.bright]
    black = "${t.cardHover}"
    red = "${t.accentRedBright}"
    green = "${t.accentGreenBright}"
    yellow = "${t.accentYellowBright}"
    blue = "${t.accentBlueBright}"
    magenta = "${t.accentMagentaBright}"
    cyan = "${t.accentCyanBright}"
    white = "${t.brightWhite}"
  '';

  stripHash = c: lib.removePrefix "#" c;

  mkFuzzelIni = t: ''
    [main]
    font=JetBrainsMono Nerd Font:size=11
    prompt="❯ "
    terminal=${pkgs.alacritty}/bin/alacritty
    lines=10
    width=40
    horizontal-pad=20
    vertical-pad=12
    inner-pad=8
    layer=overlay

    [border]
    width=2
    radius=4

    [colors]
    background=${stripHash t.barBg}ff
    text=${stripHash t.textMain}ff
    prompt=${stripHash t.accentSecondary}ff
    placeholder=${stripHash t.textMuted}ff
    input=${stripHash t.textMain}ff
    match=${stripHash t.accentPrimary}ff
    selection=${stripHash t.cardBg}ff
    selection-text=${stripHash t.accentPrimary}ff
    selection-match=${stripHash t.accentSecondary}ff
    border=${stripHash t.borderActive}ff
  '';

  darkCssDerivation = pkgs.writeText "waybar-theme-dark.css" (mkGtkThemeCss tokens.dark);
  lightCssDerivation = pkgs.writeText "waybar-theme-light.css" (mkGtkThemeCss tokens.light);

  mkFullGtkCss = t: ''
    /* Legacy GTK Named Colors */
    @define-color bg_color ${t.barBg};
    @define-color fg_color ${t.textMain};
    @define-color base_color ${t.cardBg};
    @define-color text_color ${t.textMain};
    @define-color selected_bg_color ${t.accentPrimary};
    @define-color selected_fg_color ${t.activeBtnText};
    @define-color menubar_bg_color ${t.barBg};
    @define-color menubar_fg_color ${t.textMain};
    @define-color toolbar_bg_color ${t.barBg};
    @define-color toolbar_fg_color ${t.textMain};
    @define-color insensitive_bg_color ${t.cardBg};
    @define-color insensitive_fg_color ${t.textMuted};

    /* Libadwaita GTK Named Colors */
    @define-color theme_bg_color ${t.barBg};
    @define-color theme_fg_color ${t.textMain};
    @define-color theme_base_color ${t.cardBg};
    @define-color theme_text_color ${t.textMain};
    @define-color theme_selected_bg_color ${t.accentPrimary};
    @define-color theme_selected_fg_color ${t.activeBtnText};
    @define-color theme_hover_bg_color ${t.cardHover};
    @define-color theme_hover_fg_color ${t.accentPrimary};
    @define-color theme_unfocused_bg_color ${t.barBg};
    @define-color theme_unfocused_fg_color ${t.textMain};
    @define-color accent_color ${t.accentPrimary};
    @define-color accent_bg_color ${t.accentPrimary};
    @define-color accent_fg_color ${t.activeBtnText};
    @define-color window_bg_color ${t.barBg};
    @define-color window_fg_color ${t.textMain};
    @define-color view_bg_color ${t.cardBg};
    @define-color view_fg_color ${t.textMain};
    @define-color headerbar_bg_color ${t.barBg};
    @define-color headerbar_fg_color ${t.textMain};
    @define-color headerbar_backdrop_color ${t.barBg};
    @define-color headerbar_border_color ${t.borderNormal};
    @define-color card_bg_color ${t.cardBg};
    @define-color card_fg_color ${t.textMain};
    @define-color dialog_bg_color ${t.barBg};
    @define-color dialog_fg_color ${t.textMain};
    @define-color popover_bg_color ${t.cardBg};
    @define-color popover_fg_color ${t.textMain};
    @define-color popover_shade_color ${t.cardBg};
    @define-color menu_bg_color ${t.cardBg};
    @define-color menu_fg_color ${t.textMain};
    @define-color tooltip_bg_color ${t.cardBg};
    @define-color tooltip_fg_color ${t.textMain};
    @define-color borders ${t.borderNormal};
    @define-color scrollbar_outline_color ${t.borderNormal};

    window,
    .background,
    window.background {
      background-color: ${t.barBg};
      color: ${t.textMain};
    }

    headerbar,
    .titlebar,
    actionbar {
      background-color: ${t.barBg};
      border-bottom: 2px solid ${t.borderNormal};
      color: ${t.textMain};
    }

    menubar,
    .menubar,
    menubar.background {
      background-color: ${t.barBg};
      color: ${t.textMain};
      border: none;
    }

    menubar > menuitem,
    .menubar > menuitem {
      background-color: transparent;
      color: ${t.textMain};
      padding: 4px 8px;
    }

    menubar > menuitem:hover,
    .menubar > menuitem:hover {
      background-color: ${t.cardHover};
      color: ${t.accentPrimary};
    }

    toolbar,
    .toolbar {
      background-color: ${t.barBg};
      color: ${t.textMain};
    }

    button {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      box-shadow: 2px 2px 0px 0px ${t.shadowColor};
      transition: all 0.15s ease;
    }

    button:hover {
      background-color: ${t.cardHover};
      border-color: ${t.accentPrimary};
      color: ${t.accentPrimary};
      box-shadow: 2px 2px 0px 0px ${t.accentPrimary};
    }

    button:checked, button.suggested-action {
      background-color: ${t.accentPrimary};
      color: ${t.activeBtnText};
      border-color: ${t.accentPrimary};
      box-shadow: 2px 2px 0px 0px ${t.activeBtnShadow};
      font-weight: bold;
    }

    button.flat,
    headerbar button.flat {
      background-color: transparent;
      border: none;
      box-shadow: none;
    }

    button.flat:hover,
    headerbar button.flat:hover {
      background-color: ${t.cardHover};
      color: ${t.accentPrimary};
      border: none;
      box-shadow: none;
    }

    popover,
    popover.background,
    popover > contents,
    popover contents,
    .popover,
    menu,
    .menu,
    .context-menu {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 1px solid ${t.borderNormal};
      border-radius: 6px;
      box-shadow: 0px 4px 12px ${t.shadowColor};
      padding: 4px;
    }

    popover arrow,
    popover.background arrow {
      background-color: ${t.cardBg};
      border-color: ${t.borderNormal};
    }

    popover modelbutton,
    popover button,
    popover button.flat,
    menuitem,
    .menuitem,
    modelbutton,
    row,
    listview row,
    .dropdown row,
    dropdown popover contents listview row {
      background-color: transparent;
      color: ${t.textMain};
      border: none;
      box-shadow: none;
      border-radius: 4px;
      padding: 6px 10px;
      transition: background-color 0.1s ease, color 0.1s ease;
    }

    popover modelbutton:hover,
    popover button:hover,
    popover button.flat:hover,
    menuitem:hover,
    menu menuitem:hover,
    .menuitem:hover,
    modelbutton:hover,
    row:hover,
    listview row:hover,
    list row:hover,
    .dropdown row:hover,
    dropdown popover contents listview row:hover,
    popover modelbutton:focus,
    modelbutton:focus,
    menuitem:focus,
    row:focus {
      background-color: ${t.cardHover};
      color: ${t.accentPrimary};
      border: none;
      box-shadow: none;
    }

    popover modelbutton:hover label,
    popover modelbutton:hover image,
    popover modelbutton:hover GtkLabel,
    popover modelbutton:hover GtkImage,
    popover button:hover label,
    popover button:hover image,
    menuitem:hover label,
    menuitem:hover image,
    menuitem:hover GtkLabel,
    menuitem:hover GtkImage,
    modelbutton:hover label,
    modelbutton:hover image,
    row:hover label,
    row:hover image {
      color: ${t.accentPrimary};
    }

    popover modelbutton:selected,
    popover modelbutton:active,
    menuitem:selected,
    menuitem:active,
    row:selected,
    listview row:selected {
      background-color: ${t.accentPrimary};
      color: ${t.activeBtnText};
    }

    popover modelbutton:selected label,
    popover modelbutton:selected image,
    menuitem:selected label,
    menuitem:selected image,
    row:selected label,
    row:selected image {
      color: ${t.activeBtnText};
    }

    tooltip,
    tooltip.background,
    .tooltip,
    tooltip > contents {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 1px solid ${t.borderNormal};
      border-radius: 4px;
      box-shadow: 2px 2px 0px 0px ${t.shadowColor};
    }

    tooltip label {
      color: ${t.textMain};
    }

    combobox,
    dropdown {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      padding: 4px 8px;
    }

    combobox:hover,
    dropdown:hover {
      border-color: ${t.accentPrimary};
    }

    combobox window,
    combobox popover,
    dropdown popover {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 1px solid ${t.borderNormal};
      border-radius: 6px;
    }

    scale trough {
      background-color: ${t.cardBg};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      min-height: 8px;
    }

    scale highlight {
      background-color: ${t.accentPrimary};
      border-radius: 2px;
    }

    scale slider {
      background-color: ${t.accentSecondary};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      min-width: 16px;
      min-height: 16px;
      box-shadow: 1px 1px 0px 0px ${t.shadowColor};
    }

    notebook tab {
      background-color: ${t.cardBg};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px 4px 0 0;
      color: ${t.textMuted};
      font-weight: 700;
      padding: 4px 10px;
    }

    notebook tab:checked {
      background-color: ${t.accentPrimary};
      color: ${t.activeBtnText};
      border-color: ${t.accentPrimary};
    }

    entry {
      background-color: ${t.cardBg};
      color: ${t.textMain};
      border: 2px solid ${t.borderNormal};
      border-radius: 4px;
      padding: 4px 8px;
    }

    entry:focus {
      border-color: ${t.accentPrimary};
      box-shadow: 2px 2px 0px 0px ${t.accentPrimary};
    }

    scrollbar trough {
      background-color: ${t.barBg};
    }

    scrollbar slider {
      background-color: ${t.borderNormal};
      border-radius: 4px;
      min-width: 6px;
      min-height: 6px;
    }

    scrollbar slider:hover {
      background-color: ${t.accentPrimary};
    }

    separator {
      background-color: ${t.borderNormal};
      min-height: 1px;
      min-width: 1px;
    }

    list,
    listview,
    treeview {
      background-color: ${t.cardBg};
      color: ${t.textMain};
    }
  '';

  darkGtkCssDerivation = pkgs.writeText "gtk-theme-dark.css" (mkFullGtkCss tokens.dark);
  lightGtkCssDerivation = pkgs.writeText "gtk-theme-light.css" (mkFullGtkCss tokens.light);

  darkAlacrittyDerivation = pkgs.writeText "alacritty-theme-dark.toml" (mkAlacrittyToml tokens.dark);
  lightAlacrittyDerivation = pkgs.writeText "alacritty-theme-light.toml" (
    mkAlacrittyToml tokens.light
  );

  darkFuzzelDerivation = pkgs.writeText "fuzzel-theme-dark.ini" (mkFuzzelIni tokens.dark);
  lightFuzzelDerivation = pkgs.writeText "fuzzel-theme-light.ini" (mkFuzzelIni tokens.light);

  getTheme = pkgs.writeShellScriptBin "get-theme" ''
    if [ "$(cat "$HOME/.config/timcha-theme/mode" 2>/dev/null)" = "light" ]; then
      echo '{"text":"Light","class":"light","tooltip":"Theme: Timcha Light\nClick to toggle"}'
    else
      echo '{"text":"Dark","class":"dark","tooltip":"Theme: Timcha Dark\nClick to toggle"}'
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
        CSS="${lightCssDerivation}"
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
        CSS="${darkCssDerivation}"
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
      ln -sf "${darkCssDerivation}" "$HOME/.config/waybar/theme.css"
    fi
    if [ ! -f "$HOME/.config/swaync/theme.css" ]; then
      ln -sf "${darkCssDerivation}" "$HOME/.config/swaync/theme.css"
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
