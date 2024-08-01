#!/bin/bash

# User-configurable variables
project_dir="/path/to/project"

# Ensure the project directory exists
if [ ! -d "$project_dir" ]; then
    echo "Project directory does not exist: $project_dir"
    exit 1
fi

# Update and install packages
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git
if [ $? -ne 0 ]; then
    echo "Package installation failed"
    exit 1
fi

# Set up virtual environment
cd $project_dir
python3 -m venv venv
source venv/bin/activate

# Install project dependencies
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Failed to install project dependencies"
    exit 1
fi

echo "Development environment setup completed"
