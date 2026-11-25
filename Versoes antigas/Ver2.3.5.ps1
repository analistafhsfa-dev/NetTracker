Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Net.NetworkInformation


# ============================================================
# XAML
# ============================================================

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="NET TRACKER 2.3.5"
    Height="470"
    Width="520"
    MinHeight="430"
    MinWidth="520"
    ResizeMode="CanMinimize"
    WindowStartupLocation="CenterScreen"
    Background="#F4F6F8">

    <Window.Resources>

        <Style TargetType="Button">

            <Setter Property="Background" Value="#E8EDF2"/>
            <Setter Property="Foreground" Value="#202124"/>
            <Setter Property="BorderBrush" Value="#D0D5DB"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>

            <Setter Property="Template">

                <Setter.Value>

                    <ControlTemplate TargetType="Button">

                        <Border
                            Background="{TemplateBinding Background}"
                            BorderBrush="{TemplateBinding BorderBrush}"
                            BorderThickness="{TemplateBinding BorderThickness}"
                            CornerRadius="6">

                            <ContentPresenter
                                HorizontalAlignment="Center"
                                VerticalAlignment="Center"/>

                        </Border>

                    </ControlTemplate>

                </Setter.Value>

            </Setter>

        </Style>

    </Window.Resources>


    <Grid Margin="18">

        <Grid.RowDefinitions>
            <RowDefinition Height="62"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="42"/>
        </Grid.RowDefinitions>


        <!-- ================================================= -->
        <!-- CABEÇALHO                                         -->
        <!-- ================================================= -->

        <Grid Grid.Row="0">

            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>


            <StackPanel
                Grid.Column="0"
                VerticalAlignment="Center">

                <TextBlock
                    Name="txtNetTracker"
                    Text="NET TRACKER"
                    FontSize="22"
                    FontWeight="SemiBold"
                    Foreground="#202124"/>

                <TextBlock
                    Text="Monitoramento e Relatorio de Conexao"
                    FontSize="9"
                    Foreground="#6B7280"
                    Margin="3,3,0,15"/>

            </StackPanel>


            <StackPanel
                Grid.Column="1"
                Orientation="Horizontal"
                VerticalAlignment="Center">

                <Ellipse
                    Name="HeaderLed"
                    Width="10"
                    Height="10"
                    Fill="#9CA3AF"
                    Margin="0,0,7,0"/>

                <TextBlock
                    Name="txtHeaderStatus"
                    Text="AGUARDANDO"
                    FontSize="11"
                    FontWeight="SemiBold"
                    Foreground="#6B7280"
                    VerticalAlignment="Center"/>

            </StackPanel>

        </Grid>


        <!-- ================================================= -->
        <!-- CONTEÚDO                                          -->
        <!-- ================================================= -->

        <Grid Grid.Row="1">

            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>


            <!-- ================================================= -->
            <!-- ENDEREÇO                                          -->
            <!-- ================================================= -->

            <StackPanel Grid.Row="0">

                <TextBlock
                    Text="HOSTNAME OU IPV4"
                    FontSize="11"
                    FontWeight="SemiBold"
                    Foreground="#6B7280"
                    Margin="0,0,0,7"/>


                <Grid>

                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="105"/>
                    </Grid.ColumnDefinitions>


                    <TextBox
                        Name="txtIP"
                        Grid.Column="0"
                        Height="38"
                        FontSize="15"
                        Padding="10,0"
                        VerticalContentAlignment="Center"
                        Background="White"
                        BorderBrush="#D1D5DB"
                        BorderThickness="1"/>


                    <Button
                        Name="btnToggle"
                        Grid.Column="1"
                        Width="95"
                        Height="38"
                        Margin="10,0,0,0"
                        Content="START"/>

                </Grid>

            </StackPanel>


            <!-- ================================================= -->
            <!-- LATÊNCIA                                          -->
            <!-- ================================================= -->

            <StackPanel
                Grid.Row="1"
                Margin="0,18,0,0">

                <TextBlock
                    Text="LATENCIA"
                    FontSize="11"
                    FontWeight="SemiBold"
                    Foreground="#6B7280"
                    HorizontalAlignment="Center"
                    Margin="0,0,0,7"/>


                <Border
                    Width="210"
                    Height="62"
                    HorizontalAlignment="Center"
                    Background="White"
                    BorderBrush="#D9DEE5"
                    BorderThickness="1"
                    CornerRadius="6">

                    <TextBlock
                        Name="txtMS"
                        Text="-- ms"
                        FontSize="24"
                        FontWeight="SemiBold"
                        Foreground="#202124"
                        HorizontalAlignment="Center"
                        VerticalAlignment="Center"/>

                </Border>

            </StackPanel>


            <!-- ================================================= -->
            <!-- STATUS                                            -->
            <!-- ================================================= -->

            <Grid
                Grid.Row="2"
                Margin="0,18,0,0">

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>


                <!-- CONEXÃO -->

                <StackPanel
                    Grid.Column="0"
                    HorizontalAlignment="Center">

                    <TextBlock
                        Text="CONEXAO"
                        FontSize="11"
                        FontWeight="SemiBold"
                        Foreground="#6B7280"
                        HorizontalAlignment="Center"/>

                    <StackPanel
                        Orientation="Horizontal"
                        HorizontalAlignment="Center"
                        Margin="0,7,0,0">

                        <Ellipse
                            Name="StatusLed"
                            Width="11"
                            Height="11"
                            Fill="#9CA3AF"
                            Margin="0,0,6,0"/>

                        <TextBlock
                            Name="txtConnection"
                            Text="OFFLINE"
                            FontSize="12"
                            FontWeight="SemiBold"
                            Foreground="#6B7280"/>

                    </StackPanel>

                </StackPanel>


                <!-- LATÊNCIA -->

                <StackPanel
                    Grid.Column="1"
                    HorizontalAlignment="Center">

                    <TextBlock
                        Text="LATENCIA"
                        FontSize="11"
                        FontWeight="SemiBold"
                        Foreground="#6B7280"
                        HorizontalAlignment="Center"/>

                    <StackPanel
                        Orientation="Horizontal"
                        HorizontalAlignment="Center"
                        Margin="0,7,0,0">

                        <Ellipse
                            Name="LatencyLed"
                            Width="11"
                            Height="11"
                            Fill="#9CA3AF"
                            Margin="0,0,6,0"/>

                        <TextBlock
                            Name="txtLatencyStatus"
                            Text="--"
                            FontSize="12"
                            FontWeight="SemiBold"
                            Foreground="#6B7280"/>

                    </StackPanel>

                </StackPanel>


                <!-- OPERADORA -->

                <StackPanel
                    Grid.Column="2"
                    HorizontalAlignment="Center">

                    <TextBlock
                        Text="OPERADORA"
                        FontSize="11"
                        FontWeight="SemiBold"
                        Foreground="#6B7280"
                        HorizontalAlignment="Center"/>

                    <StackPanel
                        Orientation="Horizontal"
                        HorizontalAlignment="Center"
                        Margin="0,7,0,0">

                        <Ellipse
                            Name="LedOperadora"
                            Width="11"
                            Height="11"
                            Fill="#9CA3AF"
                            Margin="0,0,6,0"/>

                        <TextBlock
                            Name="txtOperadora"
                            Text="--"
                            FontSize="12"
                            FontWeight="SemiBold"
                            Foreground="#6B7280"/>

                    </StackPanel>

                </StackPanel>

            </Grid>


            <!-- ================================================= -->
            <!-- BOTÕES                                            -->
            <!-- ================================================= -->

            <Grid
                Grid.Row="3"
                Margin="0,8,0,10">

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>


                <Button
                    Name="btnMAC"
                    Grid.Column="0"
                    Width="105"
                    Height="34"
                    HorizontalAlignment="Center"
                    Content="MAC"/>


                <Button
                    Name="btnReport"
                    Grid.Column="1"
                    Width="105"
                    Height="34"
                    HorizontalAlignment="Center"
                    Content="RELATORIO"/>

            </Grid>

        </Grid>


        <!-- ================================================= -->
        <!-- RODAPÉ                                            -->
        <!-- ================================================= -->

        <Border
            Grid.Row="2"
            BorderBrush="#E1E5EA"
            BorderThickness="0,1,0,0">

            <TextBlock
                Text="NET TRACKER 2.3.5 -  Criado por Guilherme"
                FontSize="10"
                Foreground="#9CA3AF"
                HorizontalAlignment="Center"
                VerticalAlignment="Center"/>

        </Border>

    </Grid>

