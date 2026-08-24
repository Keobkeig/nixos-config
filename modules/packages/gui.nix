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
    mpv # vlc dropped: mpv is scriptable, lighter, better Wayland support
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

    # Image viewer (replaces imv + loupe: Wayland-native and keyboard-driven
    # like imv, but with the thumbnails/gallery loupe was kept for)
    swayimg

    # Code editors
    zed-editor
    vscode

    # File manager (GUI; yazi covers the terminal side)
    nautilus

    # Utilities
    localsend # AirDrop-style transfer between the Mac, Windows and this box
    xournalpp # PDF annotation
    bitwarden-desktop

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

  # GVFS (mounting, trash, network shares) and Tumbler (thumbnails) back
  # Nautilus, which replaced Thunar.
  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
