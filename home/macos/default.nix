{
  pkgs,
  user,
  config,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  flakeDir = "${homeDir}/Development/nixos-config";
in
{
  imports = [ ./../shared.nix ];

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
  };

  # Specific dependencies for macOS
  home.packages = with pkgs; [
    # Add macOS specific packages here
    go
    nodejs
    curl
    wget
    yt-dlp
    colima # Docker runtime for macOS
  ];

  programs.zsh = {
    envExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = {
      update = "sudo nix run nix-darwin -- switch --flake ${flakeDir}#macos";
      upgrade = "nix flake update --flake ${flakeDir} && update";

      # Macchanger aliases
      show-mac = "macchanger -s en0";
      spoof-mac = "sudo macchanger -r en0";
      reset-mac = "sudo macchanger -p en0";
    };
  };

  programs.emacs.package = pkgs.emacs;
}
