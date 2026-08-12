{ pkgs, lib, ... }:
let
  palette = import ../palette.nix;
  stripHash = c: lib.removePrefix "#" c;

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
      ${pkgs.alacritty}/bin/alacritty &
    else
      ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg togglesplit
    fi
  '';

  splitRight = pkgs.writeShellScriptBin "hypr-split-right" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch fullscreen 0
    COUNT=$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.windows // 0')
    if [ "$COUNT" -le 1 ]; then
      ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg "preselect r"
      ${pkgs.alacritty}/bin/alacritty &
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
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      background = [
        {
          monitor = "";
          color = "rgb(${stripHash palette.dark.barBg})";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "320, 50";
          outline_thickness = 2;
          dots_size = 0.22;
          dots_spacing = 0.25;
          dots_center = true;
          dots_rounding = 2;
          outer_color = "rgb(${stripHash palette.dark.borderNormal})";
          inner_color = "rgb(${stripHash palette.dark.cardBg})";
          font_color = "rgb(${stripHash palette.dark.textMain})";
          font_family = "JetBrainsMono Nerd Font";
          fade_on_empty = false;
          placeholder_text = "<span font_family=\"JetBrainsMono Nerd Font\" foreground=\"#${palette.dark.textMuted}\">ENTER PASSWORD...</span>";
          hide_input = false;
          check_color = "rgb(${stripHash palette.dark.accentPrimary})";
          fail_color = "rgb(${stripHash palette.dark.accentRed})";
          fail_text = "<span font_family=\"JetBrainsMono Nerd Font\" foreground=\"#${palette.dark.accentRed}\">AUTH FAILED ($ATTEMPTS)</span>";
          capslock_color = "rgb(${stripHash palette.dark.accentYellow})";
          position = "0, -80";
          halign = "center";
          valign = "center";
          rounding = 4;
        }
      ];

      label = [
        # Status Badge
        {
          monitor = "";
          text = "󰌾 LOCKED";
          color = "rgb(${stripHash palette.dark.accentPrimary})";
          font_size = 14;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 140";
          halign = "center";
          valign = "center";
        }
        # Time Display
        {
          monitor = "";
          text = "$TIME";
          color = "rgb(${stripHash palette.dark.textMain})";
          font_size = 72;
          font_family = "JetBrainsMono Nerd Font ExtraBold";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
        # Date Display
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +'%A, %d %B %Y' | tr '[:lower:]' '[:upper:]')\"";
          color = "rgb(${stripHash palette.dark.textMuted})";
          font_size = 12;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, -10";
          halign = "center";
          valign = "center";
        }
        # Layout Badge
        {
          monitor = "";
          text = "  $LAYOUT[US,DE,RU]";
          color = "rgb(${stripHash palette.dark.accentPrimary})";
          font_size = 12;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, -135";
          halign = "center";
          valign = "center";
        }
        # User Tag
        {
          monitor = "";
          text = "USER: $USER";
          color = "rgb(${stripHash palette.dark.accentSecondary})";
          font_size = 11;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, -170";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.theme = null;
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
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
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    settings = {
      monitor = ",preferred,auto,1";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
      ];

      # Autostart essential services with palette background
      exec-once = [
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.swaybg}/bin/swaybg -c '${palette.dark.barBg}'"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
      ];

      # Keyboard & Mouse
      input = {
        kb_layout = "us,de,ru";
        kb_options = "ctrl:nocaps,grp:win_space_toggle";
        follow_mouse = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = palette.dark.hyprActiveBorder;
        "col.inactive_border" = palette.dark.hyprInactiveBorder;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 4;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
          color = palette.dark.hyprShadow;
        };
      };

      animations = {
        enabled = true;
        bezier = "snappy, 0.15, 0.9, 0.2, 1.0";
        animation = [
          "windows, 1, 2, snappy, popin 90%"
          "windowsOut, 1, 2, snappy, popin 90%"
          "border, 1, 3, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, snappy"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      group = {
        "col.border_active" = palette.dark.hyprGroupBorderActive;
        "col.border_inactive" = palette.dark.hyprGroupBorderInactive;
        groupbar = {
          font_family = "JetBrainsMono Nerd Font";
          font_size = 10;
          gradients = false;
          text_color = palette.dark.hyprGroupText;
          "col.active" = palette.dark.hyprGroupActive;
          "col.inactive" = palette.dark.hyprGroupInactive;
        };
      };

      cursor = {
        no_hardware_cursors = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        background_color = palette.dark.hyprBackground;
      };

      "$mod" = "SUPER";

      bind = [
        # Core Controls
        "$mod, P, exec, ${pkgs.fuzzel}/bin/fuzzel"
        "$mod, V, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel -d --prompt 'clip: ' | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mod, A, exec, ${pkgs.alacritty}/bin/alacritty"
        "$mod, E, exec, emacsclient -c -n"
        "$mod, 0, movetoworkspacesilent, special:minimized"
        "$mod, K, killactive"
        "$mod SHIFT, E, exit"

        # Lock Screen & Suspend
        "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "$mod SHIFT, L, exec, ${pkgs.systemd}/bin/systemctl suspend"

        # Toggle Waybar Visibility
        "$mod, BACKSLASH, exec, ${pkgs.procps}/bin/pkill -SIGUSR1 waybar"

        # Toggle Notification & Control Center (SwayNC)
        "$mod, C, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"

        # Toggle Dark / Light Theme
        "$mod SHIFT, T, exec, toggle-theme"

        # Screenshots
        "$mod, S, exec, ${screenshotRegion}/bin/screenshot-region"
        "$mod SHIFT, S, exec, ${screenshotFull}/bin/screenshot-full"
        ", Print, exec, ${screenshotRegion}/bin/screenshot-region"
        "SHIFT, Print, exec, ${screenshotFull}/bin/screenshot-full"

        # Ace-Window Swap
        "$mod SHIFT, O, exec, ${aceSwap}/bin/ace-swap"

        # Movement / Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, B, movefocus, l"
        "$mod, F, movefocus, r"
        "$mod, U, movefocus, u"
        "$mod, N, movefocus, d"
        "$mod, O, cyclenext"

        # Window Cycling
        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
        "ALT SHIFT, TAB, cyclenext, prev"
        "ALT SHIFT, TAB, bringactivetotop"
        "$mod, TAB, cyclenext"
        "$mod, TAB, bringactivetotop"
        "$mod SHIFT, TAB, cyclenext, prev"
        "$mod SHIFT, TAB, bringactivetotop"

        # Move active window within workspace
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
        "$mod SHIFT, B, movewindow, l"
        "$mod SHIFT, F, movewindow, r"
        "$mod SHIFT, U, movewindow, u"
        "$mod SHIFT, N, movewindow, d"

        # Swap active window with adjacent window
        "$mod CTRL, left, swapwindow, l"
        "$mod CTRL, right, swapwindow, r"
        "$mod CTRL, up, swapwindow, u"
        "$mod CTRL, down, swapwindow, d"
        "$mod CTRL, B, swapwindow, l"
        "$mod CTRL, F, swapwindow, r"
        "$mod CTRL, U, swapwindow, u"
        "$mod CTRL, N, swapwindow, d"

        # Window Tabs
        "$mod, G, togglegroup"
        "$mod, bracketleft, changegroupactive, b"
        "$mod, bracketright, changegroupactive, f"

        # Fullscreen
        "$mod, RETURN, fullscreen, 1"

        # Workspaces 1..9
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move window to workspace 1..9
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Silently send window to workspace 1..9
        "$mod CTRL, 1, movetoworkspacesilent, 1"
        "$mod CTRL, 2, movetoworkspacesilent, 2"
        "$mod CTRL, 3, movetoworkspacesilent, 3"
        "$mod CTRL, 4, movetoworkspacesilent, 4"
        "$mod CTRL, 5, movetoworkspacesilent, 5"
        "$mod CTRL, 6, movetoworkspacesilent, 6"
        "$mod CTRL, 7, movetoworkspacesilent, 7"
        "$mod CTRL, 8, movetoworkspacesilent, 8"
        "$mod CTRL, 9, movetoworkspacesilent, 9"

        # Emacs Chording Mode
        "$mod, X, submap, emacs_x"
      ];

      # Repeatable hardware keys
      bindel = [
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      ];

      # Non-repeatable hardware keys
      bindl = [
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, toggle-mic"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ];

      # Repeatable window resizing
      binde = [
        "$mod ALT, right, resizeactive, 40 0"
        "$mod ALT, left, resizeactive, -40 0"
        "$mod ALT, down, resizeactive, 0 40"
        "$mod ALT, up, resizeactive, 0 -40"
        "$mod ALT, F, resizeactive, 40 0"
        "$mod ALT, B, resizeactive, -40 0"
        "$mod ALT, N, resizeactive, 0 40"
        "$mod ALT, U, resizeactive, 0 -40"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };

    extraConfig = ''
      submap = emacs_x
      bind = , O, cyclenext
      bind = , O, submap, reset
      bind = , 0, movetoworkspacesilent, special:minimized
      bind = , 0, submap, reset
      bind = , 1, fullscreen, 1
      bind = , 1, submap, reset
      bind = , 2, exec, ${splitBelow}/bin/hypr-split-below
      bind = , 2, submap, reset
      bind = , 3, exec, ${splitRight}/bin/hypr-split-right
      bind = , 3, submap, reset
      bind = , K, killactive
      bind = , K, submap, reset
      bind = , B, exec, ${switchBuffer}/bin/switch-buffer
      bind = , B, submap, reset
      bind = , W, exec, ${pkgs.procps}/bin/pkill -SIGUSR1 waybar
      bind = , W, submap, reset
      bind = , N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw
      bind = , N, submap, reset
      bind = , T, togglegroup
      bind = , T, submap, reset
      bind = , C, exec, toggle-theme
      bind = , C, submap, reset
      bind = , S, exec, ${aceSwap}/bin/ace-swap
      bind = , S, submap, reset
      bind = , bracketleft, changegroupactive, b
      bind = , bracketright, changegroupactive, f
      bind = , G, submap, reset
      bind = , escape, submap, reset
      bind = $mod, X, submap, reset
      submap = reset
    '';
  };
}
