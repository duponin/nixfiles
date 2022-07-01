{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services = {
    grafana = {
      enable = true;
      addr = "127.0.0.1";
      port = 3000;
      domain = "monitoring.locahlo.st";
      rootUrl = "https://monitoring.locahlo.st/grafana/";
    };

    prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      extraFlags = [ "--web.external-url=/prometheus/" ];
    };

    nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;

      virtualHosts."monitoring.locahlo.st" = {
        forceSSL = true;
        enableACME = true;
        locations."/grafana/" = {
          proxyWebsockets = true;
          proxyPass =
            "http://127.0.0.1:${toString config.services.grafana.port}/";
        };
        locations."/prometheus/" = {
          proxyPass = "http://127.0.0.1:${
              toString config.services.prometheus.port
            }/prometheus/";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin+acme@locahlo.st";
  };
}
