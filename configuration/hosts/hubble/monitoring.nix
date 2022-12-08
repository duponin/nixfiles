{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    grafana = {
      enable = true;
      port = 3000;
      domain = "monitoring.locahlo.st";
      rootUrl = "https://monitoring.locahlo.st/grafana/";
    };

    prometheus = {
      enable = true;
      extraFlags = [ "--web.external-url=/prometheus/" ];
      configText = lib.strings.fileContents ./prometheus.yml;
    };

    nginx.enable = true;
    nginx.virtualHosts."${config.networking.fqdn}".locations = {
      "/prometheus/prometheus".proxyPass = "http://localhost:${toString config.services.prometheus.port}/prometheus/";
      "/prometheus/node-exporter/".proxyPass = "http://localhost:9100/";
    };
  };
}
