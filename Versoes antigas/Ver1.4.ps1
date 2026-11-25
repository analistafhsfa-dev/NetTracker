Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Net.NetworkInformation

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
                    <ColumnDefinition Width="50"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- LABEL -->
                <TextBlock Text="IP"
                           FontSize="16"
                           VerticalAlignment="Center"/>

                <!-- IP BOX -->
                <TextBox Name="txtIP"
                         Grid.Column="1"
                         Height="35"
                         FontSize="18"/>

                <!-- SEARCH BUTTON -->
                <Button Name="btnSearch"
                        Grid.Column="2"
                        Width="40"
                        Height="35"
                        Content="▶"/>

                <!-- STATUS LED -->
                <Ellipse Name="StatusLed"
                         Grid.Column="3"
                         Width="25"
                         Height="25"
                         Fill="Gray"
                         HorizontalAlignment="Left"
                         Margin="10,0,0,0"/>

                <!-- MS LABEL -->
                <TextBlock Text="MS"
                           Grid.Row="1"
                           FontSize="16"
                           VerticalAlignment="Center"
                           Margin="0,10,0,0"/>

                <!-- MS BOX -->
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
$btnSearch = $Window.FindName("btnSearch")
$StatusLed = $Window.FindName("StatusLed")

$CurrentIP = $null
$ping = New-Object System.Net.NetworkInformation.Ping

# Timer principal
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(2)

function Update-UI($color, $ms) {
    $Window.Dispatcher.Invoke([action]{
        $StatusLed.Fill = $color
        $txtMS.Text = $ms
    })
}

function Do-Ping {

    if (-not $CurrentIP) { return }

    try {
        $reply = $ping.Send($CurrentIP, 1000)

        if ($reply.Status -eq "Success") {
            Update-UI ([System.Windows.Media.Brushes]::LimeGreen) "$($reply.RoundtripTime) ms"
        }
        else {
            Update-UI ([System.Windows.Media.Brushes]::Red) "TIMEOUT"
        }
    }
    catch {
        Update-UI ([System.Windows.Media.Brushes]::Red) "ERROR"
    }
}

# BOTÃO START
$btnSearch.Add_Click({

    $ip = $txtIP.Text.Trim()

    if ($ip -match '^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$') {

        $CurrentIP = $ip

        # inicia loop se ainda não estiver rodando
        if (-not $timer.IsEnabled) {
            $timer.Add_Tick({ Do-Ping })
            $timer.Start()
        }

        Do-Ping
    }
    else {
        Update-UI ([System.Windows.Media.Brushes]::Gray) "IP inválido"
    }
})

$Window.ShowDialog() | Out-Null