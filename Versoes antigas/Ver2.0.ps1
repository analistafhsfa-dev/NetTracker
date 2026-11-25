Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Net.NetworkInformation

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Ping Monitor"
        Height="220"
        Width="420"
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

                <!-- ========================= -->
                <!-- LINHAS                    -->
                <!-- ========================= -->

                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <!-- ========================= -->
                <!-- COLUNAS                   -->
                <!-- ========================= -->

                <Grid.ColumnDefinitions>

                    <!-- Texto -->
                    <ColumnDefinition Width="40"/>

                    <!-- Caixa -->
                    <ColumnDefinition Width="170"/>

                    <!-- LED Status-->
                    <ColumnDefinition Width="7"/>

                    <!-- LED Latencia-->
                    <ColumnDefinition Width="60"/>

                    <!-- Botao -->
                    <ColumnDefinition Width="80"/>

                </Grid.ColumnDefinitions>

                <!-- ========================================= -->
                <!-- LINHA 1                                   -->
                <!-- ========================================= -->

                <TextBlock
                    Text="IP"
                    FontSize="16"
                    VerticalAlignment="Center"/>

                <TextBox
                    Name="txtIP"
                    Grid.Column="1"
                    Width="180"
                    Height="35"
                    Margin="0,8,-30,0"
                    FontSize="18"/>

                <Button
                    Name="btnToggle"
                    Grid.Row="0"
                    Grid.Column="4"
                    Width="80"
                    Height="35"
                    Margin="0,8,0,0"
                    Content="Start"
                    HorizontalAlignment="Right"/>

                <!-- ========================================= -->
                <!-- LINHA 2                                   -->
                <!-- ========================================= -->

                <TextBlock
                    Grid.Row="1"
                    Text="TP"
                    FontSize="16"
                    Margin="0,8,0,0"
                    VerticalAlignment="Center"/>

                <TextBox
                    Name="txtMS"
                    Grid.Row="1"
                    Grid.Column="1"
                    Width="180"
                    Height="35"
                    Margin="0,8,-30,0"
                    FontSize="18"
                    IsReadOnly="True"/>

                <Ellipse
                    Name="StatusLed"
                    Grid.Row="1"
                    Grid.Column="4"
                    Width="18"
                    Height="18"
                    Margin="50,8,0,0"
                    Fill="Gray"
                    HorizontalAlignment="Left"
                    VerticalAlignment="Center"/>

                <Ellipse
                    Name="LatencyLed"
                    Grid.Row="1"
                    Grid.Column="4"
                    Width="18"
                    Height="18"
                    Margin="7,8,0,0"
                    Fill="Gray"
                    HorizontalAlignment="Left"
                    VerticalAlignment="Center"/>

                <!-- ========================================= -->
                <!-- LINHA 3                                   -->
                <!-- ========================================= -->

                <!-- OP ALGAR -->

                <StackPanel
                    Grid.Row="2"
                    Grid.Column="0"
                    Grid.ColumnSpan="2"
                    Orientation="Horizontal"
                    Margin="0,15,0,0">

                    <TextBlock
                        Text="LINK"
                        Width="40"
                        FontSize="16"
                        VerticalAlignment="Center"/>

                    <TextBlock
                        Text=" ALGAR "
                        FontSize="15"
                        Margin="20,0,0,0"
                        VerticalAlignment="Center"/>

                    <Ellipse
                        Name="LedAlgar"
                        Width="14"
                        Height="14"
                        Fill="Gray"
                        Margin="0,0,15,0"/>

                    <TextBlock
                        Text="CLARO "
                        FontSize="15"
                        Margin="0,0,0,0"
                        VerticalAlignment="Center"/>

                    <Ellipse
                        Name="LedClaro"
                        Width="14"
                        Height="14"
                        Fill="Gray"/>

                </StackPanel>

                <!-- BOTAO GRAFICO -->

                <Button
                    Name="btnReport"
                    Grid.Row="2"
                    Grid.Column="4"
                    Width="80"
                    Height="35"
                    Margin="0,10,0,0"
                    HorizontalAlignment="Right"
                    Content="Grafico"/>

            </Grid>

        </Border>

    </Grid>

