{ config, lib, pkgs, ... }:

{
  services.gitlab-runner = {
    enable = true;
    services = {
      melisse = {
        registrationConfigFile = "/var/lib/secrets/melisse-runner-registration";
        dockerImage = "alpine:latest";
      };
    };
  };
}
