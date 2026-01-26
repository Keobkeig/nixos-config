{ config, pkgs, ... }:

{
  # DankMaterialShell
  programs.dms = {
    enable = true;
    # DMS replaces: waybar, mako, fuzzel, swaylock, swayidle
  };
}
