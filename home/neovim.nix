{ config, pkgs, ... }:

{
  # Neovim is installed system-wide in modules/packages/cli.nix
  # This module creates a symlink to the dotfiles config

  # Symlink neovim config (mutable, editable without rebuild)
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/nvim";
    recursive = false;
  };

  # Dependencies for neovim plugins
  home.packages = with pkgs; [
    # Clipboard support
    wl-clipboard
    xclip

    # Telescope dependencies
    ripgrep
    fd

    # Treesitter compilation
    gcc

    # Mason might need these (though LSPs are provided via Nix)
    nodejs
    python3
    cargo
  ];
}
