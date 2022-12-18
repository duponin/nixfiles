{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/flakes.nix
    ../../common/server.nix
    ./monitoring.nix
    ./unifi.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "kourou";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    ipv4 = {
      addresses = [{
        address = "192.168.0.45";
        prefixLength = 24;
      }];
    };
  };
  networking.defaultGateway = {
    address = "192.168.0.254";
    interface = "ens18";
  };

  system.stateVersion = "22.05";
}
