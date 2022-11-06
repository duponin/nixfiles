{ config, pkgs, ... }:

{
  imports = [ ../../common/workstation.nix ];

  # This computer uses a nvidia graphic card
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # Allow unfree packages, for nvidia package
  nixpkgs.config.allowUnfree = true;

  hardware.keyboard.zsa.enable = true;

  services = {
    postgresql = {
      enable = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 127.0.0.1/32 trust
      '';
    };
  };

  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;

  # Trial for Docker Nvidia
  virtualisation.docker.enableNvidia = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Logitech fun and stuff
  hardware.logitech.wireless.enable = true;
}
