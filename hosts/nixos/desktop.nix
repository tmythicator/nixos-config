{ pkgs, ... }:
{
  # DE
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
      gnome = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    totem
    yelp
    gnome-terminal
    gnome-console
    gnome-maps
    gnome-contacts
    gnome-music
    gnome-characters
    gnome-font-viewer
    simple-scan
    gnome-software
  ];
}
