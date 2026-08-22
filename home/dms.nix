{ config, pkgs, ... }:

{
  # DankMaterialShell
  # Upstream renamed this option from programs.dms; homeModules.default was
  # likewise renamed from homeManagerModules.default (see home/default.nix).
  programs.dank-material-shell = {
    enable = true;
    # DMS replaces: waybar, mako, fuzzel, swaylock, swayidle
  };
}
