{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./gitlab-runner.nix
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
  networking.domain = "locahlost.net";
  networking.nameservers = [ "185.233.100.100" "2a0c:e300::100" ];

  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose ];

  networking.useDHCP = false;
  networking.interfaces.eth0 = {
    mtu = 1378;
    ipv4 = {
      addresses = [{
        address = "185.233.102.141";
        prefixLength = 26;
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a0c:e300:12::141";
        prefixLength = 48;
      }];
    };
  };
  networking.defaultGateway = {
    address = "185.233.102.190";
    interface = "eth0";
  };
  networking.defaultGateway6 = {
    address = "2a0c:e300:12::190";
    interface = "eth0";
  };

  system.stateVersion = "22.11";
}
