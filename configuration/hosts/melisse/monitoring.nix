{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    prometheus.exporters = {
      node.enable = true;
    };

    nginx.enable = true;
    nginx.virtualHosts."${config.networking.fqdn}".locations = {
      "/prometheus/node-exporter/".proxyPass = "http://localhost:${toString config.services.prometheus.exporters.node.port}/";
    };
  };
}
