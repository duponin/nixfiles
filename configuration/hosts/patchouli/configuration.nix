{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ../../common/servers
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  networking = {
    firewall.allowedTCPPorts = [
      22 # SSH
      3000 # Grafana
    ];
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
    openssh.enable = true;
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
            "pl.eragon.re"
            "pl.jeder.pl"
            "pleroma.amoonrabbit.reisen"
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

  system.stateVersion = "20.09";
}
