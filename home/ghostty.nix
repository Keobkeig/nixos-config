{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Installed by Nix on Linux. On macOS this is the hand-installed Ghostty.app --
  # nixpkgs' darwin build is not the official one -- so there we manage only the
  # config. Same config file drives both.
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.ghostty ];

  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/ghostty/config";
}
