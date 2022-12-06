{ config, pkgs, stdenv, ... }:

{
  # Implementation
  # Heavily inspired of Pleroma service
  # nixos/modules/services/networking/pleroma.nix

  users = {
    users."indra" = {
      description = "indra social user";
      home = "/srv/indra";
      group = "indra";
      isSystemUser = true;
      packages = [ pkgs.elixir ];
    };
    groups."indra" = { };
  };
}
