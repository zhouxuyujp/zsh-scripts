#!/bin/zsh

# Log file path passed as the first parameter
log_file="$1"

# Log backup directory passed as the second parameter
backup_dir="$2"

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Split the log by date and save it to the backup directory
awk '/^[0-9]{4}-[0-9]{2}-[0-9]{2}/ { log=substr($1, 0, 10); filename=strftime("trojan-go-%Y%m%d.log", mktime(gensub(/-/, " ", "g", log) " 00 00 00")); } { print $0 >> "'"$backup_dir"'/" filename }' "$log_file"

# Delete logs older than 30 days in the backup directory
find "$backup_dir" -type f -name "*.log" -mtime +30 -exec rm {} \;

# Optional: Clear the original log file (if needed, to prevent unlimited growth)
# > "$log_file"

echo "Logs have been split and backed up, logs older than 30 days have been deleted."
