{ config, lib, pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = false;
  nix.trustedUsers = [ "@wheel" ];
  users.mutableUsers = false;
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh6W2o61dlOIcBXeWRhXWSYD/W8FDVf3/p4FNfL2L6p duponin@rilakkuma"
    ];
  };
  services = {
    fail2ban = {
      enable = true;
      bantime-increment.enable = true;
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "no";
    };
  };
  system.autoUpgrade = {
    enable = true;
    dates = "02:02";
    allowReboot = true;
    flake = "git+https://git.melisse.org/duponin/nixfiles";
  };
  environment.systemPackages = with pkgs; [ git vim ];
  programs.mosh.enable = true;
  time.timeZone = "Europe/Paris";
}
