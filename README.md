# SOC-PowerShell-Labs

This repository contains **PowerShell scripts for SOC (Security Operations Center) labs**, designed for learning and monitoring Windows security events.

## Scripts

### 1. event-log-monitor.ps1
- Collects Windows Security events:
  - Login success
  - Login failure
  - Admin privilege events
- Exports the events to CSV in the `Logs` folder.

### 2. failed-login-analysis.ps1
- Collects failed Windows login events (Event ID 4625) from the last 7 days.
- Summarizes failed login attempts per user.
- Flags potential brute-force attempts (5+ failed logins).
- Exports the detailed results to CSV in the `Logs` folder.

### 3. user-activity-report.ps1
- Collects user logon and logoff activity.
- Generates a summary of activity per user.
- Captures event type, time, user, and source.
- Exports activity details to CSV in the `Logs` folder.

## Notes
- The **Logs folder** is ignored in Git (`.gitignore`) for privacy.
- Scripts are designed for **SOC lab and educational purposes**.
- More monitoring scripts will be added in the future.

## How to Use
1. Clone the repository:

```powershell
git clone https://github.com/eseigbeihinosen/soc-powershell-labs.git
```

2. Navigate to the script folder:

```powershell
cd soc-powershell-labs\scripts\log-analysis
```

3. Run a script:

```powershell
./event-log-monitor.ps1
# or
./failed-login-analysis.ps1
# or
./user-activity-report.ps1
```

4. Check the exported CSV files in the Logs folder.