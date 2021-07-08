{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-21.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixos";
    };
  };
  outputs = { self, nixos, home-manager }: {
    nixosConfigurations = {
      reimu = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/reimu/configuration.nix
                    home-manager.nixosModule
                  ];
      };
    };
  };
}
