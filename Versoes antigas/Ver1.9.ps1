Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Net.NetworkInformation

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Ping Monitor"
        Height="180"
        Width="320"
        ResizeMode="NoResize"
        WindowStartupLocation="CenterScreen">

    <Grid HorizontalAlignment="Center"
          VerticalAlignment="Center">

        <Border BorderBrush="Black"
                BorderThickness="2"
                CornerRadius="6"
                Padding="10"
                HorizontalAlignment="Center"
                VerticalAlignment="Center">

            <Grid>

                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>


                <Grid.ColumnDefinitions>

                    <ColumnDefinition Width="40"/>
                    <ColumnDefinition Width="160"/>
                    <ColumnDefinition Width="50"/>
                    <ColumnDefinition Width="55"/>

                </Grid.ColumnDefinitions>

                <!-- IP -->
                <TextBlock Text="IP"
                           FontSize="16"
                           VerticalAlignment="Center"/>

                <TextBox Name="txtIP"
                         Grid.Column="1"
                         Height="35"
                         Width="140"
                         Margin="0,0,20,0"
                         FontSize="18"/>

                <Button Name="btnToggle"
                        Grid.Column="2"
                        Height="35"
                        Width="80"
                        Content="Start"
                        Margin="-25,0,-35,0"/>

                <!-- NOVO BOTAO RELATORIO -->
		        <Button Name="btnReport"
                        Grid.Row="2"
		                Grid.Column="3"
		                Width="45"
		                Height="35"
		                Margin="-20,5,5,0"
		                HorizontalAlignment="Left"
		                VerticalAlignment="Center"
                        FontSize="12"
		                Content="GRAFICO"/>

                <!-- TP -->
                <TextBlock Text="TP"
                           Grid.Row="1"
                           FontSize="16"
                           VerticalAlignment="Center"
                           Margin="0,5,0,0"/>

                <TextBox Name="txtMS"
                         Grid.Row="1"
                         Grid.Column="1"
                         Height="35"
                         Width="140"
                         FontSize="18"
                         Margin="0,5,20,0"
                         IsReadOnly="True"/>

                <!-- LED -->
                <Ellipse Name="StatusLed"
                         Grid.Row="1"
                         Grid.Column="2"
                         Width="18"
                         Height="18"
                         Fill="Gray"
                         HorizontalAlignment="Left"
                         VerticalAlignment="Center"
                         Margin="0,10,30,0"/>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)
$txtIP = $Window.FindName("txtIP")
$txtMS = $Window.FindName("txtMS")
$btnToggle = $Window.FindName("btnToggle")
$btnReport = $Window.FindName("btnReport")
$StatusLed = $Window.FindName("StatusLed")
$ping = New-Object System.Net.NetworkInformation.Ping

# ===============================
# ESTADO DO SCRIPT
# ===============================

$script:running = $false
$script:ip = ""
$script:blink = $false

# ===============================
# ESTADO DO RELATORIO
# ===============================

$script:reportRunning = $false
$desktop = [Environment]::GetFolderPath("Desktop")
$script:arquivoRelatorio = Join-Path $desktop "Relatorio_Ping.txt"
$script:csvLog = Join-Path $desktop "Ping_Log.csv"
$script:inicioMonitoramento = $null
$script:totalPings = 0
$script:sucessos = 0
$script:falhas = 0
$script:latencias = @()

# ===============================
# CORES
# ===============================

$green1 = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::LimeGreen
)
$green2 = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Green
)
$red1 = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Red
)
$red2 = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::DarkRed
)
$gray = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Gray
)

# ===============================
# ATUALIZA UI
# ===============================

function Set-UI($color, $ms) {
    $Window.Dispatcher.Invoke([action]{
        $StatusLed.Fill = $color
        $txtMS.Text = $ms
    })
}

