{ pkgs, config, ... }:
let
  palette = import ../palette.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "graphical-session.target" ];
    };
    settings = {
      mainBar = {
        layer = "overlay";
        position = "top";
        height = 36;
        margin-top = 6;
        margin-left = 8;
        margin-right = 8;
        spacing = 6;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
          "mpris"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "cpu"
          "memory"
          "hyprland/language"
          "pulseaudio"
          "network"
          "custom/theme"
          "custom/swaync"
          "tray"
          "custom/power"
        ];

        "hyprland/language" = {
          format = "  {}";
          format-en = "EN";
          format-ru = "RU";
          format-de = "DE";
          keyboard-name = "by-tech-gaming-keyboard";
          on-click = "${pkgs.hyprland}/bin/hyprctl switchxkblayout all next";
        };

        "custom/theme" = {
          format = "{}";
          exec = "get-theme";
          interval = "once";
          signal = 8;
          return-type = "json";
          on-click = "toggle-theme";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/window" = {
          format = "-> {title}";
          max-length = 32;
          separate-outputs = true;
        };

        "cpu" = {
          format = "󰍛 {usage}%";
          interval = 2;
          tooltip = true;
        };

        "memory" = {
          format = "󰘚 {used:0.1f}G";
          interval = 3;
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G ({percentage}%)";
        };

        "mpris" = {
          format = "{player_icon} {title}";
          format-paused = "{status_icon} <i>{title}</i>";
          ignored-players = [
            "firefox"
            "chrome"
            "chromium"
            "tor-browser"
          ];
          player-icons = {
            default = "󰎈";
            tauonmb = "󰎈";
            vlc = "󰕼";
            mpv = "🎵";
          };
          status-icons = {
            paused = "󰏤";
          };
          tooltip-format = "Player: {player}\nArtist: {artist}\nAlbum: {album}\nTitle: {title}\n\n• Left Click: Play / Pause\n• Right Click: Next Track\n• Middle Click: Prev Track";
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          on-click-right = "${pkgs.playerctl}/bin/playerctl next";
          on-click-middle = "${pkgs.playerctl}/bin/playerctl previous";
          max-length = 30;
        };

        "clock" = {
          interval = 1;
          format = " {:%a, %d %b %Y   %H:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${palette.dark.accentPrimary}'><b>{}</b></span>";
              days = "<span color='${palette.dark.textMain}'><b>{}</b></span>";
              weeks = "<span color='${palette.dark.textMuted}'><b>W{}</b></span>";
              weekdays = "<span color='${palette.dark.accentSecondary}'><b>{}</b></span>";
              today = "<span color='${palette.dark.accentPrimary}'><b><u>{}</u></b></span>";
            };
          };
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "󰝟 MUTED";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰏲";
            car = "󰄋";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          scroll-step = 5;
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol -t 3";
          on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰤮 OFFLINE";
          tooltip-format = "Interface: {ifname}\nIP: {ipaddr}\nGateway: {gwaddr}";
          tooltip-format-wifi = "SSID: {essid} ({signalStrength}%)\nIP: {ipaddr}\nFrequency: {frequency}GHz";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          on-click-right = "${pkgs.gnome-control-center}/bin/gnome-control-center wifi";
        };

        "bluetooth" = {
          format = " {status}";
          format-connected = " {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected:\n{device_enumerate}";
          tooltip-format-enumerate-connected = "• {device_alias}\t{device_address}";
          on-click = "${pkgs.blueman}/bin/blueman-manager";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo}\nHealth: {health}%\nPower: {power}W";
        };

        "custom/swaync" = {
          tooltip = true;
          tooltip-format = "Quick Settings / Notifications";
          format = "{icon}";
          format-icons = {
            notification = "󱅫";
            none = "󰂚";
            dnd-notification = "󱅫";
            dnd-none = "󰂛";
            inhibited-notification = "󱅫";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "󱅫";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
        };

        "tray" = {
          icon-size = 16;
          spacing = 8;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = true;
          tooltip-format = "Quick Settings / Power Menu";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
        };
      };
    };

    style = ''
      @import url("${config.home.homeDirectory}/.config/waybar/theme.css");

      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background-color: @bar_bg;
        border: 2px solid @border_normal;
        border-radius: 4px;
        color: @text_main;
        box-shadow: 3px 3px 0px 0px @shadow_color;
      }

      #workspaces {
        margin: 3px 4px;
        padding: 0;
      }

      #workspaces button {
        padding: 2px 9px;
        margin: 0 2px;
        background-color: @card_bg;
        color: @text_muted;
        border: 2px solid @border_normal;
        border-radius: 4px;
        font-weight: 700;
        transition: all 0.15s ease;
      }

      #workspaces button:hover {
        background-color: @card_hover;
        color: @accent_primary;
        border-color: @border_active;
        box-shadow: 2px 2px 0px 0px @accent_primary;
      }

      #workspaces button.active {
        background-color: @active_btn_bg;
        color: @active_btn_text;
        font-weight: 900;
        border-color: @border_active;
        box-shadow: 2px 2px 0px 0px @active_btn_shadow;
      }

      #workspaces button.urgent {
        background-color: @accent_danger;
        color: @active_btn_text;
        border-color: @accent_danger;
        box-shadow: 2px 2px 0px 0px @shadow_color;
      }

      #window {
        background-color: @card_bg;
        border: 2px solid @border_normal;
        border-radius: 4px;
        padding: 2px 10px;
        margin: 3px 4px;
        color: @text_main;
        font-weight: 700;
      }

      #clock,
      #cpu,
      #memory,
      #mpris,
      #language,
      #pulseaudio,
      #network,
      #custom-theme,
      #custom-swaync,
      #tray,
      #custom-power {
        background-color: @card_bg;
        border: 2px solid @border_normal;
        border-radius: 4px;
        padding: 2px 10px;
        margin: 3px 2px;
        color: @text_main;
        font-weight: 700;
        transition: all 0.15s ease;
      }

      #cpu:hover,
      #memory:hover,
      #mpris:hover,
      #pulseaudio:hover,
      #network:hover {
        background-color: @card_hover;
        border-color: @accent_primary;
        color: @accent_primary;
        box-shadow: 2px 2px 0px 0px @accent_primary;
      }

      #language {
        color: @accent_primary;
        font-weight: 800;
      }

      #language:hover {
        border-color: @accent_primary;
        box-shadow: 2px 2px 0px 0px @accent_primary;
      }

      #custom-theme {
        color: @accent_warning;
        font-weight: 800;
        padding: 2px 8px;
      }

      #custom-theme:hover {
        border-color: @accent_warning;
        box-shadow: 2px 2px 0px 0px @accent_warning;
      }

      #clock {
        color: @text_main;
        border-color: @border_normal;
      }

      #clock:hover {
        border-color: @accent_primary;
        color: @accent_primary;
        box-shadow: 2px 2px 0px 0px @accent_primary;
      }

      #pulseaudio:hover,
      #network:hover,
      #bluetooth:hover,
      #battery:hover {
        background-color: @card_hover;
        border-color: @accent_primary;
        color: @accent_primary;
        box-shadow: 2px 2px 0px 0px @accent_primary;
      }

      #pulseaudio.muted {
        color: @text_muted;
        border-color: @border_normal;
      }

      #network.disconnected {
        color: @accent_danger;
        border-color: @accent_danger;
      }

      #battery.charging, #battery.plugged {
        color: @accent_success;
        border-color: @accent_success;
      }

      #battery.warning:not(.charging) {
        color: @accent_warning;
        border-color: @accent_warning;
      }

      #battery.critical:not(.charging) {
        background-color: @accent_danger;
        color: @active_btn_text;
        border-color: @accent_danger;
        box-shadow: 2px 2px 0px 0px @shadow_color;
      }

      #custom-swaync {
        color: @accent_secondary;
        font-size: 13px;
        padding: 2px 8px;
        border-color: @border_normal;
      }

      #custom-swaync:hover {
        border-color: @accent_secondary;
        box-shadow: 2px 2px 0px 0px @accent_secondary;
      }

      #custom-power {
        color: @accent_danger;
        font-size: 13px;
        padding: 2px 9px;
        margin-right: 4px;
        border-color: @border_normal;
      }

      #custom-power:hover {
        background-color: @accent_danger;
        color: #000000;
        border-color: @accent_danger;
        box-shadow: 2px 2px 0px 0px @accent_danger;
      }

      #tray {
        padding: 2px 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: @accent_danger;
      }

      tooltip {
        background: @bar_bg;
        border: 2px solid @accent_primary;
        border-radius: 4px;
        box-shadow: 4px 4px 0px 0px @shadow_color;
      }

      tooltip label {
        color: @text_main;
        padding: 6px;
        font-family: "JetBrainsMono Nerd Font", monospace;
      }
    '';
  };
}
