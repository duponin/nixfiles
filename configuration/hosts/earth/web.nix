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
    "earth.locahlost.net" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/earth.locahlost.net";
    };
    "tiger.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3000";
      };
    };
    "indra.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:6000";
      };
    };
    "indra.social" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/indra.social";
    };
    "mastodon.test.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:5000";
        extraConfig = ''
          allow 127.0.0.1;
          allow ::1;
          deny all;
        '';
      };
    };
    "udongein.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
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
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@locahlo.st";
}
