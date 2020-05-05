#!/bin/sh
# Ansible managed
# OpenBSD

# OpenSSH Server Key Re-Generation on first boot in new VM
if [ -f /etc/run-ssh-host-keygen-once ]; then
    # remove all host keys first, so that all will be refreshed
    rm -f /etc/ssh/*key*
    ssh-keygen -A
    rm -f /etc/run-ssh-host-keygen-once
fi
