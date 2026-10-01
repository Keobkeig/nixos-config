param(
    [switch] $StatusOnly
)

$ErrorActionPreference = 'Stop'

$glazePath = Join-Path $env:ProgramFiles 'glzr.io\GlazeWM\glazewm.exe'
$configPath = Join-Path $env:USERPROFILE '.config\glazewm-trial\config.yaml'

if (-not (Test-Path -LiteralPath $glazePath)) {
    throw "GlazeWM was not found at '$glazePath'."
}

if (-not (Test-Path -LiteralPath $configPath)) {
    throw "GlazeWM configuration was not found at '$configPath'."
}

$glazeProcess = Get-Process -Name glazewm -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($StatusOnly) {
    if ($glazeProcess) {
        'on'
    } else {
        'off'
    }

    exit 0
}

if ($glazeProcess) {
    $stopProcess = Start-Process `
        -FilePath $glazePath `
        -ArgumentList @('command', 'wm-exit') `
        -WindowStyle Hidden `
        -Wait `
        -PassThru

    if ($stopProcess.ExitCode -ne 0) {
        throw "GlazeWM returned exit code $($stopProcess.ExitCode) while stopping."
    }

    'off'
    exit 0
}

Start-Process -FilePath $glazePath -ArgumentList @(
    'start'
    "--config=$configPath"
)

'on'
