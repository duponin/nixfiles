{ lib, config, pkgs, ... }:
with lib;
let cfg = config.duponin.apple;
in {
  options.duponin.apple.enable = mkEnableOption "Pear connection reset";

  config = mkIf cfg.enable {
    # https://nixos.wiki/wiki/IOS
    services.usbmuxd.enable = true;
    environment.systemPackages = with pkgs; [ libimobiledevice ];
  };
}
