# SOC-PowerShell-Labs

## Table of Contents
1. [Scripts Overview](#scripts-overview)
   - [Log Analysis Scripts](#1-log-analysis-scripts)
   - [File Monitoring Scripts](#2-file-monitoring-scripts)
2. [Notes](#notes)
3. [How to Use](#how-to-use)


This repository contains **PowerShell scripts for SOC (Security Operations Center) labs**, designed for learning and monitoring Windows security events and file integrity.

---

## Scripts Overview

### 1. Log Analysis Scripts
These scripts monitor Windows security events and user activity:

- #### event-log-monitor.ps1 
  Collects Windows Security events, including:
  - Login success
  - Login failure
  - Admin privilege events  

  **Usage:**
  ```powershell
  ./log-analysis/event-log-monitor.ps1
  ```

**Output:** 

Exports all collected events to CSV in the Logs folder.

#### failed-login-analysis.ps1
Summarizes failed Windows login attempts (Event ID 4625) from the last 7 days.
Flags potential brute-force attempts (5+ failed logins)

**Usage:**

```powershell
./log-analysis/failed-login-analysis.ps1
```

**Output:**

 CSV report of failed logins per user in the Logs folder.

#### user-activity-report.ps1
Tracks user logon and logoff activity.
Captures event type, time, user, and source

**Usage:**

```powershell
./log-analysis/user-activity-report.ps1
```

**Output:**

 CSV report summarizing user activity in the Logs folder.

### 2. File Monitoring Scripts

These scripts track changes to files and directories:

**file-integrity-check.ps1**
 Monitors files for:
  - Modified files
  - New files
  - Deleted files

**Create a baseline of hashes:**

```powershell
./file-monitoring/file-integrity-check.ps1 -Mode baseline -Path "C:\Path\To\Monitor"
```

**Check for changes:**

```powershell
./file-monitoring/file-integrity-check.ps1 -Mode check -Path "C:\Path\To\Monitor"
```

**Output:**

 Reports modified, new, or missing files. SHA-256 hashes are used to detect content changes. Baseline hashes are saved in a CSV inside the monitored folder.

**Notes**

The Logs folder is ignored in Git (.gitignore) for privacy.

Scripts are designed for SOC lab and educational purposes.

More monitoring scripts will be added in the future.

**How to Use**

**1. Clone the repository:**

```powershell
git clone https://github.com/eseigbeihinosen/soc-powershell-labs.git
```

**2. Navigate to the script folder:**

```powershell
cd soc-powershell-labs\scripts
```

**3. Run a script**:

**Log Analysis**

```powershell
./log-analysis/event-log-monitor.ps1
./log-analysis/failed-login-analysis.ps1
./log-analysis/user-activity-report.ps1
```

**File Monitoring**

```powershell
# Create baseline
./file-monitoring/file-integrity-check.ps1 -Mode baseline -Path "C:\Path\To\Monitor"

# Check for changes
./file-monitoring/file-integrity-check.ps1 -Mode check -Path "C:\Path\To\Monitor"
```

**4. Check output files:**
CSV files will be saved in the `Logs` folder for all scripts.


