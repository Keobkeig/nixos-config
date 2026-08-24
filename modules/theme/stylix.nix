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

    # A wallpaper was never set. Generated from the palette rather than shipping a
    # binary asset: solid Macchiato base (#24273a) at the panel's native
    # 2560x1440. Because base16Scheme is set above, Stylix uses this purely as a
    # wallpaper and does not derive colours from it, so no genetic-algorithm
    # build runs during evaluation. Swap in a real image any time.
    image = pkgs.runCommand "wallpaper-macchiato.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
      magick -size 2560x1440 xc:'#24273a' "$out"
    '';

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
