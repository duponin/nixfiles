# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "dalida"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.interfaces.wwp0s29u1u6i6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ vim ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  services.logind.lidSwitch = "ignore";

  services.transmission = {
    enable = true;
    settings = { "rpc-whitelist" = "192.168.0.*"; };
  };

  services = {
    prometheus = {
      enable = true;
      #extraFlags = [
      #  "--storage.local.retention 8760h"
      #  "--storage.local.series-file-shrink-ratio 0.3"
      #  "--storage.local.memory-chunks 2097152"
      #  "--storage.local.max-chunks-to-persist 1048576"
      #  "--storage.local.index-cache-size.fingerprint-to-metric 2097152"
      #  "--storage.local.index-cache-size.fingerprint-to-timerange 1048576"
      #  "--storage.local.index-cache-size.label-name-to-label-values 2097152"
      #  "--storage.local.index-cache-size.label-pair-to-fingerprints 41943040"
      #];
      scrapeConfigs = [
        {
          job_name = "pleroma";
          scrape_interval = "10s";
          metrics_path = "/api/pleroma/app_metrics";
          static_configs = [{
            targets = [
              "freespeechextremist.com"
              "neckbeard.xyz"
              "udongein.xyz"
            ];
          }];
          basic_auth = {
            username = "myusername";
            password = "mypassword";
          };
          scheme = "https";
        }
        # {
        #   job_name = "fediverse_ping";
        #   scrape_interval = "10s";
        #   metrics_path = "/probe";
        #   params = {
        #     module = ["http_2xx"];
        #   };
        #   static_configs = [{
        #     targets = [
        #       "freespeechextremist.com"
        #       "neckbeard.xyz"
        #       "udongein.xyz"
        #     ];
        #   }];
        # }
      ];
      # exporters.blackbox = {
      #   enable = true;
      #   configFile = "/etc/prometheus-blackbox-exporter.yml";
      # };
    };
    grafana = {
      enable = true;
      addr = "0.0.0.0";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    9091 # transmission
    3000 # grafana
  ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.duponin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "transmission" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
