{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.extraFlags = [ "--force" ];

    taps = [
      "nikitabobko/tap"
    ];

    brews = [
      "colima"
      "docker"
      "docker-compose"
    ];

    casks = [
      "nikitabobko/tap/aerospace"
      "audacity"
      "balenaetcher"
      "darktable"
      "gimp"
      "google-chrome"
      "ghostty"
      "intellij-idea"
      "keepassxc"
      "libreoffice"
      "openmtp"
      "supercollider"
      "telegram"
      "tor-browser"
      "vlc"
      "emacs-app"
      "vial"
    ];
  };
}
