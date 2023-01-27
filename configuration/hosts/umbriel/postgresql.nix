{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    settings = {
      max_wal_size = "4GB";
    };
  };
}
