{ ... }:
let
  tokens = import ../palette.nix;

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
in
{
  xdg.configFile."alacritty/theme.toml".text = mkAlacrittyToml tokens.dark;
}
