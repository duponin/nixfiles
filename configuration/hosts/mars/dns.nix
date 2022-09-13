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
               11
               ; Refresh
               604800
               ; Retry
               86400
               ; Expire
               2419200
               ; Negative Cache TTL
               604800 )

          @ IN NS ns1.locahlost.net.
          ns1 IN A 185.233.102.155
          ns1 IN AAAA 2a0c:e300:12::155

          ; Hosts
          enceladus IN A    185.233.102.143
          enceladus IN AAAA 2a0c:e300:12::143
          enceladus.int IN A 192.168.10.10

          mars IN A    185.233.102.155
          mars IN AAAA 2a0c:e300:12::155

          hubble IN AAAA 2a0c:e304:c0fe:1::2
          venus  IN AAAA 2a0c:e304:c0fe:1::3

          umbriel IN A    185.233.102.141
          umbriel IN AAAA 2a0c:e300:12::141

          jupiter IN A    185.233.102.189
          jupiter IN AAAA 2a0c:e300:12::189

          lain IN AAAA 2a0c:e300::3:69

          puck IN A    185.233.103.71
          puck IN AAAA 2a0c:e300::3:71

          iss IN A    185.233.103.71
          iss IN AAAA 2a0c:e300::3:71

          caravelle.int IN A 10.0.12.10
          halley.int IN A 10.0.13.10
          puck.int IN A 10.0.11.20
          webb.int IN A 10.0.11.10

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
