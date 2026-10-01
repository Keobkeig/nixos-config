# Windows YASB and GlazeWM Setup

This directory recreates the current Catppuccin Macchiato Windows shell:

- YASB as the only desktop bar
- GlazeWM with five workspaces and Vim-style navigation
- AutoHotkey controller that keeps tiling off until explicitly enabled
- `Alt+,` YASB help popup with a clickable tiling toggle
- Catppuccin Macchiato styling and the wallpaper gallery
- Edge app-mode shortcuts for Outlook, Outlook Calendar, and Teams
- Optional Microsoft 365 Stylus userstyle

Zebar is intentionally not included. Running YASB and Zebar together creates
duplicate bars and work areas.

## Install

Open PowerShell 7 in the repository root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\windows\Install-WindowsSetup.ps1 -InstallPackages -ImportWindotsWallpapers
```

The installer:

1. Installs YASB, GlazeWM, and AutoHotkey through `winget`.
2. Backs up existing target configuration under
   `Documents\UnixLikeWindows-backups\<timestamp>\repo-restore`.
3. Expands the portable username placeholder into the current profile path.
4. Recreates YASB, GlazeWM, the tiling controller, startup entries, and the
   Microsoft web-app shortcuts.
5. Imports wallpapers directly from `ashish0kumar/windots` when requested.
6. Applies `doom-catppuccin-l3.png` when that wallpaper is available.
7. Auto-hides the Windows taskbar unless `-KeepTaskbarVisible` is supplied.

Without package or wallpaper installation:

```powershell
.\windows\Install-WindowsSetup.ps1
```

For a machine-replacement checklist, rollback commands, and post-restore
verification, see [`RESTORE.md`](RESTORE.md).

## Keybindings

| Key | Action |
| --- | --- |
| `Alt+,` | Open the YASB keyboard help popup |
| `Win+Ctrl+Shift+T` | Toggle GlazeWM on or off |
| `Alt+H/J/K/L` | Focus left/down/up/right |
| `Alt+Shift+H/J/K/L` | Move a window |
| `Alt+1` through `Alt+5` | Switch workspace |
| `Alt+Shift+1` through `Alt+Shift+5` | Move a window to a workspace |
| `Alt+Enter` | Open Windows Terminal |
| `Alt+Shift+Q` | Close the focused window |
| `Alt+Shift+Space` | Toggle floating mode |
| `Alt+F` | Toggle fullscreen |
| `Alt+R` | Enter resize mode |
| `H/J/K/L` in resize mode | Resize the focused window |
| `Esc`, `Enter`, or `R` in resize mode | Exit resize mode |
| `Alt+Shift+R` | Reload the GlazeWM configuration |

The controller starts at login, ensures YASB is running, and leaves GlazeWM
off. The same toggle action is available from the controller tray icon and the
YASB help popup.

## Layout

```text
windows/
├── Install-WindowsSetup.ps1
├── README.md
├── RESTORE.md
└── config/
    ├── glazewm/config.yaml
    ├── tiling/
    │   ├── TilingTrial.ahk
    │   └── Toggle-GlazeWM.ps1
    ├── yasb/
    │   ├── config.yaml.template
    │   ├── styles.css
    │   └── scripts/
    └── microsoft-web-macchiato/
```

## Optional Microsoft web styling

The installer copies the Stylus userstyle to:

```text
%USERPROFILE%\.config\microsoft-web-macchiato
```

Install Stylus in Edge, run `Serve-UserStyle.ps1`, and install
`microsoft-365-macchiato.user.css` through Stylus. Teams web supports this
style. Native new Outlook (`olk.exe`) cannot receive browser CSS; use the
generated `Outlook (Macchiato)` Edge shortcut for the web wrapper.

## Tested versions

The exported setup was verified on October 1, 2026 with:

- YASB `2.0.7`
- GlazeWM `3.10.1`
- AutoHotkey `2.0.28`
- Catppuccin Macchiato and JetBrainsMono NF

The repository does not contain third-party windots wallpapers. The installer
fetches them from their upstream repository only when
`-ImportWindotsWallpapers` is provided.
