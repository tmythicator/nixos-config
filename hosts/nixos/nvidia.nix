{ config, pkgs, ... }:
{
  # NVIDIA DRM kernel framebuffer and modesetting
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  # Video Drivers & Graphics acceleration
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

  # Fix NVIDIA freeze/deadlock on resume
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    FreezeUserSessions=no
  '';
}
