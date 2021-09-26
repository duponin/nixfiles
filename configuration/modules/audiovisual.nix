{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.audiovisual;
in {
  options.duponin.audiovisual.enable = mkEnableOption "Photo and Video making";

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      darktable
      digikam
      gimp
      obs-studio
      olive-editor
    ];
  };
}
