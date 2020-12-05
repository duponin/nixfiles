{ config, pkgs, lib, ... }: {
  imports = [ ../../modules ];

  # Enable YubiKey support
  services.yubikey.enable = true;

  users.users = {
    duponin = {
      isNormalUser = true;
      extraGroups = [
        "adbusers" # ADB
        "docker" # Docker
        "libvirt" # Virtualisation
        "networkmanager" # Network
        "wheel" # Sudo
      ];
    };
  };
}
