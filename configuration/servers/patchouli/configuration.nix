{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../../common/servers
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "patchouli";
    useDHCP = false;
    interfaces.ens18 = {
      ipv4 = {
        addresses = [{
          address = "10.0.20.20";
          prefixLength = 24;
        }];
        routes = [{
          address = "0.0.0.0";
          prefixLength = 0;
          via = "10.0.20.1";
        }];
      };
    };
    nameservers = [ "185.233.100.100" "185.233.100.101" "1.1.1.1" ];
  };

  services = {
    prometheus = {
      enable = true;
      scrapeConfigs = [{
        job_name = "pleroma";
        scrape_interval = "10s";
        metrics_path = "/api/pleroma/app_metrics";
        static_configs = [{
          targets = [
            "freespeechextremist.com"
            "neckbeard.xyz"
            "pl.jeder.pl"
            "princess.cat"
            "shitposter.club"
            "udongein.xyz"
            "zefirchik.xyz"
          ];
        }];
        basic_auth = {
          username = "myusername";
          password = "mypassword";
        };
        scheme = "https";
      }];
    };
    grafana = {
      enable = true;
      addr = "0.0.0.0";
      domain = "graphs.dupon.in";
      auth.anonymous.enable = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ vim ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 3000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
