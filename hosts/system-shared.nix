{ pkgs, ... }:
{
  nix.settings = {
    auto-optimise-store = true;
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Automatic weekly garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  } // (if pkgs.stdenv.hostPlatform.isDarwin then {
    interval = [{ Weekday = 7; Hour = 3; Minute = 15; }];
  } else {
    dates = "weekly";
  });

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
}
