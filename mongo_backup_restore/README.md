## Project README

# MongoDB Backup and Restore Automation with Google Drive

This project contains two Bash scripts, `backup.sh` and `restore.sh`, which automate the process of backing up and restoring a MongoDB database in a Docker container. The backup is stored locally and then uploaded to Google Drive using `rclone`, providing a cost-effective alternative to traditional cloud storage solutions while maintaining security through Google authentication. 

## Motivation

*I used this for a personal project to bypass the need to pay for cloud services while enjoying the security benefits. All I needed to do was give google drive access to my team members to access the DB file.*

## Overview

- **backup.sh**: Automates the process of creating a MongoDB dump, copying it from a Docker container to the local filesystem, uploading the backup to Google Drive, and cleaning up old backups.
  
- **restore.sh**: Automates the process of listing available backups from Google Drive, downloading a chosen backup, restoring it into the MongoDB container, and cleaning up local files afterward.

This setup allows for secure, remote collaboration without compromising data integrity, as all backups are stored and retrieved through Google Drive's secure environment.

## Dependencies

- **Docker**: The MongoDB instance is expected to be running in a Docker container. The code will change to account for a different setup if mongo is standalone and not in a docker container
- **rclone**: A command-line tool to interact with cloud storage services like Google Drive.
  - You must configure `rclone` with access to your Google Drive.
- **MongoDB**: The database engine in the Docker container, used for `mongodump` and `mongorestore`.

## Setup Instructions

### 1. Install Dependencies

- **Install Docker (optional)**: 
  ```bash
  sudo apt install docker
  ```
  I used a docker container to run my mongo instance, but that is a choice, not a necessity

- **Install rclone**: 
  Follow the installation guide on the [rclone website](https://rclone.org/install/) and set it up with access to your Google Drive.

  Example for setting up Google Drive:
  ```bash
  rclone config
  ```
  This will open an interactive setup wizard where you can authenticate with Google Drive.

### 2. Configure rclone

Make sure you have a valid `rclone` configuration stored in `~/.config/rclone/rclone.conf`. This should contain your credentials to access your Google Drive.

### 3. Update Paths

Edit the following variables in the scripts to suit your setup:

- `LOCAL_BACKUP_DIR`: The local directory where backups are temporarily stored before uploading.
- `REMOTE_BACKUP_DIR`: The directory on Google Drive where backups will be stored (should match what you set up in `rclone`).
- `RCLONE_CONFIG_PATH`: Path to your `rclone` config file (default is `~/.config/rclone/rclone.conf`).

## Usage

### **1. Backup Script: `backup.sh`**

This script creates a backup of your MongoDB database and uploads it to Google Drive. It also retains only the three most recent backups, cleaning up older ones.

#### Steps:
1. **Create a MongoDB dump** in the running Docker container.
2. **Copy the backup** to the local filesystem.
3. **Upload the backup** to a specified Google Drive folder using `rclone`.
4. **Clean up old backups**, retaining only the three most recent backups in Google Drive.

#### Run the script:
```bash
./backup.sh
```

### **2. Restore Script: `restore.sh`**

This script allows you to select and restore a specific backup from Google Drive into your MongoDB instance.

#### Steps:
1. **List available backups** from Google Drive in reverse chronological order.
2. **Download the selected backup** to the local filesystem.
3. **Restore the backup** to the MongoDB container.
4. **Clean up the local backup file** after restoration.

#### Run the script:
```bash
./restore.sh
```

## Detailed Explanation of the Scripts

### **backup.sh**:
1. **Create a MongoDB dump**: 
   - It uses `mongodump` inside the Docker container to create a backup with gzip compression.
   - The backup is saved as a timestamped `.archive` file.
   
2. **Copy the backup to the local filesystem**:
   - After creating the backup inside the container, the script uses `docker cp` to copy the backup to the local host machine.
   
3. **Upload to Google Drive**: 
   - The backup is uploaded to a pre-configured Google Drive folder using `rclone`. This ensures secure storage and access control via Google authentication.
   
4. **Clean up older backups**: 
   - The script keeps only the three most recent backups on Google Drive and deletes older backups automatically to prevent clutter.

### **restore.sh**:
1. **List available backups**: 
   - It retrieves and lists the backups stored on Google Drive, sorting them in reverse chronological order and displaying them with human-readable timestamps.
   
2. **Prompt for user input**: 
   - The user selects which backup to restore by entering the corresponding number from the list.
   
3. **Download the selected backup**: 
   - The chosen backup is downloaded from Google Drive using `rclone`.
   
4. **Restore into MongoDB**: 
   - The backup is restored into the MongoDB Docker container using `mongorestore`. It drops the existing database before restoring the backup to ensure the data is fully replaced.
   
5. **Clean up**: 
   - The local backup file is deleted after a successful restore to keep the system clean.

## Security Considerations

- **Google Authentication**: Backups are stored securely on Google Drive using your Google account's authentication. This ensures that access to the backups is restricted and protected by Google's security features.
  
- **Data Integrity**: The script handles both creating and restoring backups in an automated, repeatable manner, ensuring that the process is reliable and reduces the risk of human error.

## Benefits

- **Cost-effective**: By using Google Drive with `rclone`, you avoid the costs of traditional cloud storage providers while still benefiting from secure storage.
- **Automated Cleanup**: The backup script automatically retains only the three most recent backups, saving space and ensuring that your Google Drive folder doesn’t become cluttered.
- **Collaboration**: This setup allows you to collaborate with remote partners securely, as the backups are accessible via Google Drive with proper authentication, avoiding the need for direct access to servers or databases.
