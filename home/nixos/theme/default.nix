{ pkgs, lib, ... }:
let
  tokens = import ../../palette.nix;

  gtkTheme = import ./gtk.nix;
  waybarSwayncTheme = import ./waybar-swaync.nix;
  fuzzelTheme = import ./fuzzel.nix { inherit pkgs lib; };
  hyprlandTheme = import ./hyprland.nix { inherit lib; };

  darkWaybarCssDerivation = pkgs.writeText "waybar-theme-dark.css" (
    waybarSwayncTheme.mkWaybarThemeCss tokens.dark
  );
  lightWaybarCssDerivation = pkgs.writeText "waybar-theme-light.css" (
    waybarSwayncTheme.mkWaybarThemeCss tokens.light
  );

  darkGtkCssDerivation = pkgs.writeText "gtk-theme-dark.css" (gtkTheme.mkFullGtkCss tokens.dark);
  lightGtkCssDerivation = pkgs.writeText "gtk-theme-light.css" (gtkTheme.mkFullGtkCss tokens.light);

  darkFuzzelDerivation = pkgs.writeText "fuzzel-theme-dark.ini" (fuzzelTheme.mkFuzzelIni tokens.dark);
  lightFuzzelDerivation = pkgs.writeText "fuzzel-theme-light.ini" (
    fuzzelTheme.mkFuzzelIni tokens.light
  );

  darkHyprlandDerivation = pkgs.writeText "hyprland-theme-dark.lua" (
    hyprlandTheme.mkHyprlandThemeLua tokens.dark
  );
  lightHyprlandDerivation = pkgs.writeText "hyprland-theme-light.lua" (
    hyprlandTheme.mkHyprlandThemeLua tokens.light
  );

  getTheme = pkgs.writeShellApplication {
    name = "get-theme";
    runtimeInputs = with pkgs; [ coreutils ];
    text = builtins.readFile ./get-theme.sh;
  };

  toggleTheme = pkgs.writeShellApplication {
    name = "toggle-theme";
    runtimeInputs = with pkgs; [
      coreutils
      glib
      dconf
      hyprland
      swaybg
      procps
      swaynotificationcenter
      libnotify
    ];
    text = builtins.readFile (
      pkgs.replaceVars ./toggle-theme.sh {
        lightWaybarCss = lightWaybarCssDerivation;
        lightGtkCss = lightGtkCssDerivation;
        lightFuzzel = lightFuzzelDerivation;
        lightHyprland = lightHyprlandDerivation;
        lightGtkColorScheme = tokens.light.gtkColorScheme;
        lightBarBg = tokens.light.barBg;

        darkWaybarCss = darkWaybarCssDerivation;
        darkGtkCss = darkGtkCssDerivation;
        darkFuzzel = darkFuzzelDerivation;
        darkHyprland = darkHyprlandDerivation;
        darkGtkColorScheme = tokens.dark.gtkColorScheme;
        darkBarBg = tokens.dark.barBg;

        schemaDir = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      }
    );
  };
in
{
  home.packages = [
    getTheme
    toggleTheme
  ];

  # Initialization via Home-Manager activation
  home.activation.initTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/fuzzel" "$HOME/.config/timcha-theme" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/hypr"
    if [ ! -f "$HOME/.config/waybar/theme.css" ]; then
      ln -sf "${darkWaybarCssDerivation}" "$HOME/.config/waybar/theme.css"
    fi
    if [ ! -f "$HOME/.config/swaync/theme.css" ]; then
      ln -sf "${darkWaybarCssDerivation}" "$HOME/.config/swaync/theme.css"
    fi
    if [ ! -f "$HOME/.config/gtk-3.0/gtk.css" ]; then
      ln -sf "${darkGtkCssDerivation}" "$HOME/.config/gtk-3.0/gtk.css"
    fi
    if [ ! -f "$HOME/.config/gtk-4.0/gtk.css" ]; then
      ln -sf "${darkGtkCssDerivation}" "$HOME/.config/gtk-4.0/gtk.css"
    fi
    if [ ! -f "$HOME/.config/fuzzel/fuzzel.ini" ]; then
      ln -sf "${darkFuzzelDerivation}" "$HOME/.config/fuzzel/fuzzel.ini"
    fi
    if [ ! -f "$HOME/.config/hypr/theme.lua" ]; then
      ln -sf "${darkHyprlandDerivation}" "$HOME/.config/hypr/theme.lua"
    fi
  '';
}
