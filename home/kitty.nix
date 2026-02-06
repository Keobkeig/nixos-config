{ config, pkgs, ... }:

{
  # Install kitty without using programs.kitty settings (config is in dotfiles/)
  home.packages = [ pkgs.kitty ];

  # Symlink kitty config from dotfiles
  xdg.configFile."kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/kitty/kitty.conf";
}
