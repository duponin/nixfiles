# https://nixos.org/manual/nixos/stable/index.html#module-services-sourcehut
{ pkgs, ... }:
let
  fqdn = "forge.locahlo.st";
in {

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  security.acme.email = "admin@locahlo.st";
  security.acme.acceptTerms = true;

  services.sourcehut = {
    enable = true;
    originBase = fqdn;
    services = [ "meta" "man" "git" ];
    settings = {
        "sr.ht" = {
          environment = "production";
          global-domain = fqdn;
          origin = "https://${fqdn}";
          # Produce keys with srht-keygen from sourcehut.coresrht.
          network-key = "4Xa0h9ZMobvQmR640A-ifY6FyJK8FJZ8jmjZyVUhCWE=";
          service-key = "e85b091b1af92e8e17fb4a21bdc8a50fc91687bb66e18a7e22db9fc3d305f557";
        };
        webhooks.private-key = "G53p1rmO4JuFe8KmBv5LLeS4R/3XrqiPzWsUPSitc+c=";
    };
  };

  security.acme.certs."${fqdn}".extraDomainNames = [
    "meta.${fqdn}"
    "man.${fqdn}"
    "git.${fqdn}"
  ];

  services.nginx = {
    enable = true;
    # only recommendedProxySettings are strictly required, but the rest make sense as well.
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    # Settings to setup what certificates are used for which endpoint.
    virtualHosts = {
      "${fqdn}".enableACME = true;
      "meta.${fqdn}".useACMEHost = fqdn;
      "man.${fqdn}".useACMEHost = fqdn;
      "git.${fqdn}".useACMEHost = fqdn;
    };
  };
}
