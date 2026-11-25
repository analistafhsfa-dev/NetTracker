$ips = @(
    "10.0.18.2",
    "10.0.12.68",
    "10.0.7.251",
    "8.8.8.8"
)

while ($true) {
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host (Get-Date) -ForegroundColor Cyan

    foreach ($ip in $ips) {
        $resultado = Test-Connection $ip -Count 1 -Quiet -ErrorAction SilentlyContinue

        if ($resultado) {
            Write-Host "Ping OK -> $ip" -ForegroundColor Green
        } else {
            Write-Host "Falha no ping -> $ip" -ForegroundColor Red
        }
    }

    Write-Host "Aguardando 2 segundos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
}
