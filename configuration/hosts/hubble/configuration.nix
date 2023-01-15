{ config, locahlost, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./monitoring.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hubble";
  networking.domain = "locahlost.net";
  networking.nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];

  networking.useDHCP = false;
  networking.interfaces.ens18 = {
    ipv4 = {
      addresses = [{
        address = "192.168.0.44";
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
