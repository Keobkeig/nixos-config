{ config, pkgs, ... }:

{
  # Enable graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use open source kernel module (required for RTX 5070/Blackwell)
    open = true;

    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Power management
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable nvidia-settings
    nvidiaSettings = true;
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
}
