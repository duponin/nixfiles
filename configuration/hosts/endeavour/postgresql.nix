{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5432 ];

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    extraPlugins = with pkgs.postgresql_14.pkgs; [ pg_repack ];
    settings = {
      max_wal_size = "4GB";
    };
    ensureDatabases = [
      "udongein_pleroma"
    ];
  };
}
