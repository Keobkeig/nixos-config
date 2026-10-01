# Windows Restore Note

Use this checklist to recreate the YASB and GlazeWM setup on another Windows
machine. This snapshot was last verified on October 1, 2026.

## Before restoring

1. Sign in to Windows with the account that should own the configuration.
2. Install Git and PowerShell 7.
3. Clone this repository to a normal writable folder.
4. Open PowerShell 7 in the repository root.
5. Confirm Windows Package Manager is available:

   ```powershell
   winget --version
   ```

JetBrainsMono NF is used by YASB. Install that Nerd Font before judging icon or
text alignment. Raycast, Zen Browser, VS Code, Zed, Edge, Outlook, and Teams are
optional; their YASB launchers remain visible even when an application is not
installed.

## Full restore

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\windows\Install-WindowsSetup.ps1 -InstallPackages -ImportWindotsWallpapers
```

This command:

- installs YASB, GlazeWM, and AutoHotkey;
- backs up existing target configuration;
- restores the bar, widgets, styling, scripts, and keybindings;
- creates the login startup entries;
- imports the windots wallpapers from their upstream repository;
- sets `doom-catppuccin-l3.png` as the desktop wallpaper when available;
- creates Edge wrappers for Outlook, Outlook Calendar, and Teams;
- auto-hides the Windows taskbar; and
- leaves GlazeWM off until explicitly toggled.

Use `-KeepTaskbarVisible` if the Windows taskbar should remain visible:

```powershell
.\windows\Install-WindowsSetup.ps1 `
    -InstallPackages `
    -ImportWindotsWallpapers `
    -KeepTaskbarVisible
```

Zebar is not part of this setup. YASB is the only bar.

## Verify the restore

```powershell
Get-Process yasb

& "$env:USERPROFILE\.config\tiling-trial\Toggle-GlazeWM.ps1" -StatusOnly

Get-ItemPropertyValue `
    -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' `
    -Name YASB
```

Expected results:

- YASB is running.
- The initial tiling state is `off`.
- The YASB startup value points to `C:\Program Files\YASB\yasb.exe`.
- `Alt+,` opens the styled keyboard-help popup.
- `Win+Ctrl+Shift+T` starts GlazeWM.
- Pressing `Win+Ctrl+Shift+T` again stops GlazeWM.
- The YASB workspace widget changes between `TILING OFF` and the active
  workspace display.

## Restore Microsoft web styling

The installer copies the userstyle to:

```text
%USERPROFILE%\.config\microsoft-web-macchiato
```

Install Stylus in the Edge `Default` profile, run:

```powershell
& "$env:USERPROFILE\.config\microsoft-web-macchiato\Serve-UserStyle.ps1"
```

Then install `microsoft-365-macchiato.user.css` through Stylus. Use the
generated `Outlook (Macchiato)` and `Teams (Macchiato)` shortcuts. Native new
Outlook (`olk.exe`) cannot receive Stylus CSS.

## Backup and rollback

Every restore backs up an existing target configuration under:

```text
%USERPROFILE%\Documents\UnixLikeWindows-backups\<timestamp>\repo-restore
```

The backup can contain:

- `yasb`
- `glazewm-trial`
- `tiling-trial`
- `microsoft-web-macchiato`

To roll back, stop YASB and the AutoHotkey controller, then copy the desired
backup directories back under `%USERPROFILE%\.config`:

```powershell
$backup = Join-Path $env:USERPROFILE (
    'Documents\UnixLikeWindows-backups\<timestamp>\repo-restore'
)

Get-Process yasb -ErrorAction SilentlyContinue |
    ForEach-Object {
        Stop-Process -Id $_.Id
    }

Get-CimInstance Win32_Process |
    Where-Object {
        $_.Name -like 'AutoHotkey*.exe' -and
        $_.CommandLine -like '*\.config\tiling-trial\TilingTrial.ahk*'
    } |
    ForEach-Object {
        Stop-Process -Id $_.ProcessId
    }

Copy-Item `
    -LiteralPath (Join-Path $backup 'yasb') `
    -Destination (Join-Path $env:USERPROFILE '.config\yasb') `
    -Recurse `
    -Force
```

Repeat the final `Copy-Item` command for any other backed-up directory that
should be restored, then sign out and back in.
