{ config, pkgs, lib, ... }:

{
  # https://github.com/NixOS/nixos-hardware/blob/3f92db38374b2977aea8daf4c4fe2fa0eddbd60c/common/pc/laptop/default.nix
  services.tlp.enable = lib.mkDefault ((lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
                                       || !config.services.power-profiles-daemon.enable);

  # https://github.com/NixOS/nixos-hardware/blob/3f92db38374b2977aea8daf4c4fe2fa0eddbd60c/common/pc/ssd/default.nix
  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 1;
  };
  services.fstrim.enable = lib.mkDefault true;

  # https://github.com/NixOS/nixos-hardware/blob/3f92db38374b2977aea8daf4c4fe2fa0eddbd60c/common/cpu/intel/default.nix
  boot.initrd.kernelModules = [ "i915" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
}
