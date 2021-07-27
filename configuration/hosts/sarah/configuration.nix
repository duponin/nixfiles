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
  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "c0fe4242";
  networking.hostName = "sarah";

  time.timeZone = "Europe/Paris";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp10s0.useDHCP = true;
  networking.interfaces.eno1 = {
    ipv6 = {
      addresses = [{
        address = "2a01:e0a:18c:37b0::42";
        prefixLength = 64;
      }];
    };
  };
  networking.defaultGateway6 = {
    address = "2a0c:e300:12::190";
    interface = "eno1";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.duponin= {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh6W2o61dlOIcBXeWRhXWSYD/W8FDVf3/p4FNfL2L6p duponin@rilakkuma"
    ];
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [ git vim zfs ];

  system.stateVersion = "21.05";
}
