{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.home-manager;
in {
  options.duponin.home-manager.enable =
    mkEnableOption "The butter to NixOS bread";

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.duponin = {
        programs.git = {
          enable = true;
          package = pkgs.gitFull;
          userName = "Antonin Dupont";
          userEmail = "duponin@locahlo.st";
          delta.enable = true;
          extraConfig = { pull = { ff = "only"; }; };
          # signing = true;
        };
      };
    };
  };
}
