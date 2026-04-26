{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.treesit-grammars.with-all-grammars
    ];
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts

    prettier
    shfmt
    shellcheck
  ];

  # Symlink tree-sitter grammars so Emacs (Brew or Nix) can find them
  # Emacs looks in ~/.emacs.d/var/treesit/ (Doom/Standard)
  home.file.".emacs.d/var/treesit" = {
    source = "${pkgs.emacsPackages.treesit-grammars.with-all-grammars}/lib";
    recursive = true;
  };
}
