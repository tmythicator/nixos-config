{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.extraFlags = [ "--force" ];

    brews = [
      "colima"
      "docker"
      "docker-compose"
      "yt-dlp"
    ];

    casks = [
      "audacity"
      "balenaetcher"
      "gimp"
      "google-chrome"
      "intellij-idea"
      "libreoffice"
      "openmtp"
      "supercollider"
      "telegram-desktop"
      "tor-browser"
      "vlc"
      "emacs-app"
    ];
  };
}
