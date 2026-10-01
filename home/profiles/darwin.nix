{ config, ... }:

{
  imports = [
    ../ghostty.nix
  ];

  home.sessionVariables.NH_FLAKE = "$HOME/nixos-config";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";

  xdg.configFile."aerospace/aerospace.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/aerospace/aerospace.toml";
}
