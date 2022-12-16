{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/0398dd769fa941ce8ce893b3f9e21dcd397e569e";
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
      halley = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/halley/configuration.nix
          home-manager.nixosModule
        ];
      };
      titan = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/titan/configuration.nix ];
      };
      endeavour = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/endeavour/configuration.nix ];
      };

      #-------------
      # Homelab part

      nomad-01 = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/nomad-01/configuration.nix ];
      };

    };
  };
}
