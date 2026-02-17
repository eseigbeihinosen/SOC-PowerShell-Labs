# connection-monitor.ps1
# Monitors TCP and UDP connections and logs them

# -----------------------------
# Configuration
# -----------------------------
$folderPath = "C:\Users\domage\Documents\soc-powershell-labs\Scripts\Logs"
$logFile = Join-Path $folderPath "NetworkConnections.log"
$monitorInterval = 30  # seconds

# Ensure Logs folder and log file exist
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
}
if (-not (Test-Path $logFile)) {
    New-Item -ItemType File -Path $logFile -Force | Out-Null
}

# -----------------------------
# Function: Get current connections
# -----------------------------
function Get-NetworkConnections {
    $tcpConnections = Get-NetTCPConnection |
        Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess
    $udpConnections = Get-NetUDPEndpoint |
        Select-Object LocalAddress, LocalPort, OwningProcess

    return [PSCustomObject]@{
        TCP = $tcpConnections
        UDP = $udpConnections
    }
}

# -----------------------------
# Function: Write connections to log
# -----------------------------
function Write-NetworkConnections {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $connections = Get-NetworkConnections

    # Log TCP connections
    Add-Content -Path $logFile -Value "=== $timestamp - TCP Connections ==="
    $connections.TCP | ForEach-Object {
        $line = "Local: $($_.LocalAddress):$($_.LocalPort) -> Remote: $($_.RemoteAddress):$($_.RemotePort) | State: $($_.State) | PID: $($_.OwningProcess)"
        Add-Content -Path $logFile -Value $line
    }

    # Log UDP connections
    Add-Content -Path $logFile -Value "=== $timestamp - UDP Connections ==="
    $connections.UDP | ForEach-Object {
        $line = "Local: $($_.LocalAddress):$($_.LocalPort) | PID: $($_.OwningProcess)"
        Add-Content -Path $logFile -Value $line
    }

    Add-Content -Path $logFile -Value "`n"
}

# -----------------------------
# Continuous monitoring
# -----------------------------
Write-Host "Starting network monitoring..."
Write-Host "Logging every $monitorInterval seconds to: $logFile"

while ($true) {
    Write-NetworkConnections
    Start-Sleep -Seconds $monitorInterval
}



