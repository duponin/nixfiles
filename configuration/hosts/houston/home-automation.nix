{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    8123 # Home-Assistant
    21064 # Homekit integration
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # Device discovery
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.deconz = {
      image = "deconzcommunity/deconz:2.19.03"; # Warning: if the tag does not change, the image will not be updated
      volumes = [ "deconz:/opt/deCONZ" ];
      ports = [ "8080:8080" "8443:8443" ];
      environment = {
        TZ = "Europe/Paris";
        DEBUG_INFO = "1";
        DECONZ_WEB_PORT = "8080";
        DECONZ_WS_PORT = "8443";
        DECONZ_UID = "1000";
        DECONZ_GID = "1000";
      };
      extraOptions = [
        "--device=/dev/ttyACM0:/dev/ttyACM0"
      ];
    };
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/Paris";
      image = "ghcr.io/home-assistant/home-assistant:2023.2.0.dev20230101"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
