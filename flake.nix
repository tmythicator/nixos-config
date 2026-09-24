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

    antigravity-nix.url = "github:jacopone/antigravity-nix";

    nixpkgs-cuda.url = "github:nixos/nixpkgs/4975466d324710c576dc11ad614684e6bd8cad8e";
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

      pkgs-cuda = import inputs.nixpkgs-cuda {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      overlay = import ./overlays { inherit inputs; };
    in
    {
      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
      };

      nixosConfigurations = {
        sff-icient = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs user pkgs-cuda; };
          modules = [
            ./hosts/sff-icient/default.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [ overlay ];

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
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
              nixpkgs.overlays = [ overlay ];

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { inherit inputs user; };
              home-manager.users.${user} = {
                imports = [
                  ./home/macos/default.nix
                ];
              };
            }
          ];
        };
      };
    };
}
