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

    $stopDeadline = (Get-Date).AddSeconds(15)
    do {
        Start-Sleep -Milliseconds 250
        $glazeProcess = Get-Process -Name glazewm -ErrorAction SilentlyContinue
    } while ($glazeProcess -and (Get-Date) -lt $stopDeadline)

    if ($glazeProcess) {
        throw 'GlazeWM did not exit within 15 seconds.'
    }

    'off'
    exit 0
}

$startDeadline = (Get-Date).AddSeconds(90)
$arguments = 'start --config="{0}"' -f $configPath

do {
    $startedProcess = Start-Process `
        -FilePath $glazePath `
        -ArgumentList $arguments `
        -PassThru

    Start-Sleep -Seconds 2
    $startedProcess.Refresh()

    if (-not $startedProcess.HasExited) {
        'on'
        exit 0
    }

    Start-Sleep -Seconds 2
} while ((Get-Date) -lt $startDeadline)

throw 'GlazeWM could not start within 90 seconds.'
