{ config, pkgs, ... }:

{
  imports = [ # #
    ./hardware-configuration.nix
    ../../common
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;

  # boot.loader = {
  #   efi = {
  #     canTouchEfiVariables = true;
  #     # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
  #     efiSysMountPoint = "/boot";
  #   };
  #   grub = {
  #     # despite what the configuration.nix manpage seems to indicate,
  #     # as of release 17.09, setting device to "nodev" will still call
  #     # `grub-install` if efiSupport is true
  #     # (the devices list is not used by the EFI grub install,
  #     # but must be set to some value in order to pass an assert in grub.nix)
  #     devices = [ "nodev" ];
  #     efiSupport = true;
  #     enable = true;
  #     extraEntries = ''
  #       menuentry "Winblows" {
  #         insmod part_gpt
  #         insmod fat
  #         insmod search_fs_uuid
  #         insmod chain
  #         search --fs-uuid --set=root E68446C884469AC7
  #         chainloader /Windows/Boot/EFI/bootmgfw.efi
  #       }
  #     '';
  #     version = 2;
  #   };
  # };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  networking.hostName = "katyusha";
  networking.interfaces.enp6s0.useDHCP = true;
  networking.useDHCP = false;
  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "20.09";
}
