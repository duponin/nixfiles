{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "titan.locahlost.net" = {
      default = true;
      forceSSL = true;
      enableACME = true;
      root = "/var/www/titan.locahlost.net";
    };
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin+acme@locahlo.st";
}

