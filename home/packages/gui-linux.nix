{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Browsers / Messengers
    google-chrome
    discord-ptb
    telegram-desktop
    tor-browser

    # Media
    gimp
    darktable
    vlc
    tauon
    crosspipe
    gthumb
    audacity
    kooha

    # File Manager
    thunar
    thunar-archive-plugin
    tumbler
    file-roller

    # Dev / Tools
    eclipses.eclipse-java
    jetbrains.idea
    keepassxc
    popsicle
    zathura
    vial
  ];
}
