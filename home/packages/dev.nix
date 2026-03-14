{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # LSPs/Formatters
    nodePackages.typescript-language-server
    tailwindcss-language-server
    nixd
    nixfmt
    gopls
    clojure
    clojure-lsp
    pkgs.jdt-language-server
    copilot-language-server
    jdk
  ];
}
