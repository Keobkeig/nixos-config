{ config, pkgs, ... }:

{
  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/ghostty/config";
}
