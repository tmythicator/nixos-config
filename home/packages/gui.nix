{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      # GUI Apps (Shared)
      (if pkgs.stdenv.isDarwin then firefox-bin else firefox)
      antigravity
      reaper
      mermaid-cli
      darktable
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      audacity
      keepassxc
      telegram-desktop
    ];
}
