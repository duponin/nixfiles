{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixos";
    };
  };
  outputs = { self, nixos, nixos-unstable, home-manager }: {
    nixosConfigurations = {
      hubble = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/hubble/configuration.nix ];
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
      kourou = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/kourou/configuration.nix ];
      };
      pluto = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/pluto/configuration.nix ];
      };
      houston = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/houston/configuration.nix ];
      };
      columbia = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/columbia/configuration.nix ];
      };
      umbriel = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration/hosts/umbriel/configuration.nix ];
      };


      #-------------
      # Homelab part

      #-----
      # Misc

      melisse = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/melisse/configuration.nix ];
      };

    };
  };
}
