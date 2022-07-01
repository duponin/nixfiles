{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "tbm.melisse.org" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/tbm.melisse.org";
    };
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "pwet+acme@dupon.in";
}
