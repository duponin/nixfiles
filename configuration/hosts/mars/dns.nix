{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.nsd = {
    enable = true;
    zones = {
      "locahlost.net." = {
        data = ''
          $ORIGIN locahlost.net.
          $TTL 3600
          @ IN SOA ns1.locahlost.net. admin.locahlost.net. (
               ; Serial
               1
               ; Refresh
               604800
               ; Retry
               86400
               ; Expire
               2419200
               ; Negative Cache TTL
               604800 )

          IN NS ns1.localhost.net.

          mars IN A 185.233.102.155
          mars IN AAAA 2a0c:e300:12::155
        '';
      };
    };
  };
}
