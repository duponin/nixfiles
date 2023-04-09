{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 2222 ];
}
