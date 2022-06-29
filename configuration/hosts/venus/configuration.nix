{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./s3.nix
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
  networking.interfaces.ens19 = {
    ipv4 = {
      addresses = [{
        address = "192.168.10.11";
        prefixLength = 24;
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
