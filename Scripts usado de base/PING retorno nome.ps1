# Ajusta o tamanho da janela
$host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size(60, 20)
$host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size(120, 500)

Write-Host "=== Teste de Ping ===`n"

while ($true) {

    $ip = Read-Host "Digite o IP (ou pressione Enter para sair)"

    if ([string]::IsNullOrWhiteSpace($ip)) {
        Write-Host "`nEncerrando..."
        break
    }

    # Testa o ping
    $ping = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue

    if ($ping) {
        # Resolve o nome da máquina
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
        } catch {
            $hostname = "Nome não resolvido"
        }

        Write-Host "IP: $ip | Nome: $hostname | Ping: Sucesso" -ForegroundColor Green
    }
    else {
        Write-Host "IP: $ip | Ping: Falha" -ForegroundColor Red
    }

    Write-Host ""
}
