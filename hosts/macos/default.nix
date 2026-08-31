{
  user,
  ...
}:
{
  imports = [
    ../system-shared.nix
    ./homebrew.nix
  ];

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  # Nix configuration

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.configurationRevision = null;

  environment.systemPath = [
    "/Applications/Emacs.app/Contents/MacOS"
    "/Applications/Emacs.app/Contents/MacOS/bin"
  ];

  # System settings
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

  # Remap CapsLock to Ctrl
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # SKHD for hotkeys
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # <Super>Space -> Cycle input source / languages
      cmd - space : osascript -e 'tell application "System Events" to key code 49 using {control down}'

      # <Super>l -> Lock Screen
      cmd - l : pmset displaysleepnow

      # <Super><Shift>l -> Sleep / Suspend
      cmd + shift - l : pmset sleepnow

      # <Super><Shift>s -> Screenshot fullscreen to clipboard
      cmd + shift - s : screencapture -c
    '';
  };

  system.primaryUser = user;

  # Emacs daemon launchd service
  launchd.user.agents.emacs = {
    serviceConfig = {
      ProgramArguments = [
        "/Applications/Emacs.app/Contents/MacOS/Emacs"
        "--fg-daemon"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/emacs.stdout.log";
      StandardErrorPath = "/tmp/emacs.stderr.log";
      EnvironmentVariables = {
        PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/${user}/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };

  # Add ability to use TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 6;
}
