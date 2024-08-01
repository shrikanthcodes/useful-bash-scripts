#!/bin/bash

# User-configurable variables
src_dir="/path/to/files"
dest_dir="/path/to/organized_files"

# Ensure the source directory exists
if [ ! -d "$src_dir" ]; then
    echo "Source directory does not exist: $src_dir"
    exit 1
fi

# Create destination directories
mkdir -p $dest_dir/images $dest_dir/documents $dest_dir/archives

# Move files based on their extensions
mv $src_dir/*.{jpg,png,gif} $dest_dir/images/ 2>/dev/null
mv $src_dir/*.{pdf,docx,txt} $dest_dir/documents/ 2>/dev/null
mv $src_dir/*.{zip,tar.gz,rar} $dest_dir/archives/ 2>/dev/null

echo "Files organized in $dest_dir"
