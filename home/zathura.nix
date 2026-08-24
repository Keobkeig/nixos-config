{ config, pkgs, ... }:

{
  # Colors come from the catppuccin module (flavor=macchiato, accent=mauve in home/default.nix)
  # Themed by Stylix on Linux; catppuccin.enable is false there.

  programs.zathura = {
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = 1;
      scroll-page-aware = true;
      scroll-full-overlap = "0.01";
      scroll-step = 100;
      zoom-min = 10;
      guioptions = "none";
      font = "JetBrainsMono Nerd Font 10";
    };

    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      K = "zoom in";
      J = "zoom out";
      i = "recolor";
      p = "print";
    };
  };
}
