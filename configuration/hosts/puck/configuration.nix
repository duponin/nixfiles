{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "puck";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "185.233.100.100" "2a0c:e300::100" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    mtu = 1500;
    ipv4 = {
      addresses = [{
        address = "185.233.103.70";
        prefixLength = 24;
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a0c:e300::3:70";
        prefixLength = 64;
      }];
    };
  };
  networking.defaultGateway = {
    address = "185.233.103.254";
    interface = "ens18";
  };
  networking.defaultGateway6 = {
    address = "2a0c:e300::3:126";
    interface = "ens18";
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "22.05";
}
