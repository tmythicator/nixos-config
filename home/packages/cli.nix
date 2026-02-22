{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI Tools
    eza # better ls
    bat # cat with highlighting
    fd # faster find
    ripgrep
    fzf # Ctrl+R fuzzy
    zoxide # better cd
    htop
    fastfetch
    ffmpeg
    google-cloud-sdk
  ];
}
