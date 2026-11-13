{ config, pkgs, lib, ... }:
let
  tokens = import ../palette.nix;

  mkTheme = t: ''
    background = ${t.barBg}
    foreground = ${t.textMain}
    selection-background = ${t.activeBtnBg}
    selection-foreground = ${t.activeBtnText}
    cursor-color = ${t.textMain}

    palette = 0=${t.cardBg}
    palette = 1=${t.accentRed}
    palette = 2=${t.accentGreen}
    palette = 3=${t.accentYellow}
    palette = 4=${t.accentBlue}
    palette = 5=${t.accentMagenta}
    palette = 6=${t.accentCyan}
    palette = 7=${t.textSecondary}
    palette = 8=${t.cardHover}
    palette = 9=${t.accentRedBright}
    palette = 10=${t.accentGreenBright}
    palette = 11=${t.accentYellowBright}
    palette = 12=${t.accentBlueBright}
    palette = 13=${t.accentMagentaBright}
    palette = 14=${t.accentCyanBright}
    palette = 15=${t.brightWhite}
  '';
in
{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.ghostty ];

  xdg.configFile."ghostty/themes/solarized-dark".text = mkTheme tokens.dark;
  xdg.configFile."ghostty/themes/solarized-light".text = mkTheme tokens.light;

  xdg.configFile."ghostty/config".text = ''
    font-family = "JetBrainsMono Nerd Font"
    font-size = 13.0
    window-padding-x = 10
    window-padding-y = 10
    window-decoration = false
    gtk-titlebar = false
    background-opacity = 0.95
    mouse-hide-while-typing = true
    cursor-style = block
    app-notifications = no-config-reload

    theme = light:solarized-light,dark:solarized-dark
  '';
}
