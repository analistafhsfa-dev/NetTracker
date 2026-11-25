# Ajusta o tamanho da janela (similar ao mode con)
$host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size(60, 20)
$host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(120, 500)

Write-Host "=== Teste de Ping ===`n"

while ($true) {

    $ip = Read-Host "Digite o IP (ou pressione Enter para sair)"

    if ([string]::IsNullOrWhiteSpace($ip)) {
        Write-Host "`nEncerrando..."
        break
    }

    $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue

    if ($ping) {
        Write-Host "[$ip] Ping bem-sucedido!" -ForegroundColor Green
    } else {
        Write-Host "[$ip] Falha ao pingar o IP." -ForegroundColor Red
    }

    Write-Host ""  # linha em branco
}
