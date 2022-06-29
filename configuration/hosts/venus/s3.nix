{ config, lib, pkgs, ... }:

{
  services.minio = {
    enable = true;
    region = "fr-bordeaux-1";
  };
  systemd.services.minio.environment.MINIO_BROWSER_REDIRECT_URL =
    "https://console.s3.locahlo.st/";
  networking.firewall.interfaces.ens19.allowedTCPPorts = [
    9000 # Minio service port
    9001 # Minio console port
  ];

}
