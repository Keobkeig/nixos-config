# Catppuccin Macchiato, the single source of truth for colors that Nix generates.
#
# Why this exists: the same hexes were hand-copied into several generated configs
# (herdr's [theme.custom], fzf's --color flags), so a palette tweak meant editing
# each one. Files that are deliberately writable-without-rebuild
# (dotfiles/zsh/p10k.zsh, dotfiles/tmux/tmux.local.conf, dotfiles/kitty) keep
# their own literals on purpose — they are not Nix's business.
#
# Not sourced from the catppuccin flake input: `catppuccin#palette` is a
# derivation, not an attrset, and the flake exposes no `lib` output, so reading it
# would mean import-from-derivation. A static attrset costs nothing to evaluate.
#
# Reference: https://github.com/catppuccin/catppuccin
{
  rosewater = "#f4dbd6";
  flamingo = "#f0c6c6";
  pink = "#f5bde6";
  mauve = "#c6a0f6";
  red = "#ed8796";
  maroon = "#ee99a0";
  peach = "#f5a97f";
  yellow = "#eed49f";
  green = "#a6da95";
  teal = "#8bd5ca";
  sky = "#91d7e3";
  sapphire = "#7dc4e4";
  blue = "#8aadf4";
  lavender = "#b7bdf8";
  text = "#cad3f5";
  subtext1 = "#b8c0e0";
  subtext0 = "#a5adcb";
  overlay2 = "#939ab7";
  overlay1 = "#8087a2";
  overlay0 = "#6e738d";
  surface2 = "#5b6078";
  surface1 = "#494d64";
  surface0 = "#363a4f";
  base = "#24273a";
  mantle = "#1e2030";
  crust = "#181926";
}
