{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    # package is defined in OS-specific configs
  };

  # Symlink tree-sitter grammars so Emacs (Brew or Nix) can find them
  # Emacs looks in ~/.emacs.d/var/treesit/ (Doom/Standard)
  home.file.".emacs.d/var/treesit" = {
    source = "${
      pkgs.emacsPackages.treesit-grammars.with-grammars (
        grammars: with grammars; [
          tree-sitter-bash
          tree-sitter-css
          tree-sitter-dockerfile
          tree-sitter-html
          tree-sitter-javascript
          tree-sitter-json
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-tsx
          tree-sitter-typescript
          tree-sitter-yaml
          tree-sitter-go
          tree-sitter-gomod
          tree-sitter-python
          tree-sitter-clojure
        ]
      )
    }/lib";
    recursive = true;
  };
}
