{
  config,
  pkgs,
  lib,
  inputs,
  userConfig,
  ...
}:

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

  # nix-darwin's /etc/zshrc otherwise runs a full compinit, then bashcompinit,
  # then `promptinit && prompt suse` -- measured ~0.4s standalone, and the prompt
  # theme is discarded by powerlevel10k moments later. oh-my-zsh already runs
  # compinit (with -i, and its own dump) after $fpath is final, and init.zsh runs
  # bashcompinit itself for terraform, so nothing here is load-bearing.
  #
  # `enable` MUST stay true: it installs /etc/zshenv, which is what puts
  # /etc/profiles/per-user/$USER/bin on PATH.
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableBashCompletion = false;
    promptInit = "";
  };

  # Set once at install, then left alone — same contract as NixOS stateVersion.
  system.stateVersion = 7;
}
