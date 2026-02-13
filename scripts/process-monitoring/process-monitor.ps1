# =========================================
# Process Monitoring Script
# =========================================

# Set the log file path
$logFile = "C:\Temp\ProcessMonitorLog.txt"

# Ensure log directory exists
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Store the initial snapshot of running processes
$previousProcesses = Get-Process | Select-Object Name, Id

Write-Host "Process monitoring started. Press Ctrl+C to stop."
Write-Host "Logging to $logFile"

# Infinite loop to monitor processes every 5 seconds
while ($true) {
    Start-Sleep -Seconds 5

    # Get the current running processes
    $currentProcesses = Get-Process | Select-Object Name, Id

    # Detect new processes
    $newProcesses = Compare-Object -ReferenceObject $previousProcesses -DifferenceObject $currentProcesses -Property Id, Name -PassThru | Where-Object { $_.SideIndicator -eq "=>" }

    # Detect stopped processes
    $stoppedProcesses = Compare-Object -ReferenceObject $previousProcesses -DifferenceObject $currentProcesses -Property Id, Name -PassThru | Where-Object { $_.SideIndicator -eq "<=" }

    # Log new processes
    foreach ($proc in $newProcesses) {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - New Process Started: $($proc.Name) (PID: $($proc.Id))"
        Write-Host $logEntry -ForegroundColor Green
        Add-Content -Path $logFile -Value $logEntry
    }

    # Log stopped processes
    foreach ($proc in $stoppedProcesses) {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Process Stopped: $($proc.Name) (PID: $($proc.Id))"
        Write-Host $logEntry -ForegroundColor Red
        Add-Content -Path $logFile -Value $logEntry
    }

    # Update the snapshot
    $previousProcesses = $currentProcesses
}
