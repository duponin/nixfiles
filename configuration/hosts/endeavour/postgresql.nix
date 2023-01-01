{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5432 ];

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    extraPlugins = with pkgs.postgresql_14.pkgs; [ pg_repack ];
    settings = {
      max_wal_size = "4GB";
      wal_level = "logical";
      # Set to twice as many replicas as you ever expect to have.
      # https://postgresqlco.nf/doc/en/param/max_replication_slots/
      # max_replication_slots = 40;
    };
    authentication = ''
      host all pluto_replicator 192.168.0.47/24 trust
    '';
    ensureUsers = [
      {
        name = "pluto_replicator";
        ensurePermissions = {
          "SCHEMA public" = "USAGE";
          "ALL TABLES IN SCHEMA public" = "SELECT";
        };
      }
    ];
    ensureDatabases = [
      "udongein_pleroma"
    ];
  };
}
