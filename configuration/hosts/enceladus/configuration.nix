{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/flakes.nix
      ../../common/server.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "enceladus";
  networking.nameservers = [
    "185.233.100.100"
    "2a0c:e300::100"
  ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
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
  networking.defaultGateway = {
    address = "185.233.102.190";
    interface = "ens18";
  };
  networking.defaultGateway6 = {
    address = "2a0c:e300:12::190";
    interface = "ens18";
  };

  system.stateVersion = "21.11";
}
