{ pkgs }:

{
  sharedUnix =
    (with pkgs; [
      gh
      docker-compose
      lazydocker

      eza
      tree
      ripgrep
      fd
      jq
      yq
      htop

      wget
      curl
      httpie

      neovim
      gcc
      cmake
      gnumake
      pkg-config

      unzip
      zip
      p7zip

      awscli2
      google-cloud-sdk

      yazi
      nh
      file
      watch

      python3
      python3Packages.pip
      uv
      rustup
      nodejs
      bun
      go
      jdk
      opam
      ocaml
      lua
      luarocks
      zig

      typescript-language-server
      vscode-langservers-extracted
      lua-language-server
      nil
      nixpkgs-fmt
      pyright
      ruff
      gopls
    ])
    ++ [
      # rustup exposes a rust-analyzer proxy. Prefer the standalone LSP while
      # retaining rustup as the Rust toolchain owner.
      (pkgs.lib.hiPrio pkgs.rust-analyzer)
    ];

  linux = with pkgs; [
    unrar
    which
    pciutils
    usbutils
    lsof
  ];

  darwin = with pkgs; [
    coreutils
    findutils
    gnugrep
    gnused
  ];

  headlessSecurity = with pkgs; [
    binwalk
    hexyl
    sherlock
    nmap
    tcpdump
    john
    hashcat
    gobuster
    ffuf
    radare2
  ];
}
