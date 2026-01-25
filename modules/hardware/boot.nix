{ config, pkgs, ... }:

{
  # CachyOS kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Bootloader - systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS encryption
  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-LUKS-UUID";
    preLVM = true;
    allowDiscards = true;
  };

  # Kernel parameters
  boot.kernelParams = [
    "quiet"
    "splash"
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  # Plymouth for boot splash (optional)
  boot.plymouth.enable = true;
}
