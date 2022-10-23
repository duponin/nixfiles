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
          port = 6379;
        };
      };
    };
    nginx.virtualHosts = {
      "nyaa.locahlo.st" = {
        forceSSL = true;
        enableACME = true;
        proxyPass = "http://localhost:3000";
      };
    };
  };


  # Implementation
  # Heavily inspired of Pleroma service
  # nixos/modules/services/networking/pleroma.nix

  users = {
    users."Foundkey_locahlost" = {
      description = "Foundkey locahlost user";
      home = "/srv/foundkey";
      group = "foundkey_locahlost";
      isSystemUser = true;
    };
    groups."foundkey_locahlost" = {};
  };

  systemd.services.foundkey_locahlost = {
    description = "Foundkey social network";
    after = [
      "network-online.target"
      "postgresql.service"
      "redis-foundkey_locahlost.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "foundkey_locahlost";
      Group = "foundkey_locahlost";
      Type = "simple";
      WorkingDirectory = "~";
      environment.NODE_ENV = "production";
      TimeOutSec = 60;
      Restart = "always";
      ExecStart = "${pkgs.npm}/bin/npm start";
    };
  };
}
