{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/flakes.nix
    ../../common/server.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "iommu.passthrough=1" # fix annoying error message (citation needed)
    "arm-smmu.disable_bypass=0" # should fix SFP ports not showing up https://community.solid-run.com/t/sfp-what-am-i-looking-for/193/5
  ];

  networking.hostName = "umbriel";

  system.stateVersion = "22.11";
}
