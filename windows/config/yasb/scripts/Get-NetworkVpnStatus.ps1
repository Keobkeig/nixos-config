$ErrorActionPreference = 'Stop'

try {
    $wifi = Get-NetConnectionProfile -ErrorAction SilentlyContinue |
        Where-Object { $_.InterfaceAlias -eq 'Wi-Fi' -and $_.IPv4Connectivity -ne 'Disconnected' } |
        Select-Object -First 1
    $vpn = Get-VpnConnection -ErrorAction SilentlyContinue |
        Where-Object { $_.ConnectionStatus -eq 'Connected' } |
        Select-Object -First 1

    if ($wifi -and $vpn) {
        'Wi-Fi | VPN ON'
    } elseif ($wifi) {
        'Wi-Fi | VPN OFF'
    } elseif ($vpn) {
        'VPN ON'
    } else {
        'Offline'
    }
} catch {
    'Network unavailable'
}
