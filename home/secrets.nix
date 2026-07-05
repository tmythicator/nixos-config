{ config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  sopsKeyFile = "${homeDir}/.config/sops/age/keys.txt";
in
{
  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = sopsKeyFile;
  };

  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = sopsKeyFile;

    secrets.git_name = { };
    secrets.git_email = { };

    templates."git-user.inc" = {
      content = ''
        [user]
        name = ${config.sops.placeholder.git_name}
        email = ${config.sops.placeholder.git_email}
      '';
      path = "${homeDir}/.config/git/user.inc";
    };
  };
}
