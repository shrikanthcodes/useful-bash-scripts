#!/bin/bash

# Define the local backup paths and Google Drive path
LOCAL_BACKUP_DIR="backups"
REMOTE_BACKUP_DIR=":/backups"
RCLONE_CONFIG_PATH="$HOME/.config/rclone/rclone.conf"  # Full path to rclone config
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="backup-$TIMESTAMP.archive"

# Ensure the backups directory exists locally
mkdir -p $LOCAL_BACKUP_DIR

# Create a MongoDB dump
docker exec butlerai-mongo-1 mongodump --archive=/data/$BACKUP_FILE --gzip
echo "Local backup completed."

# Copy the backup from the container to the local filesystem
docker cp butlerai-mongo-1:/data/$BACKUP_FILE $LOCAL_BACKUP_DIR/$BACKUP_FILE
echo "Backup copied from container."

# Ensure the backup directory exists in Google Drive
rclone --config $RCLONE_CONFIG_PATH mkdir $REMOTE_BACKUP_DIR

# Upload the latest backup to Google Drive
rclone --config $RCLONE_CONFIG_PATH copy $LOCAL_BACKUP_DIR/$BACKUP_FILE $REMOTE_BACKUP_DIR/
echo "Backup uploaded to Google Drive."

# Clean up the local backup
rm $LOCAL_BACKUP_DIR/$BACKUP_FILE

# Keep only the three most recent backups in Google Drive
BACKUPS=$(rclone --config $RCLONE_CONFIG_PATH lsf $REMOTE_BACKUP_DIR | sort -r)
COUNT=0
for BACKUP in $BACKUPS; do
    if [[ $COUNT -ge 3 ]]; then
        rclone --config $RCLONE_CONFIG_PATH delete $REMOTE_BACKUP_DIR/$BACKUP
        echo "Deleted old backup: $BACKUP"
    fi
    COUNT=$((COUNT + 1))
done
