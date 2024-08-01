# Automate Backup with Compression

**Script Path:** `automate_backup_compressed.sh`

**Description:** 
Creates compressed backups, retains a specified number of backups, and schedules the script to run at specified intervals.

## Requirements
- `tar` command available on the system.
- `crontab` command available on the system.

## User-configurable variables
- `src_dir`: Directory to back up.
- `backup_dir`: Directory to store backups.
- `num_backups`: Number of backups to keep.
- `time_interval`: Interval for running the script (options: minutely, hourly, daily, weekly, monthly, yearly).
