{ pkgs, config, ... }:
{
  systemd.user.services.org-sync = {
    Unit = {
      Description = "Sync Org files with Google Drive";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.rclone}/bin/rclone bisync ${config.home.homeDirectory}/Org gcloud:Org --verbose";
    };
  };

  systemd.user.timers.org-sync = {
    Unit = { Description = "Run org-sync timer"; };
    Timer = {
      OnBootSec = "3m";
      OnUnitActiveSec = "10m";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
