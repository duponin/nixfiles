{ config, locahlost, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./monitoring.nix
    ./postgresql.nix
    ./web.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "iommu.passthrough=1" # should be fixed by 6.x.x
  ];

  networking.hostName = "umbriel";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];

  networking.useDHCP = false;
  networking.interfaces.eth0 = {
    ipv4 = {
      addresses = [
        {
          address = "192.168.0.40";
          prefixLength = 24;
        }
        {
          address = "192.168.0.49";
          prefixLength = 24;
        }
      ];
    };
    ipv6 = {
      addresses = [
        {
          address = "2a01:e0a:18c:37b0::40";
          prefixLength = 64;
        }
        {
          address = "2a01:e0a:18c:37b0::49";
          prefixLength = 64;
        }
      ];
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
