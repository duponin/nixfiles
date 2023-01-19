{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    prometheus.exporters = {
      nginx.enable = true;
      node.enable = true;
      postgres.enable = true;
      postgres.user = "postgres";
    };

    nginx.enable = true;
    nginx.virtualHosts."${config.networking.fqdn}".locations = {
      "/prometheus/nginx/".proxyPass = "http://localhost:${toString config.services.prometheus.exporters.nginx.port}/";
      "/prometheus/node-exporter/".proxyPass = "http://localhost:${toString config.services.prometheus.exporters.node.port}/";
      "/prometheus/postgres/".proxyPass = "http://localhost:${toString config.services.prometheus.exporters.postgres.port}/";
    };
  };
}
