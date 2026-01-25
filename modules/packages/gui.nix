{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Communication
    discord
    slack

    # Media
    mpv
    vlc
    spotify

    # Productivity
    libreoffice
    obsidian

    # PDF viewer
    zathura

    # File manager
    thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # Screenshots
    grim
    slurp
    satty

    # Audio control
    pavucontrol

    # Image viewer
    imv
    loupe

    # Code editors
    zed-editor

    # Gaming
    lutris
    protonup-qt

    # Zen Browser
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Gamemode for performance optimization
  programs.gamemode.enable = true;

  # Thunar plugins
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  # GVFS for Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
