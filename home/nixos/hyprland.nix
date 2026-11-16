{ pkgs, lib, ... }:
let
  tokens = import ../palette.nix;
  hyprlandTheme = import ./theme/hyprland.nix { inherit lib; };

  switchBuffer = pkgs.writeShellScriptBin "switch-buffer" ''
    ADDR=$(${pkgs.hyprland}/bin/hyprctl clients -j | ${pkgs.jq}/bin/jq -r '.[] | "\(.title) — \(.class) [ws \(.workspace.name)] | \(.address)"' | ${pkgs.fuzzel}/bin/fuzzel -d --prompt "buffer: " | ${pkgs.gawk}/bin/awk -F' \\| ' '{print $NF}')
    if [ -n "$ADDR" ]; then
      WS=$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.name')
      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspace "$WS,address:$ADDR"
      ${pkgs.hyprland}/bin/hyprctl dispatch focuswindow "address:$ADDR"
    fi
  '';

  splitBelow = pkgs.writeShellScriptBin "hypr-split-below" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch fullscreen 0
    COUNT=$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.windows // 0')
    if [ "$COUNT" -le 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg "preselect d"
      ${pkgs.ghostty}/bin/ghostty &
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg togglesplit
    fi
  '';

  splitRight = pkgs.writeShellScriptBin "hypr-split-right" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch fullscreen 0
    COUNT=$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.windows // 0')
    if [ "$COUNT" -le 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg "preselect r"
      ${pkgs.ghostty}/bin/ghostty &
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg togglesplit
    fi
  '';

  aceSwap = pkgs.writeShellScriptBin "ace-swap" ''
    TARGET_ADDR=$(${pkgs.hyprland}/bin/hyprctl clients -j | ${pkgs.jq}/bin/jq -r --arg ws "$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.id')" '[.[] | select(.workspace.id == ($ws | tonumber) and .mapped == true)] | to_entries | .[] | "[\(.key + 1)] \(.value.title) — \(.value.class) | \(.value.address)"' | ${pkgs.fuzzel}/bin/fuzzel -d --prompt "swap with [1..9]: " | ${pkgs.gawk}/bin/awk -F' \\| ' '{print $NF}')
    if [ -n "$TARGET_ADDR" ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch swapwindow "address:$TARGET_ADDR"
    fi
  '';

  screenshotRegion = pkgs.writeShellScriptBin "screenshot-region" ''
    DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$DIR"
    FILE="$DIR/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
    GEOM=$(${pkgs.slurp}/bin/slurp) || exit 0
    ${pkgs.grim}/bin/grim -g "$GEOM" "$FILE"
    ${pkgs.wl-clipboard}/bin/wl-copy < "$FILE"
    ${pkgs.libnotify}/bin/notify-send -t 1200 -u low "SCREENSHOT" "Saved to ~/Pictures/Screenshots & copied to clipboard"
  '';

  screenshotFull = pkgs.writeShellScriptBin "screenshot-full" ''
    DIR="$HOME/Pictures/Screenshots"
    mkdir -p "$DIR"
    FILE="$DIR/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
    ${pkgs.grim}/bin/grim "$FILE"
    ${pkgs.wl-clipboard}/bin/wl-copy < "$FILE"
    ${pkgs.libnotify}/bin/notify-send -t 1200 -u low "SCREENSHOT" "Fullscreen captured & copied to clipboard"
  '';

  gnomeSettings = pkgs.writeShellScriptBin "gnome-settings" ''
    export XDG_CURRENT_DESKTOP=GNOME
    exec ${pkgs.gnome-control-center}/bin/gnome-control-center "$@"
  '';

  toggleMic = pkgs.writeShellScriptBin "toggle-mic" ''
    IDS=$(${pkgs.wireplumber}/bin/wpctl status | ${pkgs.gawk}/bin/awk '/Sources:/,/Filters:/' | ${pkgs.gnugrep}/bin/grep -oE '[0-9]+\.' | tr -d '.')
    if [ -n "$IDS" ]; then
      MUTED=0
      for id in $IDS; do
        ${pkgs.wireplumber}/bin/wpctl set-mute "$id" toggle
        if ${pkgs.wireplumber}/bin/wpctl get-volume "$id" | ${pkgs.gnugrep}/bin/grep -q '\[MUTED\]'; then
          MUTED=1
        fi
      done
      if [ "$MUTED" -eq 1 ]; then
        ${pkgs.libnotify}/bin/notify-send -t 800 -h string:x-canonical-private-synchronous:mic-notify -u low "󰍭 MIC" "Muted"
      else
        ${pkgs.libnotify}/bin/notify-send -t 800 -h string:x-canonical-private-synchronous:mic-notify -u low "󰍬 MIC" "Unmuted"
      fi
    else
      ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle 2>/dev/null || true
    fi
  '';
in
{
  home.packages = with pkgs; [
    switchBuffer
    splitBelow
    splitRight
    aceSwap
    screenshotRegion
    screenshotFull
    gnomeSettings
    toggleMic
    swaybg
    grim
    slurp
    pavucontrol
    networkmanagerapplet
    blueman
    gnome-control-center
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "System Settings";
    icon = "org.gnome.Settings";
    exec = "gnome-settings";
    terminal = false;
    categories = [
      "Settings"
      "Utility"
      "X-GNOME-Settings-Panel"
    ];
  };

  # Lockscreen
  programs.hyprlock = {
    enable = true;
    settings = hyprlandTheme.mkHyprlockSettings tokens.dark;
  };

  # Background Services
  services.udiskie.enable = true;
  services.cliphist.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Let NixOS manage xdg-desktop-portal globally (hosts/sff-icient/desktop.nix)
  xdg.portal.enable = lib.mkForce false;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    configType = "lua";
    extraConfig = builtins.readFile (
      pkgs.replaceVars ./hyprland.lua {
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
        screenshotReg = "${screenshotRegion}/bin/screenshot-region";
        screenshotFull = "${screenshotFull}/bin/screenshot-full";
        aceSwap = "${aceSwap}/bin/ace-swap";
        splitBelow = "${splitBelow}/bin/hypr-split-below";
        splitRight = "${splitRight}/bin/hypr-split-right";
        switchBuffer = "${switchBuffer}/bin/switch-buffer";
      }
    );
  };
}
