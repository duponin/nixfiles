{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    config = null;
  };
}
