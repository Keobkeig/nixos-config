{ config, pkgs, ... }:

{
  # NetworkManager
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # mDNS/DNS-SD
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
