{ config, lib, pkgs, ... }:

{
  services.zabbixServer = {
    enable = true;
    openFirewall = true;
    database.host = "halley.int.locahlost.net";
  };
}
