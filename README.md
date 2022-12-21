# Nixfiles

My infrastructure as code.

## Useful snippets
### SSH in without polluting known_hosts

``` shell
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=false <DESTINATION>
```

## Install a Host
### Disk Setup

``` shell
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 0% 100%
mkfs.ext4 -L nixos /dev/sda1
mount /dev/disk/by-label/nixos /mnt
```

## Install System

``` shell
nixos-generate-config --root /mnt
nixos-install --no-root-passwd --verbose --flake "git+https://codeberg.org/duponin/nixfiles#<HOSTNAME>"
reboot
```

## Fix a Broken Install

1. reboot on ISO
2. become super user
3. `mount /dev/disk/by-label/nixos /mnt && nixos-install --no-root-passwd --verbose --flake "git+http://codeberg.org/duponin/nixfiles#<HOSTNAME>"`
4. reboot