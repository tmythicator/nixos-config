{ config, pkgs, ... }:
{
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    BUN_INSTALL = "${config.xdg.dataHome}/bun";

    CLJ_CONFIG = "${config.xdg.configHome}/clojure";
    CLJ_CACHE = "${config.xdg.cacheHome}/clojure";

    DOCKER_CONFIG = "${config.xdg.configHome}/docker";

    GNUPGHOME = "${config.xdg.dataHome}/gnupg";

    GOPATH = "${config.xdg.dataHome}/go";
  };
}
