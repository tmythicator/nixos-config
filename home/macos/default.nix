{
  pkgs,
  user,
  config,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  flakeDir = "${homeDir}/Development/nixos-config";
in
{
  imports = [ ./../shared.nix ];

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
  };

  # Specific dependencies for macOS
  home.packages = with pkgs; [
    # Add macOS specific packages here
    go
    nodejs
    curl
    wget
    yt-dlp
  ];

  programs.zsh = {
    envExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = {
      update = "sudo nix run nix-darwin -- switch --flake ${flakeDir}#macos";
      upgrade = "nix flake update --flake ${flakeDir} && update";
    };

    initContent = ''
      mac-show() {
        ifconfig en0 | grep ether
      }
      mac-spoof() {
        local p=$(openssl rand -hex 1)
        local first_byte=$(printf '%02x' $((0x$p & 254 | 2)))
        local rest=$(openssl rand -hex 5 | sed 's/\(..\)/\1:/g;s/:$//')
        sudo ifconfig en0 ether $first_byte:$rest && mac-show
      }

      mac-reset() {
        sudo ifconfig en0 ether $(networksetup -getmacaddress en0 | awk '{print $3}') && mac-show
      }
    '';
  };

  programs.emacs.package = pkgs.emacs;
}
