# treefmt config, consumed by `nix fmt` and by the `formatting` flake check.
#
# Scoped to Nix only on purpose: pulling in stylua/prettier would reformat
# dotfiles/nvim and friends wholesale, which is churn without benefit here.
{ ... }:

{
  projectRootFile = "flake.nix";

  # nixfmt is the official Nix formatter (RFC 166). Replaces nixpkgs-fmt,
  # which this repo used previously.
  programs.nixfmt.enable = true;
}
