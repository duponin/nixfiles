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

  networking.hostName = "venus";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "2a0c:e300::100" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    mtu = 1378;
    ipv6 = {
      addresses = [{
        address = "2a0c:e300:12::42:1";
        prefixLength = 48;
      }];
    };
  };
  networking.defaultGateway6 = {
    address = "2a0c:e300:12::190";
    interface = "ens18";
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "22.05";
}
