{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix
    nixd
    nixfmt

    # Go
    go
    gopls

    # Clojure
    clojure
    clojure-lsp

    # Java / Kotlin / Maven
    jdk
    jdt-language-server
    kotlin-language-server
    maven

    # JS/TS
    nodejs
    typescript-language-server
    tailwindcss-language-server
  ];
}
