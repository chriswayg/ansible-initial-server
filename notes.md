# Notes

## QEMU Guest Agent not functional in OpenBSD

- qemu-ga can only be installed via `pkg_add qemu` which pulls in many dependencies.
- to try qemu enable 'QEMU Guest Agent' 'type ISA' in Proxmox
- run interactively: `qemu-ga -vm isa-serial -p /dev/cua01`
- shows: 'debug: disabling command: guest-network-get-interfaces' etc.
- if connected, it will show "execute":"guest-network-get-interfaces",
when entering the Summary tab on Proxmox
or "execute":"guest-shutdown", if trying to rebbot from Proxmox GUI
but Proxmox will show 'No network information' on the Summary tab
- shutdown or reboot from Proxmox do not work
- see here: https://www.qemu.org/docs/master/qemu-ga-ref.html

### qemu-ga configuration

`nano /etc/qemu/qemu-ga.conf`

```
[general]
daemonize = 0
pidfile = /var/run/qemu-ga.pid
verbose = 1
method = isa-serial
path = /dev/cua01
statedir = /var/run
```

## How .bashrc gets called in Debian 10

### user deploy logged in via SSH

```
ETC-PROFILE
DOT-PROFILE (b4 calling bashrc)
DOT-BASHRC DEPLOY (called from DOT-PROFILE)
DOT-PROFILE (after calling bashrc)
```

### root user logged in via SUDO

- Login shell

```
[deploy@proxmox:~]$ sudo su -
[deploy@proxmox:~]$ sudo su --login
[deploy@proxmox:~]$ sudo -i
ETC-PROFILE
DOT-PROFILE ROOT (b4 calling bashrc)
DOT-BASHRC ROOT
DOT-PROFILE ROOT (after calling bashrc)
```

- No login shell

```
[deploy@proxmox:~]$ sudo -s
[deploy@proxmox:~]$ sudo su
DOT-BASHRC ROOT
```
