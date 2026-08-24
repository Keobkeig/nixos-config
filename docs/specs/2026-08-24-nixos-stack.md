# NixOS stack: consolidation and Omarchy-style coherence

**Status:** accepted, phased
**Date:** 2026-08-24

## Context

The workstation stack accumulated rather than being chosen. Concretely:

- **Two terminals, both half-wired.** `kitty` is Nix-installed on *both* hosts; `ghostty` is
  *never* installed by Nix — `home/ghostty.nix` only symlinks a config. So the Mac runs a
  hand-installed Ghostty.app against a Nix-managed config, and the workstation has a Ghostty
  config nothing reads, with kitty as the real terminal.
- **Redundant apps.** mpv + vlc, imv + loupe, Thunar in an otherwise GTK/Wayland-minimal setup.
- **Theming applied by hand** in several places, with a Qt/GTK mismatch (below).
- **A half-configured desktop:** niri and DMS are the right foundation, but monitors, idle/lock,
  keybinds and wallpaper aren't declaratively managed.
- **The config is unverifiable off-machine**, which is how three latent eval failures
  (commit `1b47898`) went unnoticed until they were found by accident.

The target is Omarchy's coherence — one theme driving everything, a curated app set, a
deliberate keybind layer — on a niri base rather than Hyprland.

**Constraint:** `omarchy-nix` is Hyprland-specific; its `nixosModules.default` configures
Hyprland directly and cannot be pointed at niri. We borrow the pattern, not the flake.

## Two latent bugs found during review

1. `modules/desktop/xdg.nix` sets `niri.default = [ "gnome" "gtk" ]`, but
   `xdg-desktop-portal-gnome` is not in `extraPortals` — that fallback cannot resolve.
2. `modules/theme/catppuccin.nix` sets `qt.platformTheme = "gtk2"` / `style = "gtk2"` while
   SDDM is Qt6 (`kdePackages.sddm`). The gtk2 Qt style is long dead; this is almost certainly
   not applying. Stylix supersedes it.

## Decisions

| Area | Decision |
|---|---|
| Terminal | Ghostty everywhere it exists; install it via Nix on Linux; drop kitty entirely |
| Windows | NixOS-WSL in Windows Terminal (Ghostty has no official Windows build) |
| WSL | Full NixOS-WSL as a third host sharing `home/`; accepts VS Code Remote workaround + `nix-ld` |
| Display manager | greetd + tuigreet, dropping SDDM (the only Qt/KDE dependency) |
| Desktop shell | Keep niri + DMS; fill the gaps rather than replace |
| Theming | Stylix on Linux, fixed Catppuccin Macchiato, no switcher. Mac keeps `lib/palette.nix` |
| niri config | Hybrid: monitors/input/stable keybinds in Nix, writable `.kdl` fragment for tuning |
| Placeholders | Restructure so `hardware-configuration.nix` and LUKS are optional |

### Apps

- **Remove:** kitty, vlc, imv, loupe, Thunar (+ xfce plugins)
- **Add:** ghostty, swayimg, nautilus, yazi, vscode, localsend, xournalpp, bitwarden
- **Keep:** zed + neovim (deliberate: GUI vs terminal), Zen, obsidian, libreoffice, zathura,
  discord, slack, spotify, and the full gaming stack (steam/gamescope/lutris/wine/mangohud)

Bitwarden is chosen over Omarchy's 1Password: in nixpkgs, cross-platform across all three
machines, not proprietary. Swappable.

### Theming supersedes an earlier decision

On 2026-08-23 we chose palette-only over Stylix. That was scoped to the Mac, where there is no
GTK/Qt layer. For the workstation, Stylix is the tool that produces the Omarchy effect and fixes
the Qt/GTK mismatch. Stylix also avoids import-from-derivation, which `catppuccin-nix` uses —
so adopting it may additionally unblock evaluating the Linux config from macOS.

## Phases

**Phase 0 — off-machine (no workstation access needed)**
Placeholder restructure so the config evaluates anywhere; the two latent bug fixes; terminal
swap; app add/remove. Verified by evaluation, activated later.

**Phase 1 — at the machine**
NixOS-WSL host. Note WSL lives on the Windows side of the *same* dual-boot box, so it is
gated on physical access exactly like the desktop work.

**Phase 2 — desktop coherence**
Stylix; greetd replacing SDDM; niri hybrid config; monitors, idle/lock/power, keybinds and
launcher, wallpaper.

## Verification

- Phase 0: `nix eval .#nixosConfigurations.workstation.config.system.build.toplevel.drvPath`
  must succeed from macOS. If `catppuccin-nix`'s IFD still blocks this, that is a finding —
  it means a Linux builder is required until Stylix replaces it in Phase 2.
- `nix build --no-link .#checks.aarch64-darwin.{formatting,darwin-system}` stays green.
- Phases 1–2: `nixos-rebuild build --flake .#workstation` on the machine before switching.

## Explicitly out of scope

- Switching to Hyprland to adopt omarchy-nix wholesale (would cost niri).
- A live theme switcher — fights Nix's model; fixed theme chosen instead.
- Dual-boot clock skew (`time.hardwareClockInLocalTime`) — not observed in practice.
