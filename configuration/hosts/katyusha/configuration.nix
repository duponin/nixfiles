{ config, pkgs, ... }:

{
  imports = [ # #
    ./hardware-configuration.nix
    ../../common
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "katyusha";
  networking.interfaces.enp6s0.useDHCP = true;
  networking.useDHCP = false;
  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "20.09";
}
