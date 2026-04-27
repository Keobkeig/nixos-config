{ config, pkgs, ... }:

{
  # SDDM Display Manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-macchiato";
    package = pkgs.kdePackages.sddm;
  };

  # SDDM theme packages
  environment.systemPackages = with pkgs; [
    (catppuccin-sddm.override {
      flavor = "macchiato";
      font = "Noto Sans";
      fontSize = "12";
      loginBackground = true;
    })
  ];

  # Fonts needed for SDDM
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
