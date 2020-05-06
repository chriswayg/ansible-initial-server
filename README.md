ansible-initial-server
======================
[![Build Status](https://travis-ci.org/chriswayg/ansible-initial-server.svg?branch=master)](https://travis-ci.org/chriswayg/ansible-initial-server)

Initial configuration of a freshly installed Debian/Ubuntu or OpenBSD server to be used as a template in KVM.

- use the latest Github **tagged version** which has been tested more thoroughly than 'master'

Requirements
------------

### Install from ISO (or use packer-proxmox-templates)
- this role is used by [packer-proxmox-templates](https://github.com/chriswayg/packer-proxmox-templates)

Use with a default install of **Debian 10** net-install ISO
- installed from debian-10.x.y-amd64-netinst.iso
- include ssh server
- an auto-install 'preseed.cfg' file can be used to speed-up the initial install

Use with a default install of **Ubuntu 18.04** server ISO
- installed from ubuntu-18.04.x-server-amd64.iso (not live-server!)
- Software: Standard System Utilities and SSH Server (Standard and Server in Ubuntu)
- Default user `deploy` (customizable)
- Partitions: 1 primary ext4 root partition /dev/sda1 (no swap); Grub on MBR
- an auto-install 'preseed.cfg' file can be used to speed-up the initial install

Use with a default install of **Ubuntu 20.04** server ISO
- installed from ubuntu-20.04.x-legacy-server-amd64.iso (not live-server!)
- Software: Standard System Utilities and SSH Server (Standard and Server in Ubuntu)
- Default user `deploy` (customizable)
- Partitions: 1 primary ext4 root partition /dev/sda1 (no swap); Grub on MBR
- an auto-install 'preseed.cfg' file can be used to speed-up the initial install

Use with a default install of **OpenBSD 6.x** server ISO
- installed from install6x.iso
- installed with all file sets (or drop optional -comp* -game* -x*)
- requires python to be installed first
- an auto-install 'install.conf' file can be used to speed-up the initial install

Use with a default install of **Alpine 3.x** server ISO
- installed from alpine-virt-3.x.y-x86_64.iso
- an auto-install 'answers' file can be used to speed-up the initial install

### Configuration features - Debian/Ubuntu
- qemu-guest-agent for Packer SSH and in Proxmox for shutdown and backups
- haveged random number generator to speed up boot
- passwordless sudo for default user 'deploy' (name can be changed)
- SSH public key installed for default user with only key login permitted
- no login for root (optional)
- display IP and SSH fingerprint before console login
- serial console
- generates new SSH host keys on first boot to avoid duplicates in cloned VMs
- automatically grow partition after resizing VM disk
- optional SSH warning banner
- optional Verse of the Day displayed on motd

### Configuration features - Alpine
- qemu-guest-agent for Packer SSH and in Proxmox for shutdown and backups
- passwordless sudo for default user 'deploy' (name can be changed)
- SSH public key installed for default user with only key login permitted
- no login for root (optional)
- display IP and SSH fingerprint before console login
- serial console
- generates new SSH host keys on first boot to avoid duplicates in cloned VMs
- automatically grow partition after resizing VM disk
- optional SSH warning banner

### Configuration features - OpenBSD
- passwordless doas for default user 'deploy' (name can be changed)
- SSH public key installed for default user with only key login permitted
- no login for root (optional)
- display IP and SSH fingerprint before console login
- serial console
- generates new SSH host keys on first boot to avoid duplicates in cloned VMs
- optional SSH warning banner

#### Vanilla
Running the role with the `vanilla` tag will only make minimal modifications to the system:
- passwordless sudo/doas for default user 'deploy' (name can be changed)
- SSH public key installed for default user with only key login permitted
- no login for root
- serial console
- no change to repositories
- set hostname and /etc/hosts
- set timezone
- no customization to motd, bashrc, etc.
- will not disable Ubuntu swapfile
- will not display IP and SSH fingerprint before console login
- will not automatically grow partition after resizing VM disk
- check tasks/main.yml and other task files to see what else is excluded

### After Installation from ISO
- check networking, that the VM is reachable via SSH

Important Role Variables
------------------------
`iserver_user`
- Username of the default user

`iserver_[OS]_repos`
- List of repositories which will replace the initial defaults

`iserver_[OS]_packages`
- List of system utilities to install

`iserver_hostname` and `iserver_domain`

`iserver_sshkey`
- SSH-key of the default user

Important Flags
---------------
`iserver_is_a_vm`
- set to False when using the role on bare metal server

`iserver_lock_root`
- set to True in order to disallow root login even on console

`set_fixed_IP`
- set to True if configuring a static IP

`iserver_verse_enabled`
- show a Verse of the Day on motd

Tags
----
`vanilla`
- only make minimal modifications

`is_template`
- include additional tasks useful for Proxmox templates

`travis`
- these tasks will be skipped in Travis testing

Check which tasks are going to be executed (example)
```
ansible-playbook -v server-template.yml --tags "vanilla,is_template" --skip-tags "openbsd,alpine" --list-tasks
```

Example Playbook
----------------

Name of playbook: `server-template.yml`
- make sure the correct username is used, which is the default user name set up during iso installation

```yml
- name: Initial configuration of a server.
  hosts: servers
  user: deploy
  vars_files:
    - server-template-vars.yml
  roles:
    - role: ansible-initial-server
      vars:
        iserver_user: deploy
```

The Debian installer by default creates a root user with a root password, who is not permitted to SSH in to the server. Sudo is not installed by default. Therefore the default user can SSH into Debian, but has to use `su` to do roots tasks. There is no need to change `sshd_config` to `PermitRootLogin yes`, because this Ansible role can authenticate with the initial user password and then 'become' root using 'su'.

For the first run on Debian (before sudo is active & the SSH key has been transferred):

- `ansible-playbook --ask-pass --ask-become-pass -e iserver_become=su  -v server-template.yml`


For the first run on Ubuntu (before the SSH key has been transferred):

- `ansible-playbook --ask-pass --ask-become-pass -v server-template.yml`


For the first run on Alpine (as root before the SSH key has been transferred):

- `ansible-playbook --ask-pass -v server-template.yml`

For subsequent runs or on installations which have sudo/doas and SSH-key already enabled:

- `ansible-playbook -v server-template.yml`


License
-------

MIT

Author Information
------------------

Christian Wagner
