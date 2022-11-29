{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/flakes.nix
    ../../common/server.nix

  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nomad-01";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "185.233.100.100" "2a0c:e300::100" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    ipv4 = {
      addresses = [{
        address = "192.168.0.21";
        prefixLength = 24;
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a01:e0a:18c:37b0::21";
        prefixLength = 64;
      }];
    };
  };
  networking.defaultGateway = {
    address = "192.168.0.254";
    interface = "ens18";
  };
  networking.defaultGateway6 = {
    address = "fe80::f6ca:e5ff:fe4a:9406";
    interface = "ens18";
  };

  services.qemuGuest.enable = true;

  system.stateVersion = "22.05";
}
