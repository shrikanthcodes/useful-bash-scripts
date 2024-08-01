#!/bin/bash

# User-configurable variables
project_dir="/path/to/project"
test_report="test_report.txt"

# Ensure the project directory exists
if [ ! -d "$project_dir" ]; then
    echo "Project directory does not exist: $project_dir"
    exit 1
fi

cd $project_dir

# Run tests
pytest > $test_report
if [ $? -ne 0 ]; then
    echo "Tests failed"
    exit 1
fi

echo "Test report generated at $test_report"
