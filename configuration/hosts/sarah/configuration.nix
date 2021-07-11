{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/flakes.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sde";

  networking.hostName = "sarah"; # Define your hostname.

  time.timeZone = "Europe/Paris";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp10s0.useDHCP = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.duponin= {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh6W2o61dlOIcBXeWRhXWSYD/W8FDVf3/p4FNfL2L6p duponin@rilakkuma"
    ];
  };

  services.openssh.enable = true;

  system.stateVersion = "21.05";
}
