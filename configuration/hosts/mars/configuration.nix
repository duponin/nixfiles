{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./dns.nix
    ./hosting.nix
    ../../modules/monitoring-agent.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "mars";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    mtu = 1378;
    ipv4 = {
      addresses = [{
        address = "185.233.102.155";
        prefixLength = 26;
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a0c:e300:12::155";
        prefixLength = 48;
      }];
    };
  };
  networking.interfaces.ens19 = {
    useDHCP = true;
    ipv6 = {
      addresses = [{
        address = "2a0c:e304:c0fe:1::4";
        prefixLength = 64;
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

  services.qemuGuest.enable = true;
  locahlost.monitoring-agent = {
    enable = true;
    interface = "ens19";
  };

  system.stateVersion = "22.05";
}
