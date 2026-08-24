{
  config,
  pkgs,
  inputs,
  ...
}:

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

    # Zen Browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  # GVFS for Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
