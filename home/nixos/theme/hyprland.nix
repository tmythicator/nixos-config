{ lib }:
let
  stripHash = c: lib.removePrefix "#" c;
in
{
  mkHyprlockSettings = t: {
    general = {
      disable_loading_bar = true;
      hide_cursor = true;
      grace = 0;
      no_fade_in = false;
    };

    background = [
      {
        monitor = "";
        color = "rgb(${stripHash t.barBg})";
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
        outer_color = "rgb(${stripHash t.borderNormal})";
        inner_color = "rgb(${stripHash t.cardBg})";
        font_color = "rgb(${stripHash t.textMain})";
        font_family = "JetBrainsMono Nerd Font";
        fade_on_empty = false;
        placeholder_text = "<span font_family=\"JetBrainsMono Nerd Font\" foreground=\"#${t.textMuted}\">ENTER PASSWORD...</span>";
        hide_input = false;
        check_color = "rgb(${stripHash t.accentPrimary})";
        fail_color = "rgb(${stripHash t.accentDanger})";
        fail_text = "<span font_family=\"JetBrainsMono Nerd Font\" foreground=\"#${t.accentDanger}\">AUTH FAILED ($ATTEMPTS)</span>";
        capslock_color = "rgb(${stripHash t.accentWarning})";
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
        color = "rgb(${stripHash t.accentPrimary})";
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
        color = "rgb(${stripHash t.textMain})";
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
        color = "rgb(${stripHash t.textMuted})";
        font_size = 12;
        font_family = "JetBrainsMono Nerd Font Bold";
        position = "0, -10";
        halign = "center";
        valign = "center";
      }
      # Layout Badge
      {
        monitor = "";
        text = "  $LAYOUT[EN,DE,RU]";
        color = "rgb(${stripHash t.accentPrimary})";
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
        color = "rgb(${stripHash t.accentSecondary})";
        font_size = 11;
        font_family = "JetBrainsMono Nerd Font Bold";
        position = "0, -170";
        halign = "center";
        valign = "center";
      }
    ];
  };

  mkHyprlandDecoration = t: {
    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      "col.active_border" = t.hyprActiveBorder;
      "col.inactive_border" = t.hyprInactiveBorder;
      layout = "dwindle";
    };

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
        color = t.hyprShadow;
      };
    };

    group = {
      "col.border_active" = t.hyprGroupBorderActive;
      "col.border_inactive" = t.hyprGroupBorderInactive;
      groupbar = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 10;
        gradients = false;
        text_color = t.hyprGroupText;
        "col.active" = t.hyprGroupActive;
        "col.inactive" = t.hyprGroupInactive;
      };
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      background_color = t.hyprBackground;
    };
  };
}
