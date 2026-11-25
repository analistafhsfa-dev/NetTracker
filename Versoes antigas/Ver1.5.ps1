Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Net.NetworkInformation
Add-Type -AssemblyName System.Windows.Media

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Ping Monitor"
        Height="180"
        Width="470"
        ResizeMode="NoResize"
        WindowStartupLocation="CenterScreen">

    <Grid Margin="10">

        <Border BorderBrush="Black"
                BorderThickness="2"
                CornerRadius="6"
                Padding="10">

            <Grid>

                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="40"/>
                    <ColumnDefinition Width="180"/>
                    <ColumnDefinition Width="70"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

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
                        Content="Start"/>

                <Ellipse Name="StatusLed"
                         Grid.Column="3"
                         Width="25"
                         Height="25"
                         Fill="Gray"
                         HorizontalAlignment="Left"
                         Margin="10,0,0,0"/>

                <TextBlock Text="MS"
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

# =========================
# ESTADO
# =========================
$script:running = $false
$script:ip = ""
$script:blink = $false

# BRUSHES (IMPORTANTE: instanciados, não static)
$green1 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::LimeGreen)
$green2 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::Green)

$red1 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::Red)
$red2 = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::DarkRed)

$gray = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Colors]::Gray)

# =========================
# UI UPDATE FORÇADO
# =========================
function Set-UI($color, $ms) {
    $Window.Dispatcher.Invoke([action]{
        $StatusLed.Fill = $color
        $txtMS.Text = $ms
    })
}

# =========================
# TIMER
# =========================
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)

$timer.Add_Tick({

    if (-not $script:running) { return }
    if (-not $script:ip) { return }

    try {
        $reply = $ping.Send($script:ip, 1000)

        # alterna estado VISUAL real
        $script:blink = -not $script:blink

        if ($reply.Status -eq "Success") {

            $color = if ($script:blink) { $green1 } else { $green2 }

            Set-UI $color "$($reply.RoundtripTime) ms"
        }
        else {

            $color = if ($script:blink) { $red1 } else { $red2 }

            Set-UI $color "TIMEOUT"
        }
    }
    catch {
        Set-UI $red1 "ERROR"
    }
})

$timer.Start()

# =========================
# TOGGLE BUTTON
# =========================
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