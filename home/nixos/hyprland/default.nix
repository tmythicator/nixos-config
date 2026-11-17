{ pkgs, lib, ... }:
let
  tokens = import ../../palette.nix;
  hyprlandTheme = import ../theme/hyprland.nix { inherit lib; };
  hyprPackages = import ./packages.nix { inherit pkgs; };
in
{
  home.packages = hyprPackages.all;

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "System Settings";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=GNOME ${pkgs.gnome-control-center}/bin/gnome-control-center";
    terminal = false;
    categories = [
      "Settings"
      "Utility"
    ];
  };

  programs.hyprlock = {
    enable = true;
    settings = hyprlandTheme.mkHyprlockSettings tokens.dark;
  };

  services.hypridle = import ./idle.nix { inherit pkgs; };

  # Let NixOS manage xdg-desktop-portal globally (hosts/sff-icient/desktop.nix)
  xdg.portal.enable = lib.mkForce false;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    configType = "lua";
    extraConfig = builtins.readFile (
      pkgs.replaceVars ./config.lua {
        barBg = tokens.dark.barBg;
        dbus = "${pkgs.dbus}/bin/dbus-update-activation-environment";
        systemctl = "${pkgs.systemd}/bin/systemctl";
        swaybg = "${pkgs.swaybg}/bin/swaybg";
        nmApplet = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        blueman = "${pkgs.blueman}/bin/blueman-applet";
        polkit = "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent";
        fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
        cliphist = "${pkgs.cliphist}/bin/cliphist";
        wlCopy = "${pkgs.wl-clipboard}/bin/wl-copy";
        ghostty = "${pkgs.ghostty}/bin/ghostty";
        hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
        pkill = "${pkgs.procps}/bin/pkill";
        swayncClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";
        wireplumber = "${pkgs.wireplumber}/bin/wpctl";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        screenshot = "${hyprPackages.screenshot}/bin/screenshot";
        aceSwap = "${hyprPackages.aceSwap}/bin/ace-swap";
        split = "${hyprPackages.hyprSplit}/bin/hypr-split";
        switchBuffer = "${hyprPackages.switchBuffer}/bin/switch-buffer";
      }
    );
  };
}
