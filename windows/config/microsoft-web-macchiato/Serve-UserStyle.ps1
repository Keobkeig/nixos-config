$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSCommandPath
$stylePath = Join-Path $root 'microsoft-365-macchiato.user.css'
$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 8765)
$listener.Start()

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $stream = $client.GetStream()
            $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 1024, $true)
            $requestLine = $reader.ReadLine()
            while ($reader.ReadLine()) {}

            if ($requestLine -match '^GET /microsoft-365-macchiato\.user\.css ') {
                $body = [IO.File]::ReadAllBytes($stylePath)
                $status = 'HTTP/1.1 200 OK'
                $contentType = 'text/css; charset=utf-8'
            } else {
                $body = [Text.Encoding]::UTF8.GetBytes('Not found')
                $status = 'HTTP/1.1 404 Not Found'
                $contentType = 'text/plain; charset=utf-8'
            }

            $headers = "$status`r`nContent-Type: $contentType`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($headers)
            $stream.Write($headerBytes, 0, $headerBytes.Length)
            $stream.Write($body, 0, $body.Length)
            $stream.Flush()
        } finally {
            $client.Dispose()
        }
    }
} finally {
    $listener.Stop()
}
