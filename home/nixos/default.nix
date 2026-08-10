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
    ./hyprland.nix
    ./waybar.nix
    ./swaync.nix
    ./theme.nix
    ../packages/gui-linux.nix
    ../programs/rclone.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  home.packages = with pkgs; [
    cmake
    gnumake
    gcc
    libtool
    libvterm
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

  programs.zsh = {
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ${flakeDir}#sff-icient";
      upgrade = "nix flake update --flake ${flakeDir} && update";
    };
  };

  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser & Web
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];

      # Messengers
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/discord" = [ "discord-ptb.desktop" ];

      # Media Players
      "video/mp4" = [ "vlc.desktop" ];
      "video/mkv" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "tauonmb.desktop" ];
      "audio/flac" = [ "tauonmb.desktop" ];
    };
  };
}
