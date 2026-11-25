Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Ping Monitor"
        Height="180"
        Width="450"
        ResizeMode="NoResize"
        WindowStartupLocation="CenterScreen">

    <Grid Margin="10">

        <Border BorderBrush="Black"
                BorderThickness="2"
                CornerRadius="5"
                Padding="10">

            <Grid>

                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="40"/>
                    <ColumnDefinition Width="180"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <TextBlock Grid.Row="0"
                           Grid.Column="0"
                           Text="IP"
                           VerticalAlignment="Center"
                           FontSize="16"/>

                <TextBox Name="txtIP"
                         Grid.Row="0"
                         Grid.Column="1"
                         Height="35"
                         FontSize="18"/>

                <Ellipse Name="StatusLed"
                         Grid.Row="0"
                         Grid.Column="2"
                         Width="25"
                         Height="25"
                         Fill="Gray"
                         HorizontalAlignment="Left"
                         Margin="30,0,0,0"/>

                <TextBlock Grid.Row="1"
                           Grid.Column="0"
                           Text="MS"
                           VerticalAlignment="Center"
                           FontSize="16"
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
$StatusLed = $Window.FindName("StatusLed")

$CurrentIP = ""

$PingTimer = New-Object System.Windows.Threading.DispatcherTimer
$PingTimer.Interval = [TimeSpan]::FromSeconds(2)

function Test-HostPing {

    if ([string]::IsNullOrWhiteSpace($CurrentIP))
    {
        $StatusLed.Fill = "Gray"
        $txtMS.Text = ""
        return
    }

    try
    {
        $ping = New-Object System.Net.NetworkInformation.Ping
        $reply = $ping.Send($CurrentIP,1000)

        if ($reply.Status -eq "Success")
        {
            $StatusLed.Fill = "LimeGreen"
            $txtMS.Text = "$($reply.RoundtripTime) ms"
        }
        else
        {
            $StatusLed.Fill = "Red"
            $txtMS.Text = "TIMEOUT"
        }
    }
    catch
    {
        $StatusLed.Fill = "Red"
        $txtMS.Text = "ERRO"
    }
}

$txtIP.Add_TextChanged({

    $ip = $txtIP.Text.Trim()

    # IPv4 completo
    if ($ip -match '^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$')
    {
        if ($CurrentIP -ne $ip)
        {
            $CurrentIP = $ip

            Test-HostPing

            if (-not $PingTimer.IsEnabled)
            {
                $PingTimer.Start()
            }
        }
    }
    else
    {
        $CurrentIP = ""

        $PingTimer.Stop()

        $StatusLed.Fill = "Gray"
        $txtMS.Text = ""
    }
})

$PingTimer.Add_Tick({
    Test-HostPing
})

$Window.ShowDialog() | Out-Null