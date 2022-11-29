{ config, lib, pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = false;
  nix.trustedUsers = [ "@wheel" ];
  users.mutableUsers = false;
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh6W2o61dlOIcBXeWRhXWSYD/W8FDVf3/p4FNfL2L6p duponin@rilakkuma"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYcrVpTNgsKNOfVdG19xWA6F14mFdkJpSWhOi6EdziQ duponin@halley"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT0c8IL73Q0QNPK7btYJu2+96VMpyA4uBKAMVgpLcJ3 duponin@earth"
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
    flake = "git+https://git.melisse.org/duponin/nixfiles.git/";
    flags = [ "--no-write-lock-file" ];
  };
  environment.systemPackages = with pkgs; [ git vim ];
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  time.timeZone = "Europe/Paris";
}