</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

$txtIP      = $Window.FindName("txtIP")
$txtMS      = $Window.FindName("txtMS")
$btnToggle  = $Window.FindName("btnToggle")
$btnReport  = $Window.FindName("btnReport")

$StatusLed  = $Window.FindName("StatusLed")
$LatencyLed = $Window.FindName("LatencyLed")
$LedAlgar   = $Window.FindName("LedAlgar")
$LedClaro   = $Window.FindName("LedClaro")

$ping = New-Object System.Net.NetworkInformation.Ping

# =====================================================
# ESTADO DO SCRIPT
# =====================================================

$script:running = $false
$script:ip = ""
$script:blink = $false

# =====================================================
# ESTADO DO RELAToRIO
# =====================================================

$script:reportRunning = $false

$desktop = [Environment]::GetFolderPath("Desktop")

$script:arquivoRelatorio = Join-Path $desktop "Relatorio_Ping.txt"
$script:csvLog           = Join-Path "C:\temp\ping" "Ping_Log.csv"



$script:inicioMonitoramento = $null

$script:totalPings = 0
$script:sucessos   = 0
$script:falhas     = 0

$script:latencias = @()

# =====================================================
# CORES
# =====================================================

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

$blue = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Blue
)
$yellow = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Yellow
)

$orange = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Orange
)

# =====================================================
# LEDs DA OPERADORA
# =====================================================

$LedAlgar.Fill = $gray
$LedClaro.Fill = $gray

# =====================================================
# FUNÇÃO PARA ALTERAR O LED DA OPERADORA
# =====================================================

function Set-Operadora {

    param(
        [string]$Nome
    )

    $Window.Dispatcher.Invoke([action]{

        $LedAlgar.Fill = $gray
        $LedClaro.Fill = $gray

        switch ($Nome) {

            "ALGAR" {

                $LedAlgar.Fill = $blue

            }

            "CLARO" {

                $LedClaro.Fill = $red1

            }

        }

    })

}

# =====================================================
# DEFINE OPERADORA PELO IP
# =====================================================

function Detectar-Operadora {

    try {

        $resultado = nslookup myip.opendns.com resolver1.opendns.com 2>$null

        $ipPublico = ($resultado |
            Select-String "Address:" |
            Select-Object -Last 1).ToString().Split(":")[-1].Trim()


        Write-Host "IP Publico detectado: $ipPublico"


        switch -Wildcard ($ipPublico) {

            "200.*" {

                Set-Operadora "CLARO"
                break

            }

            "201.*" {

                Set-Operadora "CLARO"
                break

            }

            "186.*" {

                Set-Operadora "ALGAR"
                break

            }

            "187.*" {

                Set-Operadora "ALGAR"
                break

            }

            "172.*" {

                Set-Operadora "ALGAR"
                break

            }

            "168.*" {

                Set-Operadora "ALGAR"
                break

            }

            default {

                Set-Operadora ""

            }

        }

    }
    catch {

        Set-Operadora ""

    }

}


# =====================================================
# ATUALIZA A INTERFACE
# =====================================================

function Set-UI {

    param(
        $StatusColor,
        $LatencyColor,
        $color,
        $texto
    )

    $Window.Dispatcher.Invoke([action]{

        $StatusLed.Fill  = $StatusColor
        $LatencyLed.Fill = $LatencyColor
        $StatusLed.Fill = $color
        $txtMS.Text = $texto

    })

}

# =====================================================
# TEMPORIZADOR DO PING
# =====================================================

$timer = New-Object System.Windows.Threading.DispatcherTimer

$timer.Interval = [TimeSpan]::FromSeconds(2)

