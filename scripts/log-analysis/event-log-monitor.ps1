# event-log-monitor.ps1
# SOC Lab - Windows Event Log Monitoring (Optimized)

# Define CSV output path (Logs folder inside scripts/)
$logPath = "$PSScriptRoot\..\Logs\SecurityEvents.csv"

# Ensure the Logs folder exists
$logFolder = Split-Path $logPath
if (-not (Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Number of days to look back and max events to retrieve
$daysToCheck = 1
$maxEvents = 200  # Limit number of events for lab purposes

Write-Output "Collecting events..."

# Get the most recent 200 events of interest in the last day
$events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4624,4625,4672
    StartTime = (Get-Date).AddDays(-$daysToCheck)
} -MaxEvents $maxEvents

# Select only essential info: time, event ID, user (if available)
$events | Select-Object TimeCreated, Id,
    @{Name='User';Expression={
        if ($_.Properties.Count -ge 6) { $_.Properties[5].Value } else { 'N/A' }
    }},
    Message |
Export-Csv $logPath -NoTypeInformation

Write-Output "Export complete! $($events.Count) events saved to Logs."

