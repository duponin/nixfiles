{ pkgs, ... } :

{
  services.emacs.enable = true;
  services.lorri.enable = true;
  environment.systemPackages = with pkgs; [
    # required dependencies
    git
    emacs    # Emacs 27.2
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang

    # utilities
    direnv
    nix-direnv
  ];
  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
}
