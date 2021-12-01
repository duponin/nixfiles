{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.docker;
in {
  options.duponin.docker.enable = mkEnableOption "Docker";

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.duponin.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}
