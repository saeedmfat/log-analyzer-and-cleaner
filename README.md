# 📜 Log Analyzer & Cleaner for Ubuntu

A Bash script to **analyze system logs**, filter errors, and **automate log rotation**. Designed for sysadmins and DevOps to monitor and maintain log hygiene.

## 🚀 Features
- **Error Extraction**: Filters `ERROR`/`CRITICAL` entries from `/var/log/syslog`.
- **Timestamped Reports**: Saves logs with timestamps in `/var/log/log_analyzer/`.
- **Log Rotation**: Auto-deletes reports older than `7 days` (configurable).
- **Error Handling**: Checks for:
  - Log file readability.
  - Disk space before writing.
  - Permission issues.
- **Cron-Ready**: Designed for automated scheduling.

## 📦 Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/saeedmfat/log-analyzer-and-cleaner
   cd log-analyzer-and-cleaner