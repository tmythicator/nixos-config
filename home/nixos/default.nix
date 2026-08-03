{
  config,
  pkgs,
  user,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  flakeDir = "${homeDir}/Development/nixos-config";
in
{
  imports = [
    ../shared.nix
    ../secrets.nix
    ./gnome.nix
    ../programs/rclone.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.packages = with pkgs; [
    google-chrome
    eclipses.eclipse-java
    jetbrains.idea

    # Container Tools
    docker
    docker-compose

    # Media
    gimp
    vlc
    tauon
    crosspipe
    gthumb

    popsicle
    discord-ptb
    wl-clipboard
    yt-dlp
  ];

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
      update = "sudo nixos-rebuild switch --flake ${flakeDir}#sff-icient";
      upgrade = "nix flake update --flake ${flakeDir} && update";
    };
  };
}
