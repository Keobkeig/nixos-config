{ config, pkgs, ... }:

{
  # CachyOS kernel.
  # The overlay exposes these under `cachyosKernels`, NOT as
  # `pkgs.linuxPackages_cachyos` -- that attribute has never existed, so the
  # previous value could not evaluate.
  #
  # BORE is CachyOS's own default scheduler and suits a desktop/gaming box.
  # If the proprietary nvidia driver ever lags a bleeding-edge kernel, switch to
  # "linuxPackages-cachyos-lts". Perf variants exist too
  # (e.g. -x86_64-v3, -zen4) if you want to target this CPU specifically.
  boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-bore";

  # Bootloader - systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # NOTE: LUKS device UUIDs are machine-specific and live in the host's
  # hardware-configuration.nix, not here.

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
