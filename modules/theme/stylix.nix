{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  # One scheme drives GTK, Qt, cursors, fonts and supported apps -- the Omarchy
  # property, on a niri base. Replaces modules/theme/catppuccin.nix, which
  # applied theming by hand and set qt.style = "gtk2" (long dead, and not
  # actually applying against SDDM's Qt6).
  stylix = {
    enable = true;

    # An explicit scheme is deliberate: with base16Scheme unset, Stylix derives
    # the palette from the wallpaper via a Haskell genetic algorithm, which is a
    # derivation build during evaluation. Setting it keeps evaluation pure, so
    # this config can be evaluated from macOS with no Linux builder.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      package = pkgs.catppuccin-cursors.macchiatoDark;
      name = "catppuccin-macchiato-dark-cursors";
      size = 24;
    };
  };
}
