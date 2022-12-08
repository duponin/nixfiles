{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    grafana = {
      enable = true;
      port = 3000;
      domain = "monitoring.locahlo.st";
      rootUrl = "https://monitoring.locahlo.st/";
    };

    prometheus = {
      enable = true;
      extraFlags = [ "--web.external-url=/prometheus/prometheus/" ];
      configText = lib.strings.fileContents ./prometheus.yml;
    };

    prometheus.exporters = {
      node.enable = true;
    };

    nginx.enable = true;
    nginx.recommendedProxySettings = true;

    nginx.virtualHosts."${config.networking.fqdn}".locations = {
      "/grafana".proxyPass = "http://localhost:${toString config.services.grafana.port}/";
      "/grafana".proxyWebsockets = true;

      "/prometheus/prometheus/".proxyPass = "http://localhost:${toString config.services.prometheus.port}/prometheus/prometheus/";
      "/prometheus/node-exporter/".proxyPass = "http://localhost:${toString config.services.prometheus.exporters.node.port}/";
    };
  };
}
