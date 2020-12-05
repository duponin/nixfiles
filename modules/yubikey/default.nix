{ lib, pkgs, config, ... }:
with lib;
let cfg = config.services.yubikey;
in {
  options.services.yubikey = { enable = mkEnableOption "yubikey support"; };

  config = mkIf cfg.enable {
    # To have the Yubikey working correcty
    services.udev.packages = [ pkgs.libu2f-host pkgs.yubikey-personalization ];
    # To use Smartcard mode (CCID) of Yubikey
    services.pcscd.enable = true;
  };
}
