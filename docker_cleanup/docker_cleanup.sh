#!/bin/bash

# Remove stopped containers
docker container prune -f
if [ $? -ne 0 ]; then
    echo "Failed to remove stopped containers"
    exit 1
fi

# Remove unused images
docker image prune -a -f
if [ $? -ne 0 ]; then
    echo "Failed to remove unused images"
    exit 1
fi

# Remove unused volumes
docker volume prune -f
if [ $? -ne 0 ]; then
    echo "Failed to remove unused volumes"
    exit 1
fi

echo "Docker cleanup completed"
