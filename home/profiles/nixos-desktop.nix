{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.dms.homeModules.default

    ../ghostty.nix
    ../dms.nix
    ../spicetify.nix
    ../zathura.nix
    ../gaming.nix
    ../stylix.nix
  ];

  home.sessionVariables.NH_FLAKE = "$HOME/nixos-config";

  home.packages = with pkgs; [
    wl-clipboard
    xclip
  ];

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/niri/config.kdl";

  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/zed/settings.json";
}
