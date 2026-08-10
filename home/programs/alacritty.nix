{ pkgs, config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "${config.home.homeDirectory}/.config/alacritty/theme.toml"
      ];
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
