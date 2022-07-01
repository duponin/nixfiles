{
  inputs = {
    agenix.url = "github:ryantm/agenix";
    nixos.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixos";
    };
  };
  outputs = { self, agenix, nixos, home-manager }: {
    nixosConfigurations = {
      reimu = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/reimu/configuration.nix
          home-manager.nixosModule
        ];
      };
      sarah = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/sarah/configuration.nix
          home-manager.nixosModule
        ];
      };
      katyusha = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/katyusha/configuration.nix
          home-manager.nixosModule
        ];
      };
      enceladus = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/enceladus/configuration.nix
          agenix.nixosModule
          home-manager.nixosModule
        ];
      };
      mars = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration/hosts/mars/configuration.nix
          agenix.nixosModule
        ];
      };
      venus = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/venus/configuration.nix ];
      };
      hubble = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration/hosts/hubble/configuration.nix ];
      };
    };
  };
}
