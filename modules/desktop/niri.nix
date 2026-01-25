{ config, pkgs, ... }:

{
  # Enable niri window manager
  programs.niri.enable = true;

  # XWayland support via xwayland-satellite
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    wl-clipboard
    xdg-utils
  ];

  # Session environment
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
  };
}
