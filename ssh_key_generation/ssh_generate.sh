#!/bin/bash

# User-configurable variables
ssh_key_file="$HOME/.ssh/id_rsa"

# Generate SSH key if it does not exist
if [ ! -f "$ssh_key_file" ]; then
    ssh-keygen -t rsa -b 4096 -f "$ssh_key_file" -N ""
    if [ $? -ne 0 ]; then
        echo "SSH key generation failed"
        exit 1
    fi
    echo "SSH key pair generated"
else
    echo "SSH key pair already exists"
fi

cat "$ssh_key_file.pub"
