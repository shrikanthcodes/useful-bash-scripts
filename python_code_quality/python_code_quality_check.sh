#!/bin/bash

# User-configurable variables
project_dir="/path/to/project"
report_file="code_quality_report.txt"

# Ensure the project directory exists
if [ ! -d "$project_dir" ]; then
    echo "Project directory does not exist: $project_dir"
    exit 1
fi

cd $project_dir

# Run linters and code quality tools
pylint *.py > $report_file
if [ $? -ne 0 ]; then
    echo "Pylint check failed"
    exit 1
fi

flake8 *.py >> $report_file
if [ $? -ne 0 ]; then
    echo "Flake8 check failed"
    exit 1
fi

echo "Code quality report generated at $report_file"
