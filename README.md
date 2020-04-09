ansible-initial-server
======================

Initial configuration of a freshly installed Debian or Ubuntu server to be used as a template in KVM.

- use the latest tagged version which has been tested more thoroughly than 'master'

Requirements
------------

### Install from ISO
Tested with a default install of Debian 10 net-install ISO
- installed from debian-10.x.y-amd64-netinst.iso

Also tested with a default install of Ubuntu 18.04 server ISO
- installed from ubuntu-18.04.3-server-amd64.iso (not live-server)

- Software: Standard System Utilities and SSH Server (Standard and Server in Ubuntu)
- Default user `deploy` (customizable)
- Partitions: 1 primary ext4 root partition /dev/sda1 (no swap); Grub on MBR
- an auto-install http/preseed.cfg can be used to speed-up the initial install
- used by [packer-proxmox-templates](https://github.com/chriswayg/packer-proxmox-templates)

### Configuration features
- qemu-guest-agent for Packer SSH and in Proxmox for shutdown and backups
- haveged random number generator to speed up boot
- passwordless sudo for default user 'deploy' (name can be changed)
- SSH public key installed for default user with only key login
- no login for root
- display IP and SSH fingerprint before console login
- serial console
- generates new SSH host keys on first boot to avoid duplicates in cloned VMs
- automatically grow partition after resizing VM disk
- optional SSH warning banner
- optional Verse of the Day displayed on motd

#### Vanilla
Running the role with the `vanilla` tag will only make minimal modifications to the system after an initial ISO installation:
- passwordless sudo for default user 'deploy' (name can be changed)
- SSH public key installed for default user with only key login
- no login for root
- serial console
- no change to apt sources.list and no installation of additional base packages
- set hostname and /etc/hosts
- set timezone
- no customization to motd, bashrc, etc.
- does not disable Ubuntu swapfile
- will not automatically grow partition after resizing VM disk
- check tasks/main.yml and others to see what else is excluded

### After Installation from ISO
- check networking, that the VM is reachable via SSH

Important Role Variables
--------------
`iserver_user`
- Username of the default user

`iserver_repos`
- List of repositories which will replace the initial defaults

`iserver_packages`
- List of system utilities to install

`iserver_hostname` and `iserver_domain`

`iserver_sshkey`
- SSH-key of the default user

Example Playbook
----------------

Name of playbook: `server-template.yml`
- make sure the correct username is used, which is the default user name set up during iso installation

```yml
- name: Initial configuration of a server.
  hosts: servers
  user: administrator
  vars_files:
    - server-template-vars.yml
  roles:
    - role: ansible-initial-server
      vars:
        iserver_user: administrator
```

The Debian installer by default creates a root user with a root password, who is not permitted to SSH in to the server. Sudo is not installed by default. Therefore the default user can SSH into Debian, but has to use `su` to do roots tasks. There is no need to change `sshd_config` to `PermitRootLogin yes`, because this Ansible role can authenticate with the initial user password and then 'become' root using 'su'.

Only for the first run on Debian (before sudo is active & the SSH key has been transferred):

- `ansible-playbook --ask-pass --ask-become-pass -e iserver_become=su  -v server-template.yml`


For subsequent runs or on installations which have sudo and SSH-key already enabled:

- `ansible-playbook --v server-template.yml`


For the first run on Ubuntu (before the SSH key has been transferred):

- `ansible-playbook --ask-pass --ask-become-pass -v server-template.yml`

For subsequent runs:

- `ansible-playbook -vv server-template.yml`


License
-------

MIT

Author Information
------------------

Christian Wagner
