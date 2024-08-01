#!/bin/bash

# User-configurable variables
project_dir="/path/to/project"
docs_dir="$project_dir/docs"

# Ensure the project directory exists
if [ ! -d "$project_dir" ]; then
    echo "Project directory does not exist: $project_dir"
    exit 1
fi

# Navigate to the project directory
cd $project_dir

# Generate documentation
sphinx-apidoc -o $docs_dir/source $project_dir
if [ $? -ne 0 ]; then
    echo "Sphinx documentation generation failed"
    exit 1
fi

cd $docs_dir
make html
if [ $? -ne 0 ]; then
    echo "HTML documentation build failed"
    exit 1
fi

echo "Documentation generated at $docs_dir/build/html"
