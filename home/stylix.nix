{ ... }:

{
  # Linux-only Stylix opt-outs. This file is imported only under isNixOS, because
  # the Stylix module is not present on macOS and these options would not exist.
  stylix.targets = {
    # lazygit keeps its writable out-of-store config (runtime `o` edits). Stylix
    # would set programs.lazygit.settings, which flips on Home Manager's own
    # managed config file and collides with ours -- the exact mechanism the
    # comment in home/git.nix describes.
    lazygit.enable = false;

    # Spotify keeps spicetify's purpose-built Catppuccin theme, which is a full
    # UI theme rather than Stylix's generic recolor. Same Macchiato palette, so
    # coherence is preserved.
    spicetify.enable = false;

    # fzf colours come from lib/palette.nix, shared with macOS so both machines
    # match. Stylix would set programs.fzf.defaultOptions and conflict.
    fzf.enable = false;
  };
}
