{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "broadcom-sta" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dc2b3f7e-8a05-4555-90d1-aa0e4c1c1282";
    fsType = "ext4";
  };
  fileSystems."/tank" = {
    device = "tank";
    fsType = "zfs";
  };
  fileSystems."/tank/duponin" = {
    device = "tank/duponin";
    fsType = "zfs";
  };
}
