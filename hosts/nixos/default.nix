{
  config,
  pkgs,
  lib,
  inputs,
  user,
  ...
}:
let
  home = "/home/${user}";
in
{
  imports = [
    ./hardware-configuration.nix
    ../system-shared.nix
    ./nvidia.nix
    ./desktop.nix
    ./audio.nix
    ./services.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  # Bootloader
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel setup
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "kvm-amd" ];

  # Hardware tweaks
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.keyboard.qmk.enable = true;
  services.fstrim.enable = true;

  # Network / Host
  networking = {
    hostName = "sff-icient";
    networkmanager.enable = true;

    # Syncthing ports
    firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };
  };

  # Time / Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console / Keyboard
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us,de,ru";
    variant = "";
    options = "ctrl:nocaps,grp:win_space_toggle";
  };

  # Sops System Config
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    secrets.guest_password = {
      neededForUsers = true;
    };
  };

  # User config
  users.users.${user} = {
    isNormalUser = true;
    description = "Dev User";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  users.users.guest = {
    isNormalUser = true;
    description = "Guest User";
    uid = 2000;
    hashedPasswordFile = config.sops.secrets.guest_password.path;
    extraGroups = [
      "networkmanager"
      "audio"
      "video"
    ];
    packages = with pkgs; [
      firefox
    ];
  };

  fileSystems."/home/guest" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=8G"
      "mode=700"
      "uid=2000"
      "gid=100"
    ];
  };

  # Security
  services.openssh.settings.DenyUsers = [ "guest" ];
  security.sudo.execWheelOnly = true;

  # Nix settings
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # For dev tools that need to link against system libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  # GC weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    nano
    wget
    git
    curl

    wl-clipboard
    home-manager

    sops
    age

    python3
  ];

  # Random encrypted swap
  swapDevices = lib.mkForce [
    {
      device = "/dev/disk/by-partuuid/b6a36ff0-d239-4e4f-91ad-b80be70ebae6";
      randomEncryption.enable = true;
    }
  ];

  system.stateVersion = "25.11";
}
