{ lib, config, pkgs, ... }:
with lib;
let cfg = config.locahlost.monitoring-agent;
in {
  options.locahlost.monitoring-agent = {
    enable = mkEnableOption "Monitoring agent";

    interface = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The interface on which monitoring scraping is not filtered.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters.node = mkMerge [
      { enable = true; }
      (mkIf (cfg.interface != null) {
        openFirewall = true;
        firewallFilter = "-i ${cfg.interface} -p tcp -m tcp --dport 9100";
      })
    ];

    services.vector = {
      enable = true;
      journaldAccess = true;
      settings = {
        sinks.locahlost_loki_sink = {
          type = "loki";
          inputs = [ "journald" ];
          endpoint = "https://monitoring.locahlo.st/loki";
          compression = "none";
          labels.forwarder = "vector";
          encoding.codec = "json";
        };
        sources.journald = {
          type = "journald";
          current_boot_only = true;
        };
      };
    };
  };
}
