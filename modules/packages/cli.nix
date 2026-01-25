{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Version control
    git
    gh
    lazygit
    delta

    # Container tools
    docker-compose
    lazydocker

    # Terminal multiplexer
    tmux

    # Shell utilities
    fzf
    eza
    tree
    bat
    ripgrep
    fd
    jq
    yq

    # System monitoring
    btop
    htop
    fastfetch

    # Network utilities
    wget
    curl
    httpie

    # Editors
    neovim

    # Build tools
    cmake
    gcc
    gnumake
    pkg-config

    # Archive tools
    unzip
    zip
    p7zip
    unrar

    # Cloud
    awscli2

    # Misc
    file
    which
    pciutils
    usbutils
    lsof
  ];
}
