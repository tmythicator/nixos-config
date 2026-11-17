{ pkgs }:
let
  switchBuffer = pkgs.writeShellApplication {
    name = "switch-buffer";
    runtimeInputs = with pkgs; [
      hyprland
      jq
      fuzzel
      gawk
      coreutils
    ];
    text = builtins.readFile ./scripts/switch-buffer.sh;
  };

  hyprSplit = pkgs.writeShellApplication {
    name = "hypr-split";
    runtimeInputs = with pkgs; [
      hyprland
      jq
      ghostty
    ];
    text = builtins.readFile ./scripts/hypr-split.sh;
  };

  aceSwap = pkgs.writeShellApplication {
    name = "ace-swap";
    runtimeInputs = with pkgs; [
      hyprland
      jq
      fuzzel
      gawk
    ];
    text = builtins.readFile ./scripts/ace-swap.sh;
  };

  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      slurp
      grim
      wl-clipboard
      libnotify
      coreutils
    ];
    text = builtins.readFile ./scripts/screenshot.sh;
  };

  toggleMic = pkgs.writeShellApplication {
    name = "toggle-mic";
    runtimeInputs = with pkgs; [
      wireplumber
      gawk
      gnugrep
      coreutils
      libnotify
    ];
    text = builtins.readFile ./scripts/toggle-mic.sh;
  };
in
{
  inherit
    switchBuffer
    hyprSplit
    aceSwap
    screenshot
    toggleMic
    ;

  all = [
    switchBuffer
    hyprSplit
    aceSwap
    screenshot
    toggleMic
    pkgs.swaybg
    pkgs.grim
    pkgs.slurp
    pkgs.pavucontrol
    pkgs.networkmanagerapplet
    pkgs.blueman
    pkgs.gnome-control-center
  ];
}