$timer.Add_Tick({

    if (-not $script:running) {
        return
    }

    if ([string]::IsNullOrWhiteSpace($script:ip)) {
        return
    }

    try {

        $reply = $ping.Send($script:ip,1000)

        if ($reply.Status -eq "Success") {

            #Set-UI $green1 "$($reply.RoundtripTime) ms"
            if ($reply.RoundtripTime -lt 25) {
                $latColor = $green1
            }
            elseif ($reply.RoundtripTime -lt 50) {
                $latColor = $yellow
            }
            else {
                $latColor = $orange
            }
            Set-UI $green1 $green2 $latColor "$($reply.RoundtripTime) ms"


            if ($script:reportRunning) {

                $script:totalPings++
                $script:sucessos++

                $script:latencias += $reply.RoundtripTime

                "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),$($reply.RoundtripTime),OK" |
                    Add-Content $script:csvLog

            }

        }
        else {

            #Set-UI $red1 "TIMEOUT"
            Set-UI $red1 $red1 "TIMEOUT"

            if ($script:reportRunning) {

                $script:totalPings++
                $script:falhas++

                "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,FALHA" |
                    Add-Content $script:csvLog

            }

        }

    }
    catch {

        #Set-UI $red1 "ERROR"
        Set-UI $red1 $red1 "ERROR"

        if ($script:reportRunning) {

            $script:totalPings++
            $script:falhas++

            "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,ERRO" |
                Add-Content $script:csvLog

        }

    }

})

$timer.Start()

# =====================================================
# BOTaO START / STOP
# =====================================================

$btnToggle.Add_Click({

    if (-not $script:running) {

        $ip = $txtIP.Text.Trim()

        if ($ip -notmatch '^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$') {

            Set-UI $gray "IP invalido"
            return

        }

        $script:ip = $ip

        Detectar-Operadora $ip

        $script:running = $true
        $script:reportRunning = $true

        $script:inicioMonitoramento = Get-Date

        $script:totalPings = 0
        $script:sucessos = 0
        $script:falhas = 0
        $script:latencias = @()

        "Data,Latencia,Status" |
            Out-File $script:csvLog -Encoding UTF8

        $btnToggle.Content = "Stop"

        #Set-UI $gray "Pinging..."
        Set-UI $gray $gray "Pinging..."

    }
    else {

        $script:running = $false
        $script:reportRunning = $false

        $fim = Get-Date

        if ($script:totalPings -gt 0) {

            $perda = [math]::Round(
                ($script:falhas / $script:totalPings) * 100,
                2
            )

        }
        else {

            $perda = 0

        }

        if ($script:latencias.Count -gt 0) {

            $media = [math]::Round(
                ($script:latencias |
                    Measure-Object -Average).Average,
                2
            )

        }
        else {

            $media = 0

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

        if (Test-Path $script:csvLog) {
           Remove-Item $script:csvLog -Force -ErrorAction SilentlyContinue
        }

        $script:ip = ""

        $btnToggle.Content = "Start"

        #Set-UI $gray "Parado"
        Set-UI $gray $gray "Parado"

        $LedAlgar.Fill = $gray
        $LedClaro.Fill = $gray

        [System.Windows.MessageBox]::Show(
            "Relatorio salvo na Area de Trabalho.",
            "Ping Monitor"
        )

    }

})


# =====================================================
# BOTaO GRaFICO
# =====================================================

$btnReport.Add_Click({

    $pythonScript = "G:\Guilherme\Scripts\WPF\Ping\gera-frac.py"

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

$Window.Add_Closing({

    $script:running = $false
    $script:reportRunning = $false

    if (Test-Path $script:csvLog) {
        Remove-Item $script:csvLog -Force -ErrorAction SilentlyContinue
    }

})

# =====================================================
# INICIA A JANELA
# =====================================================

$Window.ShowDialog() | Out-Null






