#!/bin/bash

# User-configurable variables
src_dir="/path/to/source"
backup_dir="/path/to/backup"
num_backups=5

timestamp=$(date +%Y%m%d%H%M%S)
backup_name="backup_$timestamp"

# Ensure the source directory exists
if [ ! -d "$src_dir" ]; then
    echo "Source directory does not exist: $src_dir"
    exit 1
fi

# Create backup
cp -r "$src_dir" "$backup_dir/$backup_name"
if [ $? -ne 0 ]; then
    echo "Backup failed"
    exit 1
fi

# Remove old backups
ls -1dt $backup_dir/backup_* | tail -n +$((num_backups + 1)) | xargs rm -rf

echo "Backup completed: $backup_dir/$backup_name"
