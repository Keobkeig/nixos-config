{ config, pkgs, lib, inputs, userConfig, ... }:

{
  # macOS host (richie-mpb).
  #
  # Minimal nix-darwin migration: this brings the Mac up to parity with
  # hosts/workstation structurally, but deliberately does NOT yet manage
  # system.defaults (dock, finder, keyboard) or Homebrew declaratively.
  # Those are the natural next step once this is proven.

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Determinate owns the Nix install and daemon, and nix-darwin wants to as
  # well. This is the supported opt-out (it replaces the older
  # `nix.enable = false`), and it is why `nix.*` options are unavailable on
  # this host — Determinate manages /etc/nix/nix.conf instead.
  determinateNix.enable = true;

  # Required for options that previously applied to whoever ran darwin-rebuild.
  system.primaryUser = userConfig.username;

  users.users.${userConfig.username} = {
    name = userConfig.username;
    home = "/Users/${userConfig.username}";
  };

  # Set once at install, then left alone — same contract as NixOS stateVersion.
  system.stateVersion = 7;
}
