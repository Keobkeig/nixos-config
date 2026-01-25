{ config, pkgs, ... }:

{
  # Docker daemon
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # Add docker group in hosts/workstation/default.nix via extraGroups
}
