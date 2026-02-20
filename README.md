# SOC-PowerShell-Labs

## Table of Contents
1. [Scripts Overview](#scripts-overview)
   - [Log Analysis Scripts](#1-log-analysis-scripts)
   - [File Monitoring Scripts](#2-file-monitoring-scripts)
   - [Process Monitoring Scripts](#3-process-monitoring-scripts)
   - [Network Monitoring Scripts](#4-network-monitoring-scripts)
2. [Notes](#notes)
3. [How to Use](#how-to-use)

This repository contains **PowerShell scripts for SOC (Security Operations Center) labs**, designed for learning and monitoring Windows security events, file integrity, running processes, and network activity.

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

- #### failed-login-analysis.ps1
  Summarizes failed Windows login attempts (Event ID 4625) from the last 7 days.
  Flags potential brute-force attempts (5+ failed logins).

  **Usage:**
  ```powershell
  ./log-analysis/failed-login-analysis.ps1
  ```

  **Output:**
  CSV report of failed logins per user in the Logs folder.

- #### user-activity-report.ps1
  Tracks user logon and logoff activity.
  Captures event type, time, user, and source.

  **Usage:**
  ```powershell
  ./log-analysis/user-activity-report.ps1
  ```

  **Output:**
  CSV report summarizing user activity in the Logs folder.

### 2. File Monitoring Scripts

These scripts track changes to files and directories:

- **file-integrity-check.ps1**
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
  Reports modified, new, or missing files.
  SHA-256 hashes are used to detect content changes.
  Baseline hashes are saved in a CSV inside the monitored folder.

### 3. Process Monitoring Scripts

These scripts monitor running processes on Windows:

- **process-monitor.ps1**
  Continuously monitors all processes in real time:
  - Detects new processes starting
  - Detects stopped processes
  - Logs events with timestamps and PIDs

  **Usage:**
  ```powershell
  ./process-monitoring/process-monitor.ps1
  ```

  **Output Example:**
  ```powershell
  2026-02-13 08:52:00 - New Process Started: dllhost (PID: 18720)
  2026-02-13 08:52:00 - Process Stopped: backgroundTaskHost (PID: 11980)
  2026-02-13 08:52:05 - Process Stopped: dllhost (PID: 18720)
  2026-02-13 08:52:15 - Process Stopped: chrome (PID: 1384)
  ```

  **Notes:**
  - Chrome and other apps may produce multiple entries due to multiple internal processes.
  - Logs are saved in `C:\Temp\ProcessMonitorLog.txt` by default.
  - PID (Process ID) is the unique identifier assigned to each running process.

### 4. Network Monitoring Scripts

These scripts monitor network activity on the system:

- **connection-monitor.ps1**
  Continuously monitors active network connections (TCP and UDP):
  - Tracks local and remote IP addresses
  - Logs ports and connection states
  - Records Process IDs (PID) for each connection
  - Captures activity at regular intervals

 **Usage:**
 ```powershell
 ./network-monitoring/connection-monitor.ps1
 ```

 **Output:**
 Logs network connections to:

 `scripts\Logs\NetworkConnections.log`

**Output Example:**
```powershell
=== 2026-02-20 15:30:00 - TCP Connections ===
Local: 192.168.1.5:52345 -> Remote: 142.250.190.78:443 | State: Established | PID: 4321

=== 2026-02-20 15:30:00 - UDP Connections ===
Local: 192.168.1.5:5353 | PID: 1234
```

 **Notes:**
- Runs continuously until stopped manually (Ctrl + C).
- Default logging interval is 30 seconds.
- Useful for detecting unusual or unauthorized network activity.
- Helps map processes to active network connections during investigations.

## Notes
- The Logs folder is ignored in Git (.gitignore) for privacy.
- Scripts are designed for SOC labs and educational purposes.
- More monitoring scripts will be added in the future.

## How to Use
### 1. Clone the repository:
```powershell
git clone https://github.com/eseigbeihinosen/soc-powershell-labs.git
```

### 2. Navigate to the script folder:
```powershell
cd soc-powershell-labs\scripts
```

### 3. Run a script:
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

**Process Monitoring**
```powershell
./process-monitoring/process-monitor.ps1
```

**Network Monitoring**
```powershell
./network-monitoring/connection-monitor.ps1
```
### 4. Check output files:
CSV files for log analysis and file monitoring will be in the Logs folder.
Process monitoring logs will be in `C:\Temp\ProcessMonitorLog.txt`.
Network monitoring logs will be in `scripts\Logs\NetworkConnections.log`.