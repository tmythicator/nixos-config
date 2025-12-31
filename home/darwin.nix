{
  pkgs,
  user,
  config,
  ...
}:
{
  imports = [ ./shared.nix ];

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
    tree-sitter
  ];

  programs.zsh.shellAliases = {
    update = "sudo nix run nix-darwin -- switch --flake ${config.home.homeDirectory}/Development/nixos-config#macos";
    upgrade = "nix flake update --flake ${config.home.homeDirectory}/Development/nixos-config && update";
  };

  programs.emacs.package = pkgs.emacs;
}
