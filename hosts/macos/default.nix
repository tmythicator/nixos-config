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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
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
    ];

    brews = [
      "acrogenesis/macchanger/macchanger"
    ];

    casks = [
      "balenaetcher"
      "docker"
      "emacs-app"
      "gimp"
      "google-chrome" # Added (works best via Cask on macOS)
      "keepassxc"
      "libreoffice"
      "openmtp"
      "supercollider"
      "tor-browser"
      "vlc"
    ];
  };

  system.configurationRevision = null;

  # System settings --------------------------------------------------------------------------------
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    dock.mineffect = "scale";
    dock.minimize-to-application = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "Managed by nix-darwin";
    screencapture.location = "~/Pictures/Screenshots";
    screensaver.askForPasswordDelay = 10;

    # Finder preferences
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    finder._FXShowPosixPathInTitle = true;
    finder.FXDefaultSearchScope = "SCcf"; # Search current folder by default
    finder.AppleShowAllFiles = true; # Show dotfiles

    # UI/UX
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSTableViewDefaultSizeMode = 2; # Sidebar icon size: small
    screencapture.disable-shadow = true;

    # Keyboard
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
  };
  system.primaryUser = user;

  # Add ability to use TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true; # default shell on catalina

  system.stateVersion = 6;
}
