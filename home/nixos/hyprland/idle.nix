{ pkgs }:
{
  enable = true;
  settings = {
    general = {
      lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch \"hl.dsp.exec_raw('dpms on')\"";
    };

    listener = [
      {
        timeout = 300;
        on_timeout = "${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 600;
        on_timeout = "${pkgs.hyprland}/bin/hyprctl dispatch \"hl.dsp.exec_raw('dpms off')\"";
        on_resume = "${pkgs.hyprland}/bin/hyprctl dispatch \"hl.dsp.exec_raw('dpms on')\"";
      }
    ];
  };
}
