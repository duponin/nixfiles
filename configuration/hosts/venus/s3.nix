{ config, lib, pkgs, ... }:

{
  services.minio = {
    enable = true;
    region = "fr-bordeaux-1";
  };
  networking.firewall.interfaces.ens19.allowedTCPPorts = [
    9000 # Minio service port
    9001 # Minio console port
  ];

}
