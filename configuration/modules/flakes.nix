{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.flakes;
in {
  options.duponin.flakes.enable = mkEnableOption "Flakes";

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };
}
