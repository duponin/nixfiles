{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;
  services.nginx = {
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
  };
  services.nginx.virtualHosts = {
    "loc1.locahlost.net" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/loc1.locahlost.net";
    };
    "indra.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://earth.locahlost.net:6000";
      };
    };
    "indra.social" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/indra.social";
    };
    "udongein.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://192.168.0.11:6661";
      };
    };
    "dev.udongein.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://192.168.0.11:6662";
      };
    };
    "monitoring.locahlo.st" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://hubble.locahlost.net/grafana";
      };
    };
    "bitwarden.melisse.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://melisse.locahlost.net:8000";
      };
    };
    "tbm.melisse.org" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/tbm.melisse.org";
    };
    "onedayonephoto.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/onedayonephoto.dupon.in";
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@locahlo.st";
}
