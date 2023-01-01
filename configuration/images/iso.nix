{ config, pkgs, ... }:

{
  imports =
    [
      ../common/server.nix
    ];

  networking.hostName = pkgs.lib.mkForce "iso";
  networking.domain = "locahlost.net";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  # Mount /tmp on tmpfs at boot
  boot.tmpOnTmpfs = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Security
  security.sudo.enable = false;
  security.doas.enable = true;

  system.autoUpgrade.enable = pkgs.lib.mkForce false;

  console.keyMap = "fr-bepo-latin9";
  users.users.duponin.initialHashedPassword = "";
  services.getty.autologinUser = pkgs.lib.mkForce "duponin";
  programs.bash.shellInit = "ip address";

  system.stateVersion = "22.05";
}
