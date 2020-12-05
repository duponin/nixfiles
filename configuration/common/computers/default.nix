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
      hashedPassword =
        "$6$B4aVuuUQeBFz$Zg6I0kxFqJTPw/.wbPwzdWXYV.OpNkHhWbPJZPW0iBpDP.EC1860IsnVlZhOSnpzGce0WZ/qFNQNPNsDkapYb0";

    };
  };
}
