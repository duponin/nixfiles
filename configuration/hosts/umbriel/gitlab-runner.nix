{ config, lib, pkgs, ... }:

{
  services.gitlab-runner = {
    enable = true;
    services = {
      melisse = {
        registrationConfigFile = "/var/lib/secrets/melisse-runner-registration";
        dockerImage = "alpine:latest";
      };
      pleroma = {
        registrationConfigFile = "/var/lib/secrets/pleroma-runner-registration";
        dockerImage = "alpine:latest";
      };
    };
  };
}
