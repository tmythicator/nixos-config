{
  pkgs,
  user,
  ...
}:
{
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  # Nix configuration ------------------------------------------------------------------------------

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Enable Homebrew
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    taps = [
      "acrogenesis/macchanger"
      "daviderestivo/emacs-head"
    ];

    brews = [
      "colima"
      "docker"
      "docker-compose"
      "icu4c@77"
      "acrogenesis/macchanger/macchanger"
    ];

    casks = [
      "antigravity"
      "balenaetcher"
      "emacs-app"
      "gimp"
      "google-chrome" # Added (requested shared, but works best via Cask on macOS)
      "keepassxc"
      "libreoffice"
      "openmtp"
      "supercollider"
      "temurin@17"
      "tor-browser"
      "tuxguitar"
      "vlc"
    ];
  };

  system.configurationRevision = null;

  # System settings --------------------------------------------------------------------------------
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "nix-darwin managed";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
  };
  system.primaryUser = user;

  # Add ability to use TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;  # default shell on catalina

  system.stateVersion = 6;
}
