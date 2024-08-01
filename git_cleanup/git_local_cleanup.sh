#!/bin/bash

# Fetch the latest changes
git fetch
if [ $? -ne 0 ]; then
    echo "Failed to fetch changes"
    exit 1
fi

# Get a list of merged branches
merged_branches=$(git branch --merged main | grep -v '^\*' | grep -v ' main$')

# Delete merged branches
for branch in $merged_branches; do
    git branch -d $branch
    if [ $? -ne 0 ]; then
        echo "Failed to delete branch $branch"
    fi
done

echo "Merged branches cleaned up"
