# failed-login-analysis.ps1
# SOC Lab - Failed Login Analysis

# Define CSV output path (Logs folder inside scripts/)
$logPath = "$PSScriptRoot\..\Logs\FailedLogins.csv"

# Ensure the Logs folder exists
$logFolder = Split-Path $logPath
if (-not (Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Number of days to look back
$daysToCheck = 7
$maxEvents = 500  # Limit for lab purposes

Write-Output "Collecting failed login events..."

# Get failed login events (Event ID 4625)
try {
    $failedEvents = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        ID = 4625
        StartTime = (Get-Date).AddDays(-$daysToCheck)
    } -MaxEvents $maxEvents -ErrorAction Stop
}
catch {
    Write-Output "No failed login events found in the last $daysToCheck day(s)."
    return
}

# If no events found, exit gracefully
if (-not $failedEvents) {
    Write-Output "No failed login events found in the last $daysToCheck day(s)."
    return
}

# Extract essential info: Time, User, IP, Failure Reason
$failedEventsInfo = $failedEvents | Select-Object TimeCreated,
    @{Name='User';Expression={
        if ($_.Properties.Count -ge 5) { $_.Properties[5].Value } else { 'N/A' }
    }},
    @{Name='IP';Expression={
        if ($_.Properties.Count -ge 19 -and $_.Properties[18].Value -match '^\d{1,3}(\.\d{1,3}){3}$') {
            $_.Properties[18].Value
        } else { 'Local/System' }
    }},
    @{Name='FailureReason';Expression={
        if ($_.Properties.Count -ge 6) { $_.Properties[6].Value } else { 'N/A' }
    }}


# Optional: summarize repeated failed logins per user
$userSummary = $failedEventsInfo | Group-Object User | Select-Object Name, Count
Write-Output "Summary of failed login attempts per user:"
$userSummary | Format-Table -AutoSize

# Flag users with 5+ failed login attempts
$threshold = 5
$bruteForceUsers = $userSummary | Where-Object { $_.Count -ge $threshold }

if ($bruteForceUsers) {
    Write-Output "`nPotential brute-force attempts detected:"
    $bruteForceUsers | Format-Table -AutoSize
} else {
    Write-Output "`nNo brute-force attempts detected."
}


# Export details to CSV
$failedEventsInfo | Export-Csv $logPath -NoTypeInformation

Write-Output "Export complete! $($failedEventsInfo.Count) failed login events saved to Logs."
