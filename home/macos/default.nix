{
  pkgs,
  user,
  config,
  ...
}:
{
  imports = [
    ./../shared.nix
    ./aerospace.nix
  ];

  home = {
    username = user;
    homeDirectory = "/Users/${user}";
  };

  programs.zsh = {
    envExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = {
      update = "darwin-rebuild switch --flake ${config.home.homeDirectory}/Development/nixos-config#macos";
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
}
