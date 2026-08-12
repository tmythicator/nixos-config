{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Wayland utils
    wl-clipboard
    brightnessctl
    playerctl
    wireplumber
    libnotify

    # System utils
    procps
    jq
    gawk

    # Dev
    docker-compose
  ];
}
