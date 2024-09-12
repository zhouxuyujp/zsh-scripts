#!/bin/zsh

# Get log file path from the parameter
log_file=$1

# Define the backup directory for log files
backup_dir=~/log-backups

# Create the backup directory if it does not exist
mkdir -p "$backup_dir"

# Get the current date in YYYYMMDD format
current_date=$(date +"%Y%m%d")

# Define the backup file name
backup_file="$backup_dir/$(basename $log_file)-$current_date.log"

# Copy the log file to the backup directory and rename it
cp "$log_file" "$backup_file"

# Clear the original log file
> "$log_file"

# Delete logs older than 30 days in the backup directory
find "$backup_dir" -type f -name "*.log" -mtime +30 -exec rm {} \;

echo "Logs have been backed up to $backup_file. Logs older than 30 days have been deleted."
