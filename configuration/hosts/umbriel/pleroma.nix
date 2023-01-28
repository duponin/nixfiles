{ config, pkgs, ... }:

{
  services.postgresql = {
    ensureDatabases = [
      "udongein_pleroma"
    ];
    ensureUsers = [
      {
        name = "udongein_pleroma";
        ensurePermissions = {
          "DATABASE udongein_pleroma" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  users = {
    users."udongein_pleroma" = {
      description = "Udongein's Pleroma user";
      home = "/srv/udongein_pleroma";
      group = "udongein_pleroma";
      isSystemUser = true;
      packages = with pkgs; [
        elixir
        gcc
        coreutils # needed for crypt.h, compilation
        cmake
        gnumake
        file
        imagemagick
        ffmpeg
        exiftool
      ];
    };
    groups."udongein_pleroma" = { };
  };

}
