{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../../common/servers
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  networking.useDHCP = false;

  # ---

  networking = {
    defaultGateway6 = {
      address = "2a0c:e300:12::190";
      interface = "ens3";
    };
    defaultGateway = {
      address = "185.233.102.190";
      interface = "ens3";
    };
    firewall.checkReversePath = false;
    hostName = "marisa";
    nameservers = [ "185.233.100.100" "185.233.100.101" "1.1.1.1" ];
    interfaces.ens3 = {
      mtu = 1378;
      ipv4 = {
        addresses = [{
          address = "185.233.102.143";
          prefixLength = 26;
        }];
      };
      ipv6 = {
        addresses = [{
          address = "2a0c:e300:12::143";
          prefixLength = 48;
        }];
      };
    };
  };
}
