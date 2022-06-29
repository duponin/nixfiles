{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;

    virtualHosts = {
      "s3.locahlo.st" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://192.168.10.11:9000/";
      };
      "console.s3.locahlo.st" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://192.168.10.11:9001/";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin+acme@locahlo.st";
  };
}
