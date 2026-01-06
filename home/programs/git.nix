{ ... }:
{
  programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/user.inc"; }
    ];
    settings = {
      init.defaultBranch = "main";
    };
  };
}
