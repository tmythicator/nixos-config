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
    homeDirectory = "/Users/${user}"; # This technically could use homeDir if homeDir wasn't defined using config.home.homeDirectory. Circular dependency risk unless we hardcode path or use mkDefault. Sticking to literal here or use let above.
    # config.home.homeDirectory is set by home-manager based on username usually, but here it is explicit.
    # To be safe and simple, we will keep the explicit assignment here as is, or use the let var if we defined it differently.
    # But wait, 'homeDir' in let comes from 'config.home.homeDirectory'.
    # So we cannot use 'homeDir' to SET 'home.homeDirectory'.
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
