{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.extraFlags = [ "--force" ];

    brews = [
      "cmake"
      "libtool"
      "libvterm"
      "colima"
      "docker"
    ];

    casks = [
      "audacity"
      "balenaetcher"
      "darktable"
      "gimp"
      "google-chrome"
      "intellij-idea"
      "keepassxc"
      "libreoffice"
      "openmtp"
      "supercollider"
      "telegram"
      "tor-browser"
      "vlc"
      "emacs-app"
    ];
  };
}
