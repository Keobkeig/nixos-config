{ config, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
      fullAppDisplay
      keyboardShortcut
      loopyLoop
      playlistIcons
      volumePercentage
    ];

    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
      marketplace
    ];
  };
}
