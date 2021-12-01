{ lib, config, ... }:
with lib;
let cfg = config.duponin.docker;
in {
  options.duponin.android.enable = mkEnableOption "Docker";

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.duponin.extraGroups = [ "docker" ];
  };
}
