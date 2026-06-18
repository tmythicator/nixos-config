{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # LSPs/Formatters
    typescript-language-server
    tailwindcss-language-server
    nixd
    nixfmt
    gopls
    clojure
    clojure-lsp
    jdt-language-server
    copilot-language-server
    jdk
    maven
  ];
}
