#!/bin/bash

# User-configurable variables
source_dir="/path/to/source"
dest_dir="/path/to/destination"

# Ensure the source and destination directories exist
if [ ! -d "$source_dir" ]; then
    echo "Source directory does not exist: $source_dir"
    exit 1
fi

if [ ! -d "$dest_dir" ]; then
    echo "Destination directory does not exist: $dest_dir"
    exit 1
fi

rsync -av --delete "$source_dir/" "$dest_dir/"
if [ $? -ne 0 ]; then
    echo "File sync failed"
    exit 1
fi

echo "File sync completed from $source_dir to $dest_dir"
