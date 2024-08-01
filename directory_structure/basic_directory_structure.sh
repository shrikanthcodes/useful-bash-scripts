#!/bin/bash

# User-configurable variables
output_file="directory_structure.txt"
exclusions=(
    ".git*"
    "__pycache__"
    "*.pyc"
)

# Check if a directory name was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_name>"
    exit 1
fi

directory_name="$1"

# Check if the given directory exists
if [ ! -d "$directory_name" ]; then
    echo "Directory does not exist: $directory_name"
    exit 1
fi

# Construct the find command with exclusions
exclude_args=""
for pattern in "${exclusions[@]}"; do
    exclude_args+=" -path \"*/${pattern}\" -prune -o"
done

# Run the find command with exclusions
eval "find \"$directory_name\" $exclude_args -print | sed -e 's;[^/]*/;|___;g;s;___|; |;g' > \"$output_file\""

echo "Directory structure saved to $output_file"
