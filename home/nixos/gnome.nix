{ pkgs, ... }:
{
  # GNOME utils & Extensions
  home.packages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.just-perfection
  ];

  # GNOME Settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      center-new-windows = true;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "ctrl:nocaps"
      ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
      ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      gestures = false;
      osd = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-group = [ ];
      switch-group-backward = [ ];
      switch-input-source-backward = [ ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>a";
      command = "alacritty";
      name = "Alacritty";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "emacsclient -c -n";
      name = "Emacs Client";
    };
  };
}
