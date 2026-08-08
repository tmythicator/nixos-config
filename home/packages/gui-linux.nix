{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Browsers & Messengers
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

    # Dev / Tools
    eclipses.eclipse-java
    jetbrains.idea
    keepassxc
    popsicle
  ];
}
