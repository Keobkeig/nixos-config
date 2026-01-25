# NixOS Configuration

A reproducible NixOS configuration using Flakes + Home Manager with niri window manager, DankMaterialShell, CachyOS kernel, and Catppuccin theming.

## Features

- **Window Manager**: niri (Wayland scrolling compositor)
- **Desktop Shell**: DankMaterialShell (replaces waybar, mako, fuzzel, swaylock, swayidle)
- **Kernel**: CachyOS patches for performance
- **Theme**: Catppuccin Mocha throughout
- **Shell**: Fish + Starship + Tmux
- **Editor**: Neovim (symlinked config for mutability)

## Fresh Install

### 1. Partition the Disk

Boot NixOS minimal ISO and partition:

```bash
# Create partitions
gdisk /dev/nvme0n1
# p1: 512MB EFI (type EF00)
# p2: rest for LUKS (type 8300)

# Format EFI
mkfs.fat -F 32 /dev/nvme0n1p1

# Setup LUKS
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptroot
```

### 2. Create Btrfs Subvolumes

```bash
mkfs.btrfs /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
umount /mnt
```

### 3. Mount Everything

```bash
mount -o subvol=@,compress=zstd,noatime /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,nix,var/log,boot}
mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix
mount -o subvol=@log,compress=zstd,noatime /dev/mapper/cryptroot /mnt/var/log
mount /dev/nvme0n1p1 /mnt/boot
```

### 4. Generate Hardware Config

```bash
nixos-generate-config --root /mnt
# Copy /mnt/etc/nixos/hardware-configuration.nix to repo
```

### 5. Clone and Install

```bash
mkdir -p /mnt/home/rxue
git clone <repo-url> /mnt/home/rxue/nixos-config
cd /mnt/home/rxue/nixos-config

# Update hardware-configuration.nix with generated one
# Update boot.nix LUKS UUID
# Update hosts/workstation/hardware-configuration.nix UUIDs

nixos-install --flake .#workstation
```

### 6. Post-Install

```bash
# After reboot and login
rustup default stable
opam init
```

## Day-to-Day Usage

### Rebuild System

```bash
# Full rebuild
sudo nixos-rebuild switch --flake ~/nixos-config#workstation

# Test without making permanent
sudo nixos-rebuild test --flake ~/nixos-config#workstation

# Build only (check for errors)
sudo nixos-rebuild build --flake ~/nixos-config#workstation
```

### Update Packages

```bash
# Update all inputs
cd ~/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#workstation

# Update specific input
nix flake update nixpkgs
```

### Rollback

```bash
# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or select from boot menu
```

### Garbage Collection

```bash
# Manual cleanup
sudo nix-collect-garbage --delete-older-than 14d

# Automatic: configured weekly in hosts/workstation/default.nix
```

## Adding Packages

Edit the appropriate module:

- **CLI tools**: `modules/packages/cli.nix`
- **Languages**: `modules/packages/languages.nix`
- **Security tools**: `modules/packages/security.nix`
- **GUI apps**: `modules/packages/gui.nix`
- **User packages**: `home/default.nix`

Then rebuild:

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#workstation
```

## Editing Neovim Config

The neovim config is symlinked from `dotfiles/nvim/` for mutability. Edit directly without rebuilding:

```bash
nvim ~/nixos-config/dotfiles/nvim/lua/rxue/plugins/...
```

## Editing Niri Config

Similarly, niri config is symlinked:

```bash
nvim ~/nixos-config/dotfiles/niri/config.kdl
```

## Keybindings (Niri)

| Key | Action |
|-----|--------|
| `Mod+Return` | Terminal (Kitty) |
| `Mod+D` | App launcher (DMS) |
| `Mod+E` | File manager (Thunar) |
| `Mod+B` | Browser (Zen) |
| `Mod+Q` | Close window |
| `Mod+H/J/K/L` | Focus left/down/up/right |
| `Mod+Shift+H/J/K/L` | Move window |
| `Mod+1-9` | Switch workspace |
| `Mod+Shift+1-9` | Move to workspace |
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Fullscreen |
| `Print` | Screenshot (selection) |
| `Mod+Shift+E` | Quit niri |

## Verification Checklist

After fresh install:

1. [ ] Boot into SDDM with Catppuccin theme
2. [ ] Login → niri starts → DMS panel visible
3. [ ] Open Kitty → fish + starship prompt
4. [ ] Run `fastfetch` → CachyOS kernel
5. [ ] Run `nvidia-smi` → GPU detected
6. [ ] Open neovim → plugins load
7. [ ] `pactl list sinks` → PipeWire working
8. [ ] DMS launcher works
9. [ ] Screenshot → grim+slurp+satty
10. [ ] Steam launches
