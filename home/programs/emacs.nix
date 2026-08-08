{ pkgs, ... }:
{
  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    prettier
    shfmt
    shellcheck
  ];

  # Symlink tree-sitter grammars so Emacs can find them
  # Emacs looks in ~/.emacs.d/var/treesit
  home.file.".emacs.d/var/treesit" = {
    source = "${pkgs.emacsPackages.treesit-grammars.with-all-grammars}/lib";
    recursive = true;
  };
}
