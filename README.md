# Nixfiles

My infrastructure as code.

## Useful snippets
### SSH in without polluting known_hosts

``` shell
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=false <DESTINATION>
```

## Install a Host
### Setup

``` shell
# Regular disk
export DISK="/dev/sda"
export ROOTFS="${DISK}1"

# NVMe disk
export DISK="/dev/nvme0n1"
export ROOTFS="${DISK}p1"
export UEFIFS="${DISK}p2"
```

#### BIOS

``` shell
parted $DISK -- mklabel msdos
parted $DISK -- mkpart primary 0% 100%
mkfs.ext4 -L nixos $ROOTFS
sleep 2
mount /dev/disk/by-label/nixos /mnt
```

#### UEFI

- Partition 1 is the rootfs
- Partition 2 is the uefifs
- I don't want SWAP

``` shell
parted $DISK -- mklabel gpt
parted $DISK -- mkpart primary 512MB 100%
parted $DISK -- mkpart ESP fat32 1MB 512MB
parted $DISK -- set 2 esp on
mkfs.ext4 -L nixos $ROOTFS
mkfs.fat -F 32 -n boot $UEFIFS
sleep 2
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

## Install System

``` shell
nixos-generate-config --root /mnt
nixos-install --no-root-passwd --verbose --flake "git+https://codeberg.org/duponin/nixfiles#<HOSTNAME>" && reboot
```

## Fix a Broken Install

1. reboot on ISO
2. become super user
3. `mount /dev/disk/by-label/nixos /mnt && nixos-install --no-root-passwd --verbose --flake "git+http://codeberg.org/duponin/nixfiles#<HOSTNAME>"`
4. reboot