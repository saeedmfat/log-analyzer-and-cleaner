#!/bin/bash

# Configuration
LOG_FILE="/var/log/syslog"
OUTPUT_DIR="/var/log/log_analyzer"
REPORT="$OUTPUT_DIR/error_report_$(date +'%Y-%m-%d').txt"
RETENTION_DAYS=7

# ERROR HANDLING FUNCTIONS
error_exit() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" >&2  # Print to stderr
    exit 1
}

check_disk_space() {
    local min_space_mb=10  # Minimum required space (MB)
    local available=$(df -m "$OUTPUT_DIR" | awk 'NR==2 {print $4}')

    if [ "$available" -lt "$min_space_mb" ]; then
        error_exit "Low disk space ($available MB left). Required: $min_space_mb MB."
    fi
}

#--- START SCRIPT ---#
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting log analysis..."

# Check if log file exists and is readable
if [ ! -f "$LOG_FILE" ] || [ ! -r "$LOG_FILE" ]; then
    error_exit "Cannot read log file: $LOG_FILE"
fi

# Check disk space
check_disk_space

# Create output directory (with error handling)
mkdir -p "$OUTPUT_DIR" || error_exit "Failed to create directory: $OUTPUT_DIR"

# Filter errors and handle empty results
grep -i "error" "$LOG_FILE" > "/tmp/errors.tmp" || {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] No errors found in $LOG_FILE" >> "$REPORT"
    exit 0  # Exit gracefully if no errors
}

# Process errors and write to report
while read -r line; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $line" >> "$REPORT"
done < "/tmp/errors.tmp"
rm "/tmp/errors.tmp"

# Log rotation (with error handling)
find "$OUTPUT_DIR" -name "error_report_*.txt" -type f -mtime +$RETENTION_DAYS -delete || {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: Failed to delete old reports" >> "$REPORT"
}

# Completion message
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Analysis complete. Report saved: $REPORT"