</Window>
"@


# ============================================================
# CARREGA JANELA
# ============================================================

try {

    $reader = New-Object System.Xml.XmlNodeReader $xaml

    $Window = [Windows.Markup.XamlReader]::Load($reader)

}
catch {

    [System.Windows.MessageBox]::Show(
        "Erro ao carregar a interface:`n`n$($_.Exception.Message)",
        "NET TRACKER"
    )

    return
}


# ============================================================
# CONTROLES
# ============================================================

$txtIP = $Window.FindName("txtIP")
$txtMS = $Window.FindName("txtMS")

$btnToggle = $Window.FindName("btnToggle")
$btnReport = $Window.FindName("btnReport")
$btnMAC = $Window.FindName("btnMAC")

$HeaderLed = $Window.FindName("HeaderLed")
$StatusLed = $Window.FindName("StatusLed")
$LatencyLed = $Window.FindName("LatencyLed")
$LedOperadora = $Window.FindName("LedOperadora")

$txtHeaderStatus = $Window.FindName("txtHeaderStatus")
$txtConnection = $Window.FindName("txtConnection")
$txtLatencyStatus = $Window.FindName("txtLatencyStatus")
$txtOperadora = $Window.FindName("txtOperadora")


# ============================================================
# ENTER NO CAMPO IP / HOSTNAME
# ============================================================

$txtIP.Add_KeyDown({

    param($sender, $e)

    if ($e.Key -eq [System.Windows.Input.Key]::Enter) {

        $btnToggle.RaiseEvent(
            [System.Windows.RoutedEventArgs]::new(
                [System.Windows.Controls.Button]::ClickEvent
            )
        )

        $e.Handled = $true

    }

})


# ============================================================
# PING
# ============================================================

$ping = New-Object System.Net.NetworkInformation.Ping


# ============================================================
# ESTADO
# ============================================================

$script:running = $false

$script:ip = ""

$script:inicioMonitoramento = $null

$script:totalPings = 0

$script:sucessos = 0

$script:falhas = 0

$script:latencias = @()


# ============================================================
# ARQUIVOS
# ============================================================

$desktop = [Environment]::GetFolderPath("Desktop")

$script:arquivoRelatorio = Join-Path `
    $desktop `
    "Relatorio_Ping.txt"

$script:csvLog = "C:\temp\Ping_Log.csv"


# ============================================================
# CORES
# ============================================================

$green = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::LimeGreen
)

$darkGreen = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Green
)

$red = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Red
)

$gray = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Gray
)

$yellow = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Yellow
)

$orange = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Orange
)

$blue = New-Object System.Windows.Media.SolidColorBrush(
    [System.Windows.Media.Colors]::Blue
)


# ============================================================
# CURSOR
# ============================================================

function Set-BusyCursor {

    $Window.Cursor = [System.Windows.Input.Cursors]::AppStarting

}


function Clear-BusyCursor {

    $Window.Cursor = [System.Windows.Input.Cursors]::Arrow

}


# ============================================================
# STATUS DA LATÊNCIA
# ============================================================

function Set-LatencyStatus {

    param(
        [int]$Milliseconds
    )

    if ($Milliseconds -lt 25) {

        $LatencyLed.Fill = $green

        $txtLatencyStatus.Text = "BOA"

        $txtLatencyStatus.Foreground = $darkGreen

    }
    elseif ($Milliseconds -lt 50) {

        $LatencyLed.Fill = $yellow

        $txtLatencyStatus.Text = "MEDIA"

        $txtLatencyStatus.Foreground = "#B7791F"

    }
    else {

        $LatencyLed.Fill = $orange

        $txtLatencyStatus.Text = "ALTA"

        $txtLatencyStatus.Foreground = "#C05621"

    }

}


# ============================================================
# OPERADORA
# ============================================================

function Set-Operadora {

    param(
        [string]$Nome
    )

    $LedOperadora.Fill = $gray

    $txtOperadora.Text = "--"


    switch ($Nome) {

        "ALGAR" {

            $LedOperadora.Fill = $blue

            $txtOperadora.Text = "ALGAR"

        }

        "CLARO" {

            $LedOperadora.Fill = $red

            $txtOperadora.Text = "CLARO"

        }

    }

}


# ============================================================
# DETECTA OPERADORA
# ============================================================

function Detectar-Operadora {

    try {

        $resultado = nslookup `
            myip.opendns.com `
            resolver1.opendns.com `
            2>$null


        $linhaIP = $resultado |
            Select-String "Address:" |
            Select-Object -Last 1


        if (-not $linhaIP) {

            Set-Operadora ""

            return

        }


        $ipPublico = $linhaIP.ToString().
            Split(":")[-1].Trim()


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


# ============================================================
# TIMER DO PING
# ============================================================

$timer = New-Object System.Windows.Threading.DispatcherTimer

$timer.Interval = [TimeSpan]::FromSeconds(2)


$timer.Add_Tick({

    # --------------------------------------------------------
    # SOMENTE MONITORA SE ESTIVER RODANDO
    # --------------------------------------------------------

    if (-not $script:running) {

        return

    }


    if ([string]::IsNullOrWhiteSpace($script:ip)) {

        return

    }


    try {

        $reply = $ping.Send(
            $script:ip,
            1000
        )


        # ====================================================
        # SUCESSO
        # ====================================================

        if ($reply.Status -eq "Success") {

            $latencia = [int]$reply.RoundtripTime


            # ------------------------------------------------
            # CONEXÃO
            # ------------------------------------------------

            $StatusLed.Fill = $green

            $txtConnection.Text = "ONLINE"

            $txtConnection.Foreground = $darkGreen


            # ------------------------------------------------
            # CABEÇALHO
            # ------------------------------------------------

            $HeaderLed.Fill = $green

            $txtHeaderStatus.Text = "MONITORANDO"

            $txtHeaderStatus.Foreground = $darkGreen


            # ------------------------------------------------
            # LATÊNCIA
            # ------------------------------------------------

            Set-LatencyStatus $latencia

            $txtMS.Text = "$latencia ms"


            # ------------------------------------------------
            # ESTATÍSTICAS
            # ------------------------------------------------

            $script:totalPings++

            $script:sucessos++

            $script:latencias += $latencia


            # ------------------------------------------------
            # CSV
            # ------------------------------------------------

            "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),$latencia,OK" |
                Add-Content $script:csvLog

        }


        # ====================================================
        # FALHA
        # ====================================================

        else {

            $StatusLed.Fill = $red

            $txtConnection.Text = "OFFLINE"

            $txtConnection.Foreground = $red


            $HeaderLed.Fill = $red

            $txtHeaderStatus.Text = "SEM CONEXÃO"

            $txtHeaderStatus.Foreground = $red


            $LatencyLed.Fill = $red

            $txtLatencyStatus.Text = "FALHA"

            $txtLatencyStatus.Foreground = $red

            $txtMS.Text = "TIMEOUT"


            # ------------------------------------------------
            # ESTATÍSTICAS
            # ------------------------------------------------

            $script:totalPings++

            $script:falhas++


            # ------------------------------------------------
            # CSV
            # ------------------------------------------------

            "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,FALHA" |
                Add-Content $script:csvLog

        }

    }
    catch {

        $StatusLed.Fill = $red

        $txtConnection.Text = "ERRO"

        $txtConnection.Foreground = $red


        $HeaderLed.Fill = $red

        $txtHeaderStatus.Text = "ERRO"

        $txtHeaderStatus.Foreground = $red


        $LatencyLed.Fill = $red

        $txtLatencyStatus.Text = "ERRO"

        $txtLatencyStatus.Foreground = $red

        $txtMS.Text = "ERROR"


        # ----------------------------------------------------
        # ESTATÍSTICAS
        # ----------------------------------------------------

        $script:totalPings++

        $script:falhas++


        # ----------------------------------------------------
        # CSV
        # ----------------------------------------------------

        "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')),0,ERRO" |
            Add-Content $script:csvLog

    }

})


$timer.Start()


# ============================================================
# START / STOP
# ============================================================

$btnToggle.Add_Click({

    # ========================================================
    # START
    # ========================================================

    if (-not $script:running) {

        $ip = $txtIP.Text.Trim()


        # ----------------------------------------------------
        # VALIDA CAMPO
        # ----------------------------------------------------

        if ([string]::IsNullOrWhiteSpace($ip)) {

            [System.Windows.MessageBox]::Show(
                "Informe um endereço IP ou hostname.",
                "NET TRACKER"
            )

            return

        }


        # ----------------------------------------------------
        # VERIFICA IPv4
        # ----------------------------------------------------

        $isIPv4 = $ip -match `
            '^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$'


        # ----------------------------------------------------
        # VERIFICA HOSTNAME
        # ----------------------------------------------------

        if (-not $isIPv4) {

            if (
                $ip -notmatch `
                '^[a-zA-Z0-9]([a-zA-Z0-9\-\.]*[a-zA-Z0-9])?$'
            ) {

                [System.Windows.MessageBox]::Show(
                    "Informe um endereço IPv4 ou hostname valido.",
                    "NET TRACKER"
                )

                return

            }

        }


        # ----------------------------------------------------
        # ESTADO
        # ----------------------------------------------------

        $script:ip = $ip

        $script:running = $true

        $script:inicioMonitoramento = Get-Date

        $script:totalPings = 0

        $script:sucessos = 0

        $script:falhas = 0

        $script:latencias = @()


        # ----------------------------------------------------
        # CRIA C:\TEMP
        # ----------------------------------------------------

        if (-not (Test-Path "C:\temp")) {

            New-Item `
                -Path "C:\temp" `
                -ItemType Directory `
                -Force |
                Out-Null

        }


        # ----------------------------------------------------
        # CRIA CSV
        # ----------------------------------------------------

        "Data,Latencia,Status" |
            Out-File `
                -FilePath $script:csvLog `
                -Encoding UTF8


        # ----------------------------------------------------
        # INTERFACE
        # ----------------------------------------------------

        $btnToggle.Content = "STOP"

        $btnToggle.Background = "#FDE2E2"

        $txtMS.Text = "PING..."

        $txtConnection.Text = "CONECTANDO"

        $txtConnection.Foreground = "#6B7280"

        $StatusLed.Fill = $yellow

        $LatencyLed.Fill = $gray

        $txtLatencyStatus.Text = "--"

        $txtLatencyStatus.Foreground = "#6B7280"

        $HeaderLed.Fill = $yellow

        $txtHeaderStatus.Text = "MONITORANDO"

        $txtHeaderStatus.Foreground = "#B7791F"


        # ----------------------------------------------------
        # DETECTA OPERADORA
        # ----------------------------------------------------

        Detectar-Operadora

    }


    # ========================================================
    # STOP
    # ========================================================

    else {

        # ----------------------------------------------------
        # PARA SOMENTE O MONITORAMENTO
        # ----------------------------------------------------

        $script:running = $false


        # ----------------------------------------------------
        # INTERFACE
        # ----------------------------------------------------

        $btnToggle.Content = "START"

        $btnToggle.Background = "#E8EDF2"


        $txtMS.Text = "-- ms"


        $txtConnection.Text = "OFFLINE"

        $txtConnection.Foreground = "#6B7280"


        $StatusLed.Fill = $gray


        $LatencyLed.Fill = $gray

        $txtLatencyStatus.Text = "--"

        $txtLatencyStatus.Foreground = "#6B7280"


        $HeaderLed.Fill = $gray

        $txtHeaderStatus.Text = "AGUARDANDO"

        $txtHeaderStatus.Foreground = "#6B7280"


        $LedOperadora.Fill = $gray

        $txtOperadora.Text = "--"


        # ----------------------------------------------------
        # IMPORTANTE:
        #
        # O CSV NÃO É APAGADO AQUI.
        #
        # O botão RELATÓRIO utilizará o CSV posteriormente.
        # ----------------------------------------------------

    }

})


