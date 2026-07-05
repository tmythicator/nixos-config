{ ... }:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  imports = [
    ./programs/alacritty.nix
    ./programs/starship.nix
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/emacs.nix
    ./programs/xdg.nix
    ./packages/cli.nix
    ./packages/gui.nix
    ./packages/dev.nix
    ./packages/fonts.nix
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -nw";
    VISUAL = "emacsclient -c -a 'emacs'";
  };
}
