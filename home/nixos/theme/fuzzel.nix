{ pkgs, lib }:
let
  stripHash = c: lib.removePrefix "#" c;
in
{
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
}
