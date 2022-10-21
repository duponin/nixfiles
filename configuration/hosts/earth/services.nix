{ config, pkgs, ... }:

{
  services = {
    fail2ban = {
      enable = true;
      bantime-increment.enable = true;
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
      permitRootLogin = "no";
    };
    code-server = {
      enable = true;
      auth = "none";
    };
  };
  programs.mosh.enable = true;
}
