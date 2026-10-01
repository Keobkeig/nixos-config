[CmdletBinding()]
param(
    [switch] $InstallPackages,
    [switch] $ImportWindotsWallpapers,
    [switch] $KeepTaskbarVisible
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = Split-Path -Parent $PSCommandPath
$configRoot = Join-Path $root 'config'
$timestamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
$backupRoot = Join-Path $env:USERPROFILE "Documents\UnixLikeWindows-backups\$timestamp\repo-restore"

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)]
        [string] $Id
    )

    & winget install `
        --id $Id `
        --exact `
        --silent `
        --disable-interactivity `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        throw "winget failed to install '$Id' with exit code $LASTEXITCODE."
    }
}

function Copy-DirectoryContents {
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Destination
    )

    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    Get-ChildItem -LiteralPath $Source -Force |
        Copy-Item -Destination $Destination -Recurse -Force
}

function Backup-Directory {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $destination = Join-Path $backupRoot (Split-Path -Leaf $Path)
    Copy-Item -LiteralPath $Path -Destination $destination -Recurse -Force
}

function New-Shortcut {
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $TargetPath,

        [string] $Arguments = '',
        [string] $WorkingDirectory = '',
        [string] $IconLocation = ''
    )

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($Path)
    $shortcut.TargetPath = $TargetPath
    $shortcut.Arguments = $Arguments

    if ($WorkingDirectory) {
        $shortcut.WorkingDirectory = $WorkingDirectory
    }

    if ($IconLocation) {
        $shortcut.IconLocation = $IconLocation
    }

    $shortcut.Save()
}

function Set-TaskbarAutoHide {
    Add-Type @'
using System;
using System.Runtime.InteropServices;

public static class TaskbarSettings
{
    [StructLayout(LayoutKind.Sequential)]
    private struct Rect
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct AppBarData
    {
        public int Size;
        public IntPtr Window;
        public uint CallbackMessage;
        public uint Edge;
        public Rect Rectangle;
        public IntPtr State;
    }

    [DllImport("shell32.dll")]
    private static extern IntPtr SHAppBarMessage(uint message, ref AppBarData data);

    public static void EnableAutoHide()
    {
        const uint SetState = 0x0000000A;
        const int AutoHide = 0x1;

        var data = new AppBarData
        {
            Size = Marshal.SizeOf<AppBarData>(),
            State = new IntPtr(AutoHide)
        };

        SHAppBarMessage(SetState, ref data);
    }
}
'@

    [TaskbarSettings]::EnableAutoHide()
}

function Set-DesktopWallpaper {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Add-Type @'
using System.Runtime.InteropServices;

public static class DesktopWallpaper
{
    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool SystemParametersInfo(
        int action,
        int parameter,
        string value,
        int flags
    );
}
'@

    Set-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value '10'
    Set-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value '0'

    if (-not [DesktopWallpaper]::SystemParametersInfo(20, 0, $Path, 3)) {
        $errorCode = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Windows failed to set the wallpaper. Win32 error: $errorCode."
    }
}

if ($InstallPackages) {
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw 'winget is required when -InstallPackages is used.'
    }

    Install-WingetPackage -Id 'AmN.yasb'
    Install-WingetPackage -Id 'glzr-io.glazewm'
    Install-WingetPackage -Id 'AutoHotkey.AutoHotkey'
}

$yasbPath = Join-Path $env:ProgramFiles 'YASB\yasb.exe'
$glazePath = Join-Path $env:ProgramFiles 'glzr.io\GlazeWM\glazewm.exe'
$autoHotkeyCandidates = @(
    (Join-Path $env:LOCALAPPDATA 'Programs\AutoHotkey\v2\AutoHotkey64.exe'),
    (Join-Path $env:ProgramFiles 'AutoHotkey\v2\AutoHotkey64.exe')
)
$autoHotkeyPath = $autoHotkeyCandidates |
    Where-Object { Test-Path -LiteralPath $_ } |
    Select-Object -First 1

if (-not (Test-Path -LiteralPath $yasbPath)) {
    throw "YASB was not found at '$yasbPath'. Use -InstallPackages or install AmN.yasb."
}

if (-not (Test-Path -LiteralPath $glazePath)) {
    throw "GlazeWM was not found at '$glazePath'. Use -InstallPackages or install glzr-io.glazewm."
}

if (-not $autoHotkeyPath) {
    throw 'AutoHotkey v2 was not found. Use -InstallPackages or install AutoHotkey.AutoHotkey.'
}

$yasbTarget = Join-Path $env:USERPROFILE '.config\yasb'
$glazeTarget = Join-Path $env:USERPROFILE '.config\glazewm-trial'
$tilingTarget = Join-Path $env:USERPROFILE '.config\tiling-trial'
$microsoftWebTarget = Join-Path $env:USERPROFILE '.config\microsoft-web-macchiato'

Backup-Directory -Path $yasbTarget
Backup-Directory -Path $glazeTarget
Backup-Directory -Path $tilingTarget
Backup-Directory -Path $microsoftWebTarget

Copy-DirectoryContents `
    -Source (Join-Path $configRoot 'yasb\scripts') `
    -Destination (Join-Path $yasbTarget 'scripts')
Copy-Item `
    -LiteralPath (Join-Path $configRoot 'yasb\styles.css') `
    -Destination (Join-Path $yasbTarget 'styles.css') `
    -Force

