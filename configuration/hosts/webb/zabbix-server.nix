{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 10051 ];
  services.zabbixServer = {
    enable = true;
    openFirewall = true;
    database.host = "halley.int.locahlost.net";
  };
}
