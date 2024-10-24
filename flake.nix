{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugin-mellifluous = {
      url = "github:ramojus/mellifluous.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      user-info = {
        name = "human";
        description = "Bohdan";
        git = {
          name = "Bohdan Semenov";
          email = "bodyasemzen@gmail.com";
        };
      };
    in
    {
      nixosConfigurations = {

        work-pc-rx6800xt = nixpkgs.lib.nixosSystem {
          specialArgs = {
            hardware-module = ./hardware/work-pc-rx6800xt;
            vm-hooks-module = ./hardware/work-pc-rx6800xt/vm-hooks.nix;
            inherit user-info;
            # inherit inputs;
          };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit user-info;
              };
              home-manager.useUserPackages = true;
              home-manager.users.${user-info.name} = import ./home.nix;
            }
          ];
        };

        asus-rog-strix-ae = nixpkgs.lib.nixosSystem {
          specialArgs = {
            hardware-module = ./hardware/asus-rog-strix-ae;
            vm-hooks-module = ./hardware/asus-rog-strix-ae/vm-hooks.nix;
            inherit user-info;
            # inherit inputs;
          };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit user-info;
              };
              home-manager.useUserPackages = true;
              home-manager.users.${user-info.name} = import ./home.nix;
            }
          ];
        };

      };
    };
}