$yamlUserProfile = $env:USERPROFILE.Replace('\', '\\')
$yasbConfig = Get-Content `
    -LiteralPath (Join-Path $configRoot 'yasb\config.yaml.template') `
    -Raw
$yasbConfig = $yasbConfig.Replace('__USERPROFILE__', $yamlUserProfile)
Set-Content `
    -LiteralPath (Join-Path $yasbTarget 'config.yaml') `
    -Value $yasbConfig `
    -NoNewline

Copy-DirectoryContents `
    -Source (Join-Path $configRoot 'glazewm') `
    -Destination $glazeTarget
Copy-DirectoryContents `
    -Source (Join-Path $configRoot 'tiling') `
    -Destination $tilingTarget
Copy-DirectoryContents `
    -Source (Join-Path $configRoot 'microsoft-web-macchiato') `
    -Destination $microsoftWebTarget

$wallpaperTarget = Join-Path $env:USERPROFILE 'Pictures\Wallpapers'
New-Item -ItemType Directory -Path $wallpaperTarget -Force | Out-Null

if ($ImportWindotsWallpapers) {
    if (-not (Get-Command git.exe -ErrorAction SilentlyContinue)) {
        throw 'Git is required when -ImportWindotsWallpapers is used.'
    }

    $temporaryWindots = Join-Path ([IO.Path]::GetTempPath()) (
        'windots-' + [guid]::NewGuid().ToString('N')
    )

    try {
        & git clone `
            --depth 1 `
            'https://github.com/ashish0kumar/windots.git' `
            $temporaryWindots

        if ($LASTEXITCODE -ne 0) {
            throw "Git failed to clone windots with exit code $LASTEXITCODE."
        }

        Copy-DirectoryContents `
            -Source (Join-Path $temporaryWindots 'walls') `
            -Destination $wallpaperTarget
    } finally {
        if (Test-Path -LiteralPath $temporaryWindots) {
            Remove-Item -LiteralPath $temporaryWindots -Recurse -Force
        }
    }
}

$selectedWallpaper = Join-Path $wallpaperTarget 'doom-catppuccin-l3.png'
if (Test-Path -LiteralPath $selectedWallpaper) {
    Set-DesktopWallpaper -Path $selectedWallpaper
}

$edgeCandidates = @(
    (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
    (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')
)
$edgePath = $edgeCandidates |
    Where-Object { Test-Path -LiteralPath $_ } |
    Select-Object -First 1

if ($edgePath) {
    $appShortcutDirectory = Join-Path $env:APPDATA (
        'Microsoft\Windows\Start Menu\Programs\Macchiato Apps'
    )
    New-Item -ItemType Directory -Path $appShortcutDirectory -Force | Out-Null

    New-Shortcut `
        -Path (Join-Path $appShortcutDirectory 'Outlook (Macchiato).lnk') `
        -TargetPath $edgePath `
        -Arguments '--profile-directory=Default --app=https://outlook.office.com/mail/' `
        -IconLocation "$edgePath,0"
    New-Shortcut `
        -Path (Join-Path $appShortcutDirectory 'Outlook Calendar (Macchiato).lnk') `
        -TargetPath $edgePath `
        -Arguments (
            '--profile-directory=Default ' +
            '--app=https://outlook.office.com/calendar/view/week'
        ) `
        -IconLocation "$edgePath,0"
    New-Shortcut `
        -Path (Join-Path $appShortcutDirectory 'Teams (Macchiato).lnk') `
        -TargetPath $edgePath `
        -Arguments '--profile-directory=Default --app=https://teams.microsoft.com/v2/' `
        -IconLocation "$edgePath,0"
}

$startupDirectory = Join-Path $env:APPDATA (
    'Microsoft\Windows\Start Menu\Programs\Startup'
)
$tilingShortcut = Join-Path $startupDirectory 'TilingTrial.lnk'
New-Shortcut `
    -Path $tilingShortcut `
    -TargetPath $autoHotkeyPath `
    -Arguments "`"$(Join-Path $tilingTarget 'TilingTrial.ahk')`"" `
    -WorkingDirectory $tilingTarget `
    -IconLocation "$glazePath,0"

New-ItemProperty `
    -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' `
    -Name 'YASB' `
    -Value $yasbPath `
    -PropertyType String `
    -Force |
    Out-Null

if (-not $KeepTaskbarVisible) {
    Set-TaskbarAutoHide
}

$existingControllers = Get-CimInstance Win32_Process |
    Where-Object {
        $_.Name -like 'AutoHotkey*.exe' -and
        $_.CommandLine -like '*\.config\tiling-trial\TilingTrial.ahk*'
    }
foreach ($controller in $existingControllers) {
    Stop-Process -Id $controller.ProcessId -Force
}

Start-Process -FilePath $tilingShortcut
Start-Sleep -Seconds 2

if (-not (Get-Process -Name yasb -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath $yasbPath
}

$tilingState = & (Join-Path $tilingTarget 'Toggle-GlazeWM.ps1') -StatusOnly

[pscustomobject]@{
    YasbConfig = $yasbTarget
    GlazeWMConfig = $glazeTarget
    TilingController = $tilingTarget
    TilingState = $tilingState
    ToggleKey = 'Win+Ctrl+Shift+T'
    HelpKey = 'Alt+,'
    Backup = if (Test-Path -LiteralPath $backupRoot) { $backupRoot } else { 'None' }
}
