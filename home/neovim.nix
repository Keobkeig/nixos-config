{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  # Neovim is installed system-wide in modules/packages/cli.nix (on NixOS)
  # On macOS, install via: nix profile install nixpkgs#neovim
  # This module creates a symlink to the dotfiles config

  # Symlink neovim config (mutable, editable without rebuild)
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/nvim";
    recursive = false;
  };

  # Dependencies for neovim plugins
  home.packages = with pkgs; [
    # Neovim itself (for standalone HM on macOS)
    neovim

    # Telescope dependencies
    ripgrep
    fd

    # Treesitter compilation
    gcc

    # Mason might need these (though LSPs are provided via Nix)
    nodejs
    python3
    cargo
  ] ++ lib.optionals isLinux [
    # Clipboard support (Linux only)
    wl-clipboard
    xclip
  ];
}
