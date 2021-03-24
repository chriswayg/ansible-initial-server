#!/bin/bash
# Ansible managed
# Debian, Ubuntu

growpart -N /dev/sda 3
if [ $? -eq 0 ]; then
    echo "* auto-growing and resizing /dev/sda1"
    growpart /dev/sda 3
    xfs_growfs /dev/sda3
fi
