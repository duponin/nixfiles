# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../../common
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://bugzilla.kernel.org/show_bug.cgi?id=110941
  boot.kernelParams = [ "intel_pstate=no_hwp" ];

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
  };

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = {
    root = {
      device =
        "/dev/disk/by-id/nvme-WDC_PC_SN730_SDBQNTY-512G-1001_193594450508-part2";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking.hostName = "rilakkuma"; # Define your hostname
  networking.interfaces = {
    enp0s31f6.useDHCP = true;
    wlp0s20f3.useDHCP = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
      host all all 127.0.0.1/32 trust
    '';
  };

  # Optimization for Intel GPU
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  users.users = {
    antonin = {
      isNormalUser = true;
      extraGroups = [
        "docker" # Docker
        "libvirt" # Virtualisation
        "networkmanager" # Network
        "wheel" # Sudo
      ];
      hashedPassword =
        "$6$rounds=1000000$63QsvoqMVA8s$eUfxQr5KtGLmO0XdSQtp.Ka0KOlFXqLP8ys.Es9PIgFYK/rxN8aALoIqAH0WcIQ/0yeXwsi7hTa.3/cHWX1RF1";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
