{ config, pkgs, ... }:
{
  # NVIDIA DRM kernel framebuffer
  boot.kernelParams = [ "nvidia_drm.fbdev=1" ];

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
}
