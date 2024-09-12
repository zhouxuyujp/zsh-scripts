#!/bin/zsh

# Log file path passed as the first parameter
log_file="$1"

# Log backup directory passed as the second parameter
backup_dir="$2"

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Get the current date formatted as YYYYMMDD
current_date=$(date +"%Y%m%d")

# Backup file name
backup_file="$backup_dir/trojan-go-$current_date.log"

# Copy the log file to the backup directory and rename it
cp "$log_file" "$backup_file"

# Clear the original log file
> "$log_file"

# Delete logs older than 30 days in the backup directory
find "$backup_dir" -type f -name "*.log" -mtime +30 -exec rm {} \;

echo "Log has been backed up to $backup_file, and logs older than 30 days have been deleted."
