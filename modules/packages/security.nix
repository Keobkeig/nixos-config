{ pkgs, ... }:

let
  packageSets = import ../../lib/package-sets.nix { inherit pkgs; };
in
{
  environment.systemPackages =
    packageSets.headlessSecurity
    ++ (with pkgs; [
      wireshark
      ghidra
    ]);
}
