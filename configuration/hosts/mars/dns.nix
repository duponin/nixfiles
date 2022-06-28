{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.bind = {
    enable = true;
    zones = {
      locahlost.net = {
        extraConfig = "";
        file = "/var/dns/locahlost.net";
        master = true;
        masters = [ ];
        slaves = [ ];
      };
    };
  };
}
