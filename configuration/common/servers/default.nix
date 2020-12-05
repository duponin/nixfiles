{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ git ];
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh6W2o61dlOIcBXeWRhXWSYD/W8FDVf3/p4FNfL2L6p duponin@rilakkuma"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
}
