{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # GUI Apps (Shared)
    (if stdenv.isDarwin then firefox-bin else firefox)
    rclone
    keepassxc
    antigravity
    reaper
    mermaid-cli
    darktable
  ] ++ lib.optionals (!stdenv.isDarwin) [
    audacity
    telegram-desktop
  ];
}
