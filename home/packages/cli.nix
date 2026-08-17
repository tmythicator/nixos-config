{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI Tools
    eza # better ls
    bat # cat with highlighting
    fd # faster find
    ripgrep
    htop
    fastfetch
    ffmpeg
    google-cloud-sdk
    rclone
    zip
    unzip
    yt-dlp
    cloudflared
    openssl
  ];
}
