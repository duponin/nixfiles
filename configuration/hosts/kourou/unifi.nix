{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "unifi-controller"
  ];

  # required to expose the interface
  networking.firewall.allowedTCPPorts = [ 8443 ];

  services.unifi = {
    enable = true;
    openFirewall = true;
  };
}
