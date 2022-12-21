{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8123 ];
  virtualisation.docker.enable = true;
  services.home-assistant = {
    enable = true;
    config = null;
  };
}
