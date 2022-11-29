{ config, pkgs, stdenv, ... }:

{
  # Implementation
  # Heavily inspired of Pleroma service
  # nixos/modules/services/networking/pleroma.nix

  users = {
    users."indra" = {
      description = "indra social user";
      home = "/srv/indra";
      group = "foundkey_locahlost";
      isSystemUser = true;
      packages = [ pkgs.elixir ];
    };
    groups."foundkey_locahlost" = {};
  };
}
