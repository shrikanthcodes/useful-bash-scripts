#!/bin/bash

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

# Define the output file name
output_file="directory_structure.txt"

# Print the directory structure and save it to the output file
find "$directory_name" -print | sed -e 's;[^/]*/;|___;g;s;___|; |;g' > "$output_file"

echo "Directory structure saved to $output_file"
