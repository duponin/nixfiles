{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.nsd = {
    enable = true;
    interfaces = [ "0.0.0.0" "::" ];
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

          @ IN NS ns1.localhost.net.
          ns1 IN A 185.233.102.155
          ns1 IN AAAA 2a0c:e300:12::155

          mars IN A 185.233.102.155
          mars IN AAAA 2a0c:e300:12::155

          ; TODO: move in a int/priv zone
          dione IN A 10.0.1.8
          hyperion IN A 10.0.1.41
          lapetus IN A 10.0.1.1
          neith IN A 10.0.1.11
          tethys IN A 10.0.1.2
          titan IN A 10.0.1.21
          triton IN A 10.0.1.31
          wan.lapetus IN A 192.168.0.215
          yunotest IN A 10.0.1.213

          ; TODO: (k8s.)homelab zone
          master1.k8s-homelab IN A 10.0.20.4
          node1.k8s-homelab IN A 10.0.20.11
          node2.k8s-homelab IN A 10.0.20.12
          node3.k8s-homelab IN A 10.0.20.13
          node4.k8s-homelab IN A 10.0.20.14
        '';
      };
    };
  };
}
