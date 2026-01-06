{
  config,
  pkgs,
  user,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  flakeDir = "${homeDir}/Development/nixos-config";
  sopsKeyFile = "${homeDir}/.config/sops/age/keys.txt";
in
{
  imports = [
    ../shared.nix
    ./gnome.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = sopsKeyFile;
  };

  home.packages = with pkgs; [
    google-chrome

    # Media
    gimp
    vlc
    tauon
  ];

  # Sops (Linux specific path mostly, but could be shared if paths were aligned)
  sops = {
    defaultSopsFile = ../../secrets.yaml; # adjusted for deeper nesting
    defaultSopsFormat = "yaml";
    age.keyFile = sopsKeyFile;

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
      update = "sudo nixos-rebuild switch --flake ${flakeDir}#nixos-rog";
      upgrade = "nix flake update --flake ${flakeDir} && update";
    };
  };
}
