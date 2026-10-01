{ config, ... }:

{
  home.sessionVariables.NH_FLAKE = "path:${config.home.homeDirectory}/nixos-config";
}
