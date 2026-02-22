{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # GUI Apps (Shared)
    (if stdenv.isDarwin then firefox-bin else firefox)
    telegram-desktop
    rclone
    keepassxc
    google-antigravity
    audacity
    reaper
    mermaid-cli
  ];
}
