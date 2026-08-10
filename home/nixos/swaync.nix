{ pkgs, config, ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 6;
      control-center-margin-bottom = 6;
      control-center-margin-right = 8;
      control-center-margin-left = 0;
      notification-2nd-image-size = 32;
      notification-2nd-image-custom-shape = "round";
      control-center-width = 380;
      control-center-height = 680;
      fit-to-screen = true;
      notification-window-width = 350;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 150;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "title"
        "dnd"
        "mpris"
        "volume"
        "backlight"
        "buttons-grid"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "󰍜 QUICK SETTINGS";
          clear-all-button = true;
          button-text = "󰆴 CLEAR ALL";
        };
        dnd = {
          text = "󰂛 DO NOT DISTURB";
        };
        mpris = {
          image-size = 64;
          image-radius = 4;
        };
        volume = {
          label = "󰕾";
          show-per-app = true;
        };
        backlight = {
          label = "󰃟";
        };
        buttons-grid = {
          actions = [
            {
              label = "󰤨  WI-FI";
              type = "normal";
              command = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            }
            {
              label = "󰂯  BLUETOOTH";
              type = "normal";
              command = "${pkgs.blueman}/bin/blueman-manager";
            }
            {
              label = "󰓃  MIXER";
              type = "normal";
              command = "${pkgs.pavucontrol}/bin/pavucontrol";
            }
            {
              label = "󰍬  MIC MUTE";
              type = "normal";
              command = "toggle-mic";
            }
            {
              label = "󱎖  THEME";
              type = "normal";
              command = "toggle-theme";
            }
            {
              label = "󰒓  SETTINGS";
              type = "normal";
              command = "gnome-settings";
            }
            {
              label = "󰌾  LOCK";
              type = "normal";
              command = "${pkgs.hyprlock}/bin/hyprlock";
            }
            {
              label = "󰐥  POWER";
              type = "normal";
              command = "systemctl poweroff";
            }
          ];
        };
      };
    };

    style = ''
      @import url("${config.home.homeDirectory}/.config/swaync/theme.css");

      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 12px;
        color: @text_main;
      }

      .control-center {
        background: @bar_bg;
        border: 2px solid @border_normal;
        border-radius: 4px;
        box-shadow: 6px 6px 0px 0px @shadow_color;
        padding: 10px;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
        color: @text_muted;
        font-weight: 700;
        text-transform: uppercase;
      }

      .widget-title {
        color: @accent_cyan;
        font-weight: 800;
        font-size: 13px;
        margin: 6px;
        letter-spacing: 0.05em;
      }

      .widget-title > button {
        background: @card_bg;
        color: @accent_fuchsia;
        border: 2px solid @accent_fuchsia;
        border-radius: 4px;
        padding: 3px 8px;
        font-weight: 800;
        font-size: 11px;
        box-shadow: 2px 2px 0px 0px @shadow_color;
        transition: all 0.15s ease;
      }

      .widget-title > button:hover {
        background: @accent_fuchsia;
        color: @active_btn_text;
        box-shadow: 2px 2px 0px 0px @accent_fuchsia;
      }

      .widget-dnd {
        background: @card_bg;
        border: 2px solid @border_normal;
        border-radius: 4px;
        margin: 6px;
        padding: 6px 12px;
        font-weight: 700;
      }

      .widget-dnd > switch {
        border-radius: 2px;
        background: @card_hover;
        border: 1px solid @border_normal;
      }

      .widget-dnd > switch:checked {
        background: @accent_cyan;
        border-color: @accent_cyan;
      }

      .widget-mpris {
        background: @card_bg;
        border: 2px solid @border_normal;
        box-shadow: 3px 3px 0px 0px @shadow_color;
        border-radius: 4px;
        padding: 8px;
        margin: 6px;
      }

      .widget-mpris-title {
        font-weight: 800;
        color: @accent_cyan;
      }

      .widget-mpris-subtitle {
        color: @text_muted;
      }

      .widget-volume,
      .widget-backlight {
        background: @card_bg;
        border: 2px solid @border_normal;
        box-shadow: 2px 2px 0px 0px @shadow_color;
        border-radius: 4px;
        padding: 8px 12px;
        margin: 6px;
        font-weight: 700;
      }

      .widget-volume > trough > highlight,
      .widget-backlight > trough > highlight {
        background: @accent_cyan;
        border-radius: 2px;
      }

      .widget-buttons-grid {
        background: transparent;
        margin: 6px;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button {
        background: @card_bg;
        border: 2px solid @border_normal;
        box-shadow: 3px 3px 0px 0px @shadow_color;
        border-radius: 4px;
        padding: 8px 10px;
        margin: 3px;
        font-weight: 700;
        letter-spacing: 0.03em;
        transition: all 0.15s ease;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button:hover {
        background: @card_hover;
        border-color: @accent_cyan;
        color: @accent_cyan;
        box-shadow: 2px 2px 0px 0px @accent_cyan;
      }

      .notification-row {
        outline: none;
        margin: 6px;
        padding: 0;
      }

      .notification {
        background: @card_bg;
        border: 2px solid @border_normal;
        box-shadow: 4px 4px 0px 0px @shadow_color;
        border-radius: 4px;
        padding: 10px;
        transition: all 0.15s ease;
      }

      .notification:hover {
        border-color: @accent_cyan;
        box-shadow: 3px 3px 0px 0px @accent_cyan;
      }

      .notification-content {
        margin: 4px;
      }

      .summary {
        font-weight: 800;
        color: @accent_cyan;
        font-size: 13px;
      }

      .time {
        color: @text_muted;
        font-size: 11px;
        font-weight: 700;
      }

      .body {
        color: @text_main;
        margin-top: 4px;
      }

      .close-button {
        background: @card_bg;
        border: 2px solid @border_normal;
        border-radius: 2px;
        color: @text_main;
        padding: 2px;
      }

      .close-button:hover {
        background: @accent_red;
        border-color: @accent_red;
        color: @active_btn_text;
      }
    '';
  };
}
