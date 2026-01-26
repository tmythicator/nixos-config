{
  description = "Rog Strix NixOS & macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wp-pin.url = "github:nixos/nixpkgs/871b9fd269ff6246794583ce4ee1031e1da71895";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      user = "dirge";
      wp-pkgs = import inputs.nixpkgs-wp-pin {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        sff-icient = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs user wp-pkgs; };
          modules = [
            ./hosts/nixos/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/nixos/default.nix
                  inputs.sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        macos = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs user; };
          modules = [
            ./hosts/macos/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/macos/default.nix
                  inputs.sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
      };
    };
}
