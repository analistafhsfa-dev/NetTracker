Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Net.NetworkInformation
Add-Type -AssemblyName System.Windows.Media

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
                    <ColumnDefinition Width="30"/>
                </Grid.ColumnDefinitions>

                <!-- IP -->
                <TextBlock Text="IP"
                           FontSize="16"
                           VerticalAlignment="Center"/>

                <TextBox Name="txtIP"
                         Grid.Column="1"
                         Height="35"
                         FontSize="18"/>

                <Button Name="btnToggle"
                        Grid.Column="2"
                        Height="35"
                        Content="Start"
                        Margin="5,0,0,0"/>

                <!-- TP -->
                <TextBlock Text="TP"
                           Grid.Row="1"
                           FontSize="16"
                           VerticalAlignment="Center"
                           Margin="0,10,0,0"/>

                <TextBox Name="txtMS"
                         Grid.Row="1"
                         Grid.Column="1"
                         Height="35"
                         FontSize="18"
                         Margin="0,10,0,0"
                         IsReadOnly="True"/>

                <!-- LED -->
                <Ellipse Name="StatusLed"
                         Grid.Row="1"
                         Grid.Column="2"
                         Width="18"
                         Height="18"
                         Fill="Gray"
                         HorizontalAlignment="left"
                         VerticalAlignment="Center"
                         Margin="10,10,0,0"/>

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
$StatusLed = $Window.FindName("StatusLed")

$ping = New-Object System.Net.NetworkInformation.Ping


# ESTADO script

$script:running = $false
$script:ip = ""
$script:blink = $false

# Cores
$green1 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::LimeGreen)
$green2 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::Green)

$red1 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::Red)
$red2 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::DarkRed)

$gray = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::Gray)


# UI

function Set-UI($color, $ms) {
    $Window.Dispatcher.Invoke([action]{
        $StatusLed.Fill = $color
        $txtMS.Text = $ms
    })
}


# temporizador

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)

$timer.Add_Tick({

    if (-not $script:running) { return }
    if (-not $script:ip) { return }

    try {
        $reply = $ping.Send($script:ip, 1000)

        if ($reply.Status -eq "Success") {

            # estado FIXO até próximo ping
            Set-UI $green1 "$($reply.RoundtripTime) ms"
        }
        else {
            Set-UI $red1 "TIMEOUT"
        }
    }
    catch {
        Set-UI $red1 "ERROR"
    }
})

$timer.Start()


# botao Pesquisa

$btnToggle.Add_Click({

    if (-not $script:running) {

        $ip = $txtIP.Text.Trim()

        if ($ip -notmatch '^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$') {
            Set-UI $gray "IP inválido"
            return
        }

        $script:ip = $ip
        $script:running = $true
        $btnToggle.Content = "Stop"

        Set-UI $gray "Pinging..."
    }
    else {
        $script:running = $false
        $script:ip = ""
        $btnToggle.Content = "Start"

        Set-UI $gray "Parado"
    }
})

$Window.ShowDialog() | Out-Null