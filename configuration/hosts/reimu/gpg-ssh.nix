{ pkgs, ... }:

{
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };
  services = {
    pcscd.enable = true;
  };
}
