{ pkgs, user, ... }:
let
  home = "/home/${user}";
in
{
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Tor Daemon / Status Monitor
  services.tor = {
    enable = true;
    client.enable = true;
  };
  environment.systemPackages = [ pkgs.nyx ];

  # AI agents
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  # Syncthing
  services.syncthing = {
    enable = true;
    user = user;
    group = "users";
    dataDir = "${home}/.local/share/syncthing";
    configDir = "${home}/.config/syncthing";
  };
}
