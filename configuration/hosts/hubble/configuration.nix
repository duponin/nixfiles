{ config, locahlost, pkgs, ... }:

let gateway = "2a0c:e304:c0fe:1::1";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./monitoring.nix
    ../../modules/monitoring-agent.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "hubble";
  networking.domain = "locahlost.net";
  networking.nameservers = [ gateway ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    mtu = 1378;
    ipv6 = {
      addresses = [{
        address = "2a0c:e300:12::42:2";
        prefixLength = 48;
      }];
    };
  };
  networking.interfaces.ens19 = {
    useDHCP = true;
    ipv6 = {
      addresses = [{
        address = "2a0c:e304:c0fe:1::2";
        prefixLength = 64;
      }];
    };
  };
  networking.defaultGateway6 = {
    address = gateway;
    interface = "ens19";
  };

  services.qemuGuest.enable = true;
  locahlost.monitoring-agent.enable = true;

  system.stateVersion = "22.05";
}
