{ config, pkgs, inputs, userConfig, ... }:

{
  imports = [
    # Generated per-machine on first install; gitignored.
    # Run `nixos-generate-config --root /mnt` and copy here on a fresh box.
    ./hardware-configuration.nix

    # Hardware
    ../../modules/hardware/boot.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix

    # Desktop
    ../../modules/desktop/niri.nix
    ../../modules/desktop/sddm.nix
    ../../modules/desktop/xdg.nix

    # Packages
    ../../modules/packages/cli.nix
    ../../modules/packages/languages.nix
    ../../modules/packages/security.nix
    ../../modules/packages/gui.nix

    # Services
    ../../modules/services/networking.nix
    ../../modules/services/docker.nix
    ../../modules/services/polkit.nix
    ../../modules/services/keyring.nix

    # Theme
    ../../modules/theme/catppuccin.nix
  ];

  # Hostname
  networking.hostName = "workstation";

  # Timezone and locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # User account
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.username;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "video" ];
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide (matches users.users.<user>.shell; HM owns the config)
  programs.zsh.enable = true;

  # SSD trim, swap-in-RAM, /tmp cleanup, firmware updates
  services.fstrim.enable = true;
  zramSwap.enable = true;
  boot.tmp.cleanOnBoot = true;
  services.fwupd.enable = true;

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://xddxdd.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # System state version
  system.stateVersion = "24.11";
}
