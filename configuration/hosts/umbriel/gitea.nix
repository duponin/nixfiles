{ config, pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  services.mysql = {
    ensureDatabases = [
      "udongein_gitea"
    ];
    ensureUsers = [
      {
        name = "udongein_gitea";
        ensurePermissions = {
          "udongein_gitea.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.gitea = {
    enable = true;
    domain = "dev.udongein.xyz";
    rootUrl = "https://dev.udongein.xyz/";
    appName = "Udongein Hub";
    database = {
      user = "udongein_gitea";
      passwordFile = "/srv/gitea/db-password.txt";
      host = "localhost";
      name = "udongein_gitea";
      createDatabase = false;
      type = "mysql";
    };
  };
}
