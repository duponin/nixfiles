{ config, lib, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = ''
      host zabbix zabbix 10.0.11.10 trust;
    '';
    ensureDatabases = [ # something something
      "zabbix"
    ];
    ensureUsers = [{
      name = "zabbix";
      ensurePermissions = { "DATABASE zabbix" = "ALL PRIVILEGES"; };
    }];
  };
}
