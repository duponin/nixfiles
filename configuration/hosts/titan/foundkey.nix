{ config, pkgs, ... }:

{
  services = {
    postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
      ensureUsers = [
        {
          name = "foundkey_locahlost";
          ensurePermissions = {
            "DATABASE foundkey_locahlost" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [
        "foundkey_locahlost"
      ];
    };
    redis = {
      vmOverCommit = true;
      servers = {
        "foundkey_locahlost" = {
          enable = true;
          logfile = "stdout";
        };
      };
    };
  };
}
