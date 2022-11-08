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
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@locahlo.st";
}
