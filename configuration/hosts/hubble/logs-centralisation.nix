{ config, lib, pkgs, ... }:

{
  # I trust you random from the Internet not spamming this service
  # but I should add authentication on anyway, at least as exercise
  # at the viewer discretion ;)
  services.nginx.virtualHosts."monitoring.locahlo.st" = {
    locations."/loki/".proxyPass = "http://127.0.0.1:3100/";
  };

  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
        grpc_listen_port = 9096;
      };
      common = {
        storage = {
          filesystem = {
            chunks_directory = "/tmp/loki/chunks";
            rules_directory = "/tmp/loki/rules";
          };
        };
        replication_factor = 1;
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
      };
      schema_config = {
        configs = [{
          from = "2020-10-24";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };
      # ruler.alertmanager_url = "http://localhost:9093";
      analytics.reporting_enabled = false;
    };
  };
}