# ===============================
# TEMPORIZADOR DO PING
# ===============================

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)
$timer.Add_Tick({
    if (-not $script:running) { return }
    if (-not $script:ip) { return }
    try {
        $reply = $ping.Send($script:ip,1000)
        if ($reply.Status -eq "Success") {
            # estado normal do monitor
            Set-UI $green1 "$($reply.RoundtripTime) ms"

            # ===============================
            # GRAVACAOO DO RELATORIO
            # ===============================
            if ($script:reportRunning) {
                $script:totalPings++
                $script:sucessos++
                $script:latencias += $reply.RoundtripTime
                "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),$($reply.RoundtripTime),OK" |
                    Add-Content $script:csvLog
                    }
         }
         else {
                Set-UI $red1 "TIMEOUT"
                if ($script:reportRunning) {
                    $script:totalPings++
                    $script:falhas++
                    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,FALHA" |
                    Add-Content $script:csvLog
                    }
                }
          }
         catch {
                Set-UI $red1 "ERROR"
                if ($script:reportRunning) {
                    $script:totalPings++
                    $script:falhas++
            "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,ERRO" |
                Add-Content $script:csvLog
        }
    }
})

$timer.Start()

# ===============================
# BOTAO START / STOP
# ===============================

$btnToggle.Add_Click({
        if (-not $script:running) {
        $ip = $txtIP.Text.Trim()
            if ($ip -notmatch '^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$') {
                Set-UI $gray "IP invalido"
                return
            }
        $script:ip = $ip
        $script:running = $true
        $btnToggle.Content = "Stop"
        # Inicia automaticamente a gravação do relatório
        $script:reportRunning = $true
        $script:inicioMonitoramento = Get-Date
        $script:totalPings = 0
        $script:sucessos = 0
        $script:falhas = 0
        $script:latencias = @()
        "Data,Latencia,Status" |
            Out-File $script:csvLog -Encoding UTF8
        Set-UI $gray "Pinging..."
        }
        else {
            $script:running = $false
            $script:reportRunning = $false
            $fim = Get-Date
            $perda = if ($script:totalPings -gt 0) {
                [math]::Round(($script:falhas / $script:totalPings) * 100,2)
            }
            else {
                0
            }
            $media = if ($script:latencias.Count -gt 0) {
                [math]::Round(
                    ($script:latencias | Measure-Object -Average).Average,
                    2
                )
            }
            else {
                0
            }
            @(
                "RELATORIO PING"
                "=============================="
                ""
                "IP: $($script:ip)"
                "Inicio: $($script:inicioMonitoramento)"
                "Fim: $fim"
                ""
                "Total de Pings: $($script:totalPings)"
                "Sucessos: $($script:sucessos)"
                "Falhas: $($script:falhas)"
                "Perda: $perda %"
                "Media Latencia: $media ms"
                ""
                "CSV: $($script:csvLog)"
            ) | Out-File $script:arquivoRelatorio -Encoding UTF8

            $script:ip = ""

            $btnToggle.Content = "Start"

            Set-UI $gray "Parado"

            [System.Windows.MessageBox]::Show(
                "Relatório salvo na Área de Trabalho.",
                "Ping Monitor"
            )
        }
        #else {
        #$script:running = $false
        #$script:ip = ""
        #$btnToggle.Content = "Start"
        #Set-UI $gray "Parado"
        #}
})

# ===============================
# BOTAO RELATORIO
# ===============================
 $btnReport.Add_Click({
            $pythonScript = "G:\Guilherme\Scripts\WPF\Ping\gera.py"
            if (Test-Path $pythonScript) {
                Start-Process `
                    -FilePath "python.exe" `
                    -ArgumentList "`"$pythonScript`"" `
                    -WindowStyle Hidden
            }
            else {
                [System.Windows.MessageBox]::Show(
                    "Arquivo não encontrado:`n$pythonScript",
                    "Erro"
                )
            }
})

# ===============================
# INICIA JANELA
# ===============================

$Window.ShowDialog() | Out-Null