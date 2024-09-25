#!/bin/bash

# Define the local backup paths and Google Drive path
LOCAL_BACKUP_DIR="backups"
REMOTE_BACKUP_DIR="butlerai:/backups"
RCLONE_CONFIG_PATH="$HOME/.config/rclone/rclone.conf"  # Full path to rclone config

# Ensure the local backup directory exists
mkdir -p $LOCAL_BACKUP_DIR

# List available backups in Google Drive and convert timestamps to human-readable dates
echo "Available backups in Google Drive:"
BACKUPS=($(rclone --config $RCLONE_CONFIG_PATH lsf --files-only $REMOTE_BACKUP_DIR | sort -r))  # Reverse order and list files only

if [[ ${#BACKUPS[@]} -eq 0 ]]; then
    echo "No backups found in Google Drive."
    exit 1
fi

# Display the available backups with human-readable timestamps in reverse chronological order
for i in "${!BACKUPS[@]}"; do
    TIMESTAMP=$(echo "${BACKUPS[$i]}" | grep -oP '\d{14}')
    DATE=$(date -d "${TIMESTAMP:0:8} ${TIMESTAMP:8:2}:${TIMESTAMP:10:2}:${TIMESTAMP:12:2}" "+%Y-%m-%d %H:%M:%S")
    OPTION_NUM=$((i + 1))
    echo "$OPTION_NUM) Backup from $DATE"
done

# Prompt user to choose a backup by selecting the corresponding number
echo "Enter the number of the backup you want to restore:"
read backup_choice

# Adjust for 1-based indexing in the user prompt
backup_index=$((backup_choice - 1))

# Validate input
if [[ ! $backup_choice =~ ^[1-3]$ ]] || [[ $backup_index -ge ${#BACKUPS[@]} ]]; then
    echo "Invalid choice. Please enter a valid number (1, 2, or 3)."
    exit 1
fi

# Define the chosen backup file name
BACKUP_FILE="${BACKUPS[$backup_index]}"

# Download the chosen backup from Google Drive
echo "Downloading $BACKUP_FILE from Google Drive..."
rclone --config $RCLONE_CONFIG_PATH copy $REMOTE_BACKUP_DIR/$BACKUP_FILE $LOCAL_BACKUP_DIR/
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download the backup from Google Drive."
    exit 1
fi
echo "Backup downloaded from Google Drive."

# Verify the backup file path
echo "Expected backup file path: $LOCAL_BACKUP_DIR/$BACKUP_FILE"

# Check if the backup was downloaded successfully
if [[ ! -f "$LOCAL_BACKUP_DIR/$BACKUP_FILE" ]]; then
    echo "Error: Backup file not found locally after download. Tried to find it at $LOCAL_BACKUP_DIR/$BACKUP_FILE"
    exit 1
else
    echo "Backup file found: $LOCAL_BACKUP_DIR/$BACKUP_FILE"
fi

# Copy the backup to the MongoDB container
docker cp $LOCAL_BACKUP_DIR/$BACKUP_FILE butlerai-mongo-1:/data/backup.archive
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to copy the backup to the MongoDB container."
    exit 1
fi
echo "Backup copied to the container."

# Restore the backup inside the MongoDB container
docker exec butlerai-mongo-1 mongorestore --archive=/data/backup.archive --gzip --drop
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restore the backup inside the MongoDB container."
    exit 1
fi
echo "Data restore completed."

# Clean up the local backup
rm $LOCAL_BACKUP_DIR/$BACKUP_FILE
echo "Local backup file cleaned up."
