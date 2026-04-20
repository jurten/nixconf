{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";  # use same nixpkgs, avoids two copies
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in {
      nixosModules    = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/default/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.work = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/work/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
