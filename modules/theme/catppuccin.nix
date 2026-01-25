{ config, pkgs, ... }:

{
  # System-wide Catppuccin theming
  # SDDM theme is configured in modules/desktop/sddm.nix

  # GTK theme for system apps
  environment.systemPackages = with pkgs; [
    catppuccin-gtk
    catppuccin-cursors.mochaDark
    papirus-icon-theme
  ];

  # Qt theming
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };
}
