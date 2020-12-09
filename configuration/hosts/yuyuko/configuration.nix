{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ../../common/servers
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Set networking
  networking = {
    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 51820 ];
    };
    hostName = "yuyuko";
    useDHCP = false;
    nameservers = [ "185.233.100.100" "185.233.100.101" "1.1.1.1" ];
    interfaces.ens18 = {
      ipv4 = {
        addresses = [{
          address = "10.0.30.10";
          prefixLength = 24;
        }];
        routes = [{
          address = "0.0.0.0";
          prefixLength = 0;
          via = "10.0.20.1";
        }];
      };
    };
    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "10.0.30.129/24" ];
          listenPort = 51820;
          privateKeyFile = "/private/wireguard/private_key";
          peers = [{ # duponin@rilakkuma
            publicKey = "p6V/5VlYNi6jhii8gZD+kMrhqOEOErQJ+gob0iE93nk=";
            allowedIPs = [ "0.0.0.0/0" ];
          }];
        };
      };
    };
  };

  services = { openssh.enable = true; };

  system.stateVersion = "20.09";
}
