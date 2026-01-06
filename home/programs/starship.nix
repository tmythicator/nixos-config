{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$nodejs$aws$nix_shell$cmd_duration\n$character";

      directory = {
        style = "bold lavender";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = " ";
        style = "bold green";
      };
      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style) )";
      };
      nodejs = {
        symbol = " ";
        style = "bold yellow";
        format = "via [$symbol($version )]($style)";
      };
      aws = {
        symbol = "☁️  ";
        style = "bold orange";
      };
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state]($style) ";
        style = "bold blue";
      };
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "yellow";
      };
    };
  };
}
