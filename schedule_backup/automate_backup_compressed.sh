#!/bin/bash

# User-configurable variables
src_dir="/path/to/source"
backup_dir="/path/to/backup"
num_backups=5
time_interval="daily"  # Options: minutely, hourly, daily, weekly, monthly, yearly

timestamp=$(date +%Y%m%d%H%M%S)
backup_file="$backup_dir/backup_$timestamp.tar.gz"

# Create a compressed backup
tar -czf "$backup_file" -C "$src_dir" .
if [ $? -ne 0 ]; then
    echo "Backup failed"
    exit 1
fi

# Remove old backups, keeping only the latest $num_backups
ls -1dt $backup_dir/backup_*.tar.gz | tail -n +$((num_backups + 1)) | xargs rm -f

echo "Backup completed: $backup_file"

# Schedule the script based on the user-defined time interval
schedule_script() {
    cron_expr="$1"
    script_path="$(realpath $0)"
    cron_job="$cron_expr $script_path"
    
    # Check if the cron job already exists
    (crontab -l | grep -v -F "$script_path"; echo "$cron_job") | crontab -
}

case $time_interval in
    minutely)
        schedule_script "* * * * *"
        ;;
    hourly)
        schedule_script "0 * * * *"
        ;;
    daily)
        schedule_script "0 0 * * *"
        ;;
    weekly)
        schedule_script "0 0 * * 0"
        ;;
    monthly)
        schedule_script "0 0 1 * *"
        ;;
    yearly)
        schedule_script "0 0 1 1 *"
        ;;
    *)
        echo "Invalid time interval specified: $time_interval"
        ;;
esac
