{
  config,
  pkgs,
  user,
  ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ./shared.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${homeDir}/.config/sops/age/keys.txt";
  };

  home.packages = with pkgs; [
    google-chrome

    # Media
    gimp
    vlc
    tauon

    # GNOME utils
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
  ];

  # Sops (Linux specific path mostly, but could be shared if paths were aligned)
  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";

    secrets.git_name = { };
    secrets.git_email = { };

    templates."git-user.inc" = {
      content = ''
        [user]
        name = ${config.sops.placeholder.git_name}
        email = ${config.sops.placeholder.git_email}
      '';
      path = "${homeDir}/.config/git/user.inc";
    };
  };

  # Emacs Daemon (Linux Systemd)
  services.emacs = {
    enable = true;
    package = config.programs.emacs.finalPackage;
    startWithUserSession = "graphical";
    client = {
      enable = true;
      arguments = [ "-c" ];
    };
  };

  systemd.user.services.emacs.Service = {
    Restart = "on-failure";
    RestartSec = 3;
    Environment = "DISPLAY=:0";
  };

  programs.emacs = {
    package = pkgs.emacs-pgtk; # Override with PGTK for Linux
  };

  programs.zsh = {
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ${homeDir}/Development/nixos-config#nixos-rog";
      upgrade = "nix flake update --flake ${homeDir}/Development/nixos-config && update";
    };
  };

  # GNOME settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      center-new-windows = true;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "ctrl:nocaps"
        "grp:ctrl_shift_toggle"
      ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
      ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      gestures = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>a";
      command = "alacritty";
      name = "Alacritty";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "emacsclient -c -n";
      name = "Emacs Client";
    };
  };
}
