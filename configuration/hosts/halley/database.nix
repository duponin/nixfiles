{ config, lib, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    enableTCPIP = true;
    authentication = ''
      host zabbix zabbix 10.0.11.10/32 trust
    '';
    ensureDatabases = [ # something something
      "zabbix"
    ];
    ensureUsers = [{
      name = "zabbix";
      ensurePermissions = { "DATABASE zabbix" = "ALL PRIVILEGES"; };
    }];
    extraPlugins = with pkgs.postgresql_14.pkgs; [ timescaledb ];
    settings.shared_preload_libraries = "timescaledb";
  };
}
