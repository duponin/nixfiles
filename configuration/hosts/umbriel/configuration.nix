{ config, locahlost, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./monitoring.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "umbriel";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];

  networking.useDHCP = false;
  networking.interfaces.eth0 = {
    ipv4 = {
      addresses = [{
        address = "192.168.0.40";
        prefixLength = 24;
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a01:e0a:18c:37b0::40";
        prefixLength = 64;
      }];
    };
  };


  networking.defaultGateway = {
    address = "192.168.0.254";
    interface = "eth0";
  };
  networking.defaultGateway6 = {
    address = "fe80::f6ca:e5ff:fe4a:9406";
    interface = "eth0";
  };

  system.stateVersion = "22.05";
}
