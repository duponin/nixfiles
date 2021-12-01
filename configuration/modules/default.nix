{ ... }:

{
  imports = [ # Find a method to auto-import modules
    ./android.nix
    ./apple.nix
    ./audiovisual.nix
    ./docker.nix
    ./doom-emacs.nix
    ./flakes.nix
    ./home-manager.nix
    ./shell.nix
    ./zsa.nix # Keyboard (ex: ergodox-ez)
  ];
}
