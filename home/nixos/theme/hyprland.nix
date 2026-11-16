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

  mkHyprlandThemeLua = t:
    let
      parseBorder = s:
        let
          parts = lib.splitString " " s;
        in
        if lib.length parts >= 2 then
          let
            colors = lib.init parts;
            angleStr = lib.last parts;
            angle = if lib.hasSuffix "deg" angleStr then lib.removeSuffix "deg" angleStr else "45";
          in
          "{ colors = { " + lib.concatMapStringsSep ", " (c: "\"${c}\"") colors + " }, angle = ${angle} }"
        else
          "\"${s}\"";
    in
    ''
      hl.config({
        general = {
          col = {
            active_border = ${parseBorder t.hyprActiveBorder},
            inactive_border = "${t.hyprInactiveBorder}",
          },
        },
        decoration = {
          shadow = {
            color = "${t.hyprShadow}",
          },
        },
        group = {
          col = {
            border_active = "${t.hyprGroupBorderActive}",
            border_inactive = "${t.hyprGroupBorderInactive}",
          },
          groupbar = {
            text_color = "${t.hyprGroupText}",
            col = {
              active = "${t.hyprGroupActive}",
              inactive = "${t.hyprGroupInactive}",
            },
          },
        },
        misc = {
          background_color = "${t.hyprBackground}",
        },
      })
    '';
}
