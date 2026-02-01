{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
      env.TERM = "xterm-256color";

      window = {
        dimensions = {
          columns = 120;
          lines = 35;
        };
        padding = {
          x = 10;
          y = 10;
        };
        opacity = 0.95;
        decorations = "none";
        dynamic_title = true;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        size = 13.0;
      };

      colors = {
        primary = {
          background = "#24283b";
          foreground = "#c0caf5";
        };
        normal = {
          black = "#1d202f";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };
        bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
        };
      };

      keyboard.bindings = [
        {
          key = "W";
          mods = "Alt";
          action = "Copy";
        }
        {
          key = "Y";
          mods = "Control";
          action = "Paste";
        }
      ];
    };
  };
}
