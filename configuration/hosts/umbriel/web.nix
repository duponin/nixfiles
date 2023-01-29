{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;
  services.nginx = {
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
    statusPage = true;
  };
  services.nginx.virtualHosts = {
    "loc1.locahlost.net" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/loc1.locahlost.net";
      extraConfig = ''
        access_log /var/log/nginx/access_loc1.locahlost.net.log;
      '';
    };
    "indra.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://earth.locahlost.net:6000";
      };
      extraConfig = ''
        access_log /var/log/nginx/access_indra.dupon.in.log;
      '';
    };
    "indra.social" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/indra.social";
      extraConfig = ''
        access_log /var/log/nginx/access_indra.social.log;
      '';
    };
    "udongein.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://localhost:4000";
      };
      locations."/etc/" = {
        root = "/var/www/udongein.xyz";
      };
      extraConfig = ''
        access_log /var/log/nginx/access_udongein.xyz.log;
      '';
    };
    "dev.udongein.xyz" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://192.168.0.11:6662";
      };
      extraConfig = ''
        access_log /var/log/nginx/access_dev.udongein.xyz.log;
      '';
    };
    "monitoring.locahlo.st" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://hubble.locahlost.net/grafana";
      };
      extraConfig = ''
        access_log /var/log/nginx/access_monitoring.locahlo.st.log;
      '';

    };
    "bitwarden.melisse.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://melisse.locahlost.net:8000";
      };
      extraConfig = ''
        access_log /var/log/nginx/access_bitwarden.melisse.org.log;
      '';
    };
    "tbm.melisse.org" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/tbm.melisse.org";
      extraConfig = ''
        access_log /var/log/nginx/access_tbm.melisse.org.log;
      '';
    };
    "onedayonephoto.dupon.in" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/onedayonephoto.dupon.in";
      extraConfig = ''
        access_log /var/log/nginx/access_onedayonephoto.dupon.in.log;
      '';
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@locahlo.st";
}
