{ ... }:
{
  programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/user.inc"; }
    ];
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
