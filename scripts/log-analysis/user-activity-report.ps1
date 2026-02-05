# user-activity-report.ps1
# SOC Lab - User Activity Report
# Generates a report of user logon activity from Windows Security logs

# Output CSV path (Logs folder inside scripts/)
$logPath = "$PSScriptRoot\..\Logs\UserActivityReport.csv"

# Ensure Logs folder exists
$logFolder = Split-Path $logPath
if (-not (Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder | Out-Null
}

# Days to look back
$daysToCheck = 7
$maxEvents = 1000

Write-Output "Collecting user activity events..."

# Event IDs:
# 4624 = Successful logon
# 4634 = Logoff
# 4647 = User initiated logoff
$eventIDs = 4624,4634,4647

try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName   = 'Security'
        ID        = $eventIDs
        StartTime = (Get-Date).AddDays(-$daysToCheck)
    } -MaxEvents $maxEvents -ErrorAction Stop
}
catch {
    Write-Output "No activity events found."
    return
}

if (-not $events) {
    Write-Output "No activity events found."
    return
}

# Extract useful info
$activityInfo = $events | Select-Object TimeCreated,
    @{Name='EventID';Expression={$_.Id}},
    @{Name='Activity';Expression={
        switch ($_.Id) {
            4624 { "Logon Success" }
            4634 { "Logoff" }
            4647 { "User Logoff" }
            default { "Other" }
        }
    }},
    @{Name='User';Expression={
        if ($_.Properties.Count -ge 6) { $_.Properties[5].Value } else { 'N/A' }
    }},
    @{Name='SourceIP';Expression={
        if ($_.Properties.Count -ge 19 -and $_.Properties[18].Value -match '^\d{1,3}(\.\d{1,3}){3}$') {
            $_.Properties[18].Value
        } else { 'Local/System' }
    }}

# Summary per user
$userSummary = $activityInfo | Group-Object User | Select-Object Name, Count

Write-Output "`nUser activity summary:"
$userSummary | Format-Table -AutoSize

# Export CSV
$activityInfo | Export-Csv $logPath -NoTypeInformation

Write-Output "`nReport exported to Logs folder."
Write-Output "Total events exported: $($activityInfo.Count)"
