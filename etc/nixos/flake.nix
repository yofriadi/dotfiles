{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-linux";  # Apple arm M-series processor
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        msl = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/msl/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ymn = import ./home;
            }
          ];
        };
      };
    };
}
