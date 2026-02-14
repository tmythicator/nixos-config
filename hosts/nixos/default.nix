{
  config,
  pkgs,
  inputs,
  user,
  wp-pkgs,
  ...
}:
let
  home = "/home/${user}";
in
{
  imports = [
    ./hardware-configuration.nix
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
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" ];

  # LUKS
  boot.initrd.luks.devices."luks-bd45f143-16fe-4860-ada1-c4ec34c7ac11".device =
    "/dev/disk/by-uuid/bd45f143-16fe-4860-ada1-c4ec34c7ac11";

  # Hardware tweaks
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.fstrim.enable = true;

  # No power saving for audio card
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';

  # Network & Host
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

  # Time & Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console & Keyboard
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us,de,ru";
    variant = "";
    options = "ctrl:nocaps";
  };

  # Graphics
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaPersistenced = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # DE
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    totem
    yelp
    gnome-terminal
    gnome-console
    gnome-maps
    gnome-contacts
    gnome-music
    gnome-characters
    gnome-font-viewer
    simple-scan
    gnome-software
  ];

  # Docker
  virtualisation.docker.enable = true;

  # Tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # AI agents
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "ministral-3:14b"
    ];
  };

  services.syncthing = {
    enable = true;
    user = user;
    group = "users";
    dataDir = "${home}/.local/share/syncthing";
    configDir = "${home}/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui.address = "127.0.0.1:8384";
      devices."pixelham".id = "VJQXYD7-LDRUYNP-WSOTK23-BIXABFW-6WHQVDG-K2DRMU3-ALGSCST-PJ3KAQN";
      folders."Music" = {
        id = "670vb-wo9ti";
        path = "${home}/Music";
        devices = [ "pixelham" ];
        ignorePatterns = [
          ".DS_Store"
          "thumbs.db"
          ".stfolder"
          "(?d).thumbnails"
          "*.tmp"
        ];
      };
    };
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
  programs.zsh.enable = true;

  # Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
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
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      wireplumber = wp-pkgs.wireplumber;
    })
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
    # Tor
    tor-browser
    nyx
  ];

  system.stateVersion = "25.11";
}
