

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
