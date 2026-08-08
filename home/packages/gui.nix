{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      # GUI Apps (Shared)
      (if pkgs.stdenv.isDarwin then firefox-bin else firefox)
      antigravity
      reaper
      mermaid-cli
      darktable
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      # Browsers
      google-chrome
      discord-ptb
      telegram-desktop
      tor-browser

      # Media
      gimp
      vlc
      tauon
      crosspipe
      gthumb
      audacity
      kooha

      # Dev / Tools
      eclipses.eclipse-java
      jetbrains.idea
      keepassxc
      popsicle
    ];
}
