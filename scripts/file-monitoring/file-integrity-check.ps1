<#
File: file-integrity-check.ps1
Purpose: Create and verify file integrity using SHA-256 hashes.
Baseline CSV will be saved inside the folder being monitored.
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("baseline","check")]
    [string]$Mode,

    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Validate path
if (!(Test-Path $Path)) {
    Write-Host "Path not found." -ForegroundColor Red
    exit
}

# Save the baseline CSV inside the monitored folder
$BaselineFile = Join-Path $Path "baseline_hashes.csv"

function Get-FileHashes {
    param($TargetPath)

    Get-ChildItem -Path $TargetPath -Recurse -File | Where-Object { $_.Name -ne "baseline_hashes.csv" } | ForEach-Object {

        try {
            $hash = Get-FileHash $_.FullName -Algorithm SHA256
            [PSCustomObject]@{
                Path = $_.FullName
                Hash = $hash.Hash
            }
        }
        catch {
            Write-Host "Cannot read file: $($_.FullName)" -ForegroundColor Yellow
        }
    }
}

# ----- Create Baseline -----
if ($Mode -eq "baseline") {
    Write-Host "Creating baseline hashes in $BaselineFile ..."
    $hashes = Get-FileHashes $Path
    $hashes | Export-Csv -Path $BaselineFile -NoTypeInformation
    Write-Host "Baseline saved successfully." -ForegroundColor Green
}

# ----- Integrity Check -----
if ($Mode -eq "check") {

    if (!(Test-Path $BaselineFile)) {
        Write-Host "Baseline file not found in $Path" -ForegroundColor Red
        exit
    }

    Write-Host "Checking file integrity..."

    $baseline = Import-Csv $BaselineFile
    $current = Get-FileHashes $Path

    foreach ($file in $baseline) {
        $match = $current | Where-Object { $_.Path -eq $file.Path }

        if (!$match) {
            Write-Host "File missing: $($file.Path)" -ForegroundColor Red
        }
        elseif ($match.Hash -ne $file.Hash) {
            Write-Host "File modified: $($file.Path)" -ForegroundColor Yellow
        }
    }

    foreach ($file in $current) {
        if ($baseline.Path -notcontains $file.Path) {
            Write-Host "New file detected: $($file.Path)" -ForegroundColor Cyan
        }
    }

    Write-Host "Integrity check complete." -ForegroundColor Green
}
