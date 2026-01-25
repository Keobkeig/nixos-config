{ config, pkgs, ... }:

{
  # XDG Portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
  };

  # Environment for portals
  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
