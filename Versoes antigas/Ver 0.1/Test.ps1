$ip = Read-Host "Digite o IP"

$desktop = [Environment]::GetFolderPath("Desktop")
$arquivoRelatorio = Join-Path $desktop "Relatorio_Ping.txt"
$csvLog = Join-Path $desktop "ping_log.csv"
$pythonScript = Join-Path $desktop "gerar_grafico.py"

$inicioMonitoramento = Get-Date

$totalPings = 0
$sucessos = 0
$falhas = 0

$latencias = @()
$emFalha = $false
$inicioFalha = $null

"Data,Latencia,Status" | Out-File $csvLog -Encoding UTF8

Write-Host "Monitorando $ip..."

try {
    while ($true) {

        $totalPings++

        try {
            $resultado = Test-Connection -ComputerName $ip -Count 1 -ErrorAction Stop
            $latencia = $resultado.ResponseTime

            $sucessos++
            $latencias += $latencia

            "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),$latencia,OK" |
                Add-Content $csvLog

            Write-Host "$(Get-Date -Format HH:mm:ss) OK $latencia ms"
        }
        catch {
            $falhas++
            "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,FALHA" |
                Add-Content $csvLog

            Write-Host "$(Get-Date -Format HH:mm:ss) FALHA" -ForegroundColor Red
        }

        Start-Sleep 1
    }
}
finally {

    $fim = Get-Date

    $perda = if ($totalPings -gt 0) {
        [math]::Round(($falhas / $totalPings) * 100, 2)
    } else { 0 }

    $relatorio = @(
        "RELATORIO",
        "====================",
        "IP: $ip",
        "Inicio: $inicioMonitoramento",
        "Fim: $fim",
        "",
        "Pings: $totalPings",
        "Sucessos: $sucessos",
        "Falhas: $falhas",
        "Perda: $perda %"
    )

    $relatorio | Out-File $arquivoRelatorio -Encoding UTF8

    Write-Host "RELATORIO GERADO"

    # CHAMA PYTHON (SEM CRIAR ARQUIVO NENHUM)
    if (Test-Path $pythonScript) {
        python $pythonScript
    } else {
        Write-Host "Python nao encontrado no desktop"
    }
}
