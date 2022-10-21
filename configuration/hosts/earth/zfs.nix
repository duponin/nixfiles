{ config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/ZFS
  # https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "c0fec0fe";

  services.zfs.autoScrub = {
    enable = true;
    pools = [ "tank" ];
  };
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
  };
}