# ============================================================
# FUNÇÃO MOSTRAR MAC
# ============================================================

function Mostrar-MAC {

    if ([string]::IsNullOrWhiteSpace($script:ip)) {

        [System.Windows.MessageBox]::Show(
            "Inicie o monitoramento informando um IP primeiro.",
            "MAC"
        )

        return

    }


    try {

        $resultado = getmac /s $script:ip /v 2>$null


        if (-not $resultado) {

            throw "Nenhum MAC encontrado."

        }


        $texto = ""

        $contador = 0


        foreach ($linha in $resultado) {

            if (
                $linha -match `
                "^\s*(\S+)\s+(.+?)\s+([0-9A-Fa-f]{2}(-[0-9A-Fa-f]{2}){5})\s+(.*)$"
            ) {

                $contador++


                $adaptador = $matches[1]

                $nome = $matches[2].Trim()

                $mac = $matches[3]

                $transporte = $matches[5]


                $texto += "================================`r`n"

                $texto += " ADAPTADOR $contador`r`n"

                $texto += "================================`r`n`r`n"

                $texto += "Conexao : $adaptador`r`n"

                $texto += "Nome    : $nome`r`n"

                $texto += "MAC     : $mac`r`n"

                $texto += "Rede    : $transporte`r`n`r`n"

            }

        }


        if ($contador -eq 0) {

            $texto = ($resultado | Out-String)

        }


        # ----------------------------------------------------
        # JANELA MAC
        # ----------------------------------------------------

        $janelaMAC = New-Object System.Windows.Window

        $janelaMAC.Title = "MAC - $($script:ip)"

        $janelaMAC.Width = 650

        $janelaMAC.Height = 400

        $janelaMAC.WindowStartupLocation = "CenterScreen"

        $janelaMAC.Background = "#F4F6F8"


        $txt = New-Object System.Windows.Controls.TextBox

        $txt.Text = $texto

        $txt.FontFamily = "Consolas"

        $txt.FontSize = 14

        $txt.IsReadOnly = $true

        $txt.TextWrapping = "Wrap"

        $txt.VerticalScrollBarVisibility = "Auto"

        $txt.Margin = "10"


        $janelaMAC.Content = $txt

        $janelaMAC.ShowDialog() | Out-Null

    }
    catch {

        [System.Windows.MessageBox]::Show(
            "Erro ao consultar MAC:`n$($_.Exception.Message)",
            "MAC"
        )

    }

}


# ============================================================
# BOTÃO MAC
# ============================================================

$btnMAC.Add_Click({

    try {

        $btnMAC.Background = "#FDE2E2"

        $btnMAC.Foreground = "#000000"

        $btnMAC.Content = "Consultando..."

        $btnMAC.IsEnabled = $false


        $Window.Cursor = [System.Windows.Input.Cursors]::Wait


        $Window.Dispatcher.Invoke(
            [Action] {},
            [System.Windows.Threading.DispatcherPriority]::Render
        )


        Mostrar-MAC

    }
    finally {

        $btnMAC.Background = "#E8EDF2"

        $btnMAC.Foreground = "#1E1E1E"

        $btnMAC.Content = "MAC"

        $btnMAC.IsEnabled = $true


        $Window.Cursor = [System.Windows.Input.Cursors]::Arrow

    }

})


# ============================================================
# BOTÃO RELATÓRIO
# ============================================================

$btnReport.Add_Click({

    try {

        # ====================================================
        # VERIFICA SE EXISTEM DADOS
        # ====================================================

        if ($script:totalPings -eq 0) {

            [System.Windows.MessageBox]::Show(
                "Nenhum dado de monitoramento foi coletado ainda.",
                "RELATORIO"
            )

            return

        }


        # ====================================================
        # ESTADO VISUAL
        # ====================================================

        $btnReport.Background = "#FDE2E2"

        $btnReport.Foreground = "#000000"

        $btnReport.Content = "Gerando..."

        $btnReport.IsEnabled = $false


        $Window.Cursor = [System.Windows.Input.Cursors]::Wait


        # ====================================================
        # ATUALIZA INTERFACE
        # ====================================================

        $Window.Dispatcher.Invoke(
            [Action] {},
            [System.Windows.Threading.DispatcherPriority]::Render
        )


        # ====================================================
        # DATA/HORA FINAL
        # ====================================================

        $fim = Get-Date


        # ====================================================
        # PERDA
        # ====================================================

        if ($script:totalPings -gt 0) {

            $perda = [math]::Round(
                ($script:falhas / $script:totalPings) * 100,
                2
            )

        }
        else {

            $perda = 0

        }


        # ====================================================
        # MÉDIA
        # ====================================================

        if ($script:latencias.Count -gt 0) {

            $media = [math]::Round(
                (
                    $script:latencias |
                    Measure-Object -Average
                ).Average,
                2
            )

        }
        else {

            $media = 0

        }


        # ====================================================
        # GERA RELATORIO TXT
        # ====================================================

        @(
            "RELATORIO"
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
        ) |
            Out-File `
                -FilePath $script:arquivoRelatorio `
                -Encoding UTF8


        # ====================================================
        # LOCALIZA GERA-FRAC.EXE
        # ====================================================

        $graficoExe = Join-Path `
            $PSScriptRoot `
            "gera-frac.exe"


        if (-not (Test-Path $graficoExe)) {

            throw "Arquivo gera-frac.exe não encontrado:`n$graficoExe"

        }


        # ====================================================
        # VERIFICA CSV
        # ====================================================

        if (-not (Test-Path $script:csvLog)) {

            throw "Arquivo CSV não encontrado:`n$($script:csvLog)"

        }


        # ====================================================
        # EXECUTA GERA-FRAC.EXE
        #
        # O CSV é enviado como argumento para o EXE.
        # ====================================================

        $processo = Start-Process `
            -FilePath $graficoExe `
            -ArgumentList "`"$($script:csvLog)`"" `
            -WorkingDirectory $PSScriptRoot `
            -WindowStyle Hidden `
            -PassThru


        # ====================================================
        # AGUARDA O GERA-FRAC TERMINAR
        # ====================================================

        $processo.WaitForExit()


        # ====================================================
        # REMOVE CSV SOMENTE SE O MONITORAMENTO ESTIVER PARADO
        # ====================================================

        if (
            -not $script:running -and
            (Test-Path $script:csvLog)
        ) {

            Remove-Item `
                -Path $script:csvLog `
                -Force `
                -ErrorAction SilentlyContinue

        }


        # ====================================================
        # MENSAGEM FINAL
        # ====================================================

        [System.Windows.MessageBox]::Show(
            "Relatorio gerado com sucesso.`n`nArquivo salvo em:`n$($script:arquivoRelatorio)",
            "NET TRACKER"
        )

    }
    catch {

        [System.Windows.MessageBox]::Show(
            "Erro ao gerar relatorio:`n`n$($_.Exception.Message)",
            "RELATORIO"
        )

    }
    finally {

        # ====================================================
        # RESTAURA BOTÃO
        # ====================================================

        $btnReport.Background = "#E8EDF2"

        $btnReport.Foreground = "#1E1E1E"

        $btnReport.Content = "RELATORIO"

        $btnReport.IsEnabled = $true


        $Window.Cursor = [System.Windows.Input.Cursors]::Arrow

    }

})


# ============================================================
# FECHAMENTO
# ============================================================

$Window.Add_Closing({

    $script:running = $false


    if (Test-Path $script:csvLog) {

        Remove-Item `
            -Path $script:csvLog `
            -Force `
            -ErrorAction SilentlyContinue

    }

})


# ============================================================
# DETECTA OPERADORA AO INICIAR
# ============================================================

Detectar-Operadora


# ============================================================
# ABRE JANELA
# ============================================================

$Window.ShowDialog() | Out-Null
