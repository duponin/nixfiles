{ ... }:

{
  imports = [ # Find a method to auto-import modules
    ./android.nix
    ./audiovisual.nix
    ./doom-emacs.nix
    ./flakes.nix
    ./shell.nix
    ./zsa.nix # Keyboard (ex: ergodox-ez)
  ];
}
