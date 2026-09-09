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

    # Scheme / Racket
    racket

    # Java / Kotlin
    jdk
    jdt-language-server
    kotlin
    kotlin-language-server
    ktlint
    gradle
    maven

    # Rust
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt

    # JS/TS
    nodejs
    typescript-language-server
    tailwindcss-language-server

    # Hardware / Keyboards
    qmk
  ];
}
