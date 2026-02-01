{
  pkgs,
  ...
}:
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
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -nw";
    VISUAL = "emacsclient -c -a 'emacs'";
  };

  home.packages = with pkgs; [
    # CLI Tools
    eza # better ls
    bat # cat with highlighting
    fd # faster find
    ripgrep
    fzf # Ctrl+R fuzzy
    zoxide # better cd
    htop
    fastfetch
    ffmpeg
    (if stdenv.isLinux then wl-clipboard else null)

    # GUI Apps (Shared)
    (if stdenv.isDarwin then firefox-bin else firefox)
    telegram-desktop
    rclone
    keepassxc
    antigravity
    audacity
    reaper

    # Fonts
    nerd-fonts.jetbrains-mono

    # LSPs/Formatters
    nodePackages.typescript-language-server
    tailwindcss-language-server
    nixd
    nixfmt
    gopls
    clojure
    clojure-lsp
  ];
}
