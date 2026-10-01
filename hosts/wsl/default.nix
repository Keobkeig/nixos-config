{
  pkgs,
  userConfig,
  ...
}:

let
  packageSets = import ../../lib/package-sets.nix { inherit pkgs; };
in
{
  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

  networking.hostName = "nixos-wsl";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  wsl = {
    enable = true;
    defaultUser = userConfig.username;
    useWindowsDriver = true;
    wslConf.automount.options = "metadata,uid=1000,gid=100,umask=22,fmask=11";
  };

  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.username;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = packageSets.headlessSecurity;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  system.stateVersion = "26.05";
}
