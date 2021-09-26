{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.android;
in {
  options.duponin.android.enable = mkEnableOption "Android";

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.duponin.extraGroups = [ "adbusers" ];
  };
}
