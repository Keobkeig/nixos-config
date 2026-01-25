{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Python
    python3
    python3Packages.pip
    uv

    # Rust (rustup for toolchain management)
    rustup

    # Node.js
    nodejs
    bun

    # Go
    go

    # Java
    jdk

    # OCaml
    opam
    ocaml

    # Lua
    lua
    luarocks

    # Zig
    zig

    # LSPs and formatters (for neovim)
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    lua-language-server
    nil  # Nix LSP
    nixpkgs-fmt
    pyright
    ruff
    gopls
    rust-analyzer
  ];

  # Environment variables for language tooling
  environment.sessionVariables = {
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
  };
}
