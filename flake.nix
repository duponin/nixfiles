{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixos";
    };
  };
  outputs = { self, nixos, nixos-unstable, home-manager }: {
    nixosConfigurations = {
      enceladus = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/enceladus/configuration.nix
          home-manager.nixosModule
        ];
      };
      mars = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/mars/configuration.nix ];
      };
      venus = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/venus/configuration.nix ];
      };
      hubble = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/hubble/configuration.nix ];
      };
      umbriel = nixos-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration/hosts/umbriel/configuration.nix ];
      };
      earth = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/earth/configuration.nix
          home-manager.nixosModule
        ];
      };
    };
  };
}
