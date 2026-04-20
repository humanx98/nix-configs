{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugin-mellifluous = {
      url = "github:ramojus/mellifluous.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      hostSystem = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${hostSystem};
      user-info = {
        name = "human";
        description = "Bohdan";
        platform = "amd";
        git = {
          name = "Bohdan Semenov";
          email = "bodyasemzen@gmail.com";
        };
      };
    in
    {
      nixosConfigurations = {

        # work-pc-rx6800xt = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     hardware-module = ./hardware/work-pc-rx6800xt;
        #     # vm-hooks-module = ./hardware/work-pc-rx6800xt/vm-hooks.nix;
        #     inherit user-info;
        #     # inherit inputs;
        #   };
        #   modules = [
        #     ./configuration.nix
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.backupFileExtension = "backup";
        #       home-manager.extraSpecialArgs = {
        #         inherit inputs;
        #         inherit user-info;
        #         pkgs-unstable = import inputs.nixpkgs-unstable {
        #           system = hostSystem;
        #         };
        #       };
        #       home-manager.useUserPackages = true;
        #       home-manager.users.${user-info.name} = import ./home.nix;
        #     }
        #   ];
        # };

        asus-rog-strix-ae = nixpkgs.lib.nixosSystem {
          specialArgs = {
            hardware-module = ./hardware/asus-rog-strix-ae;
            # vm-hooks-module = ./hardware/asus-rog-strix-ae/vm-hooks.nix;
            host-info = {
              hostName = "asus-rog-strix-ae";
            };
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
                pkgs-unstable = import inputs.nixpkgs-unstable {
                  system = hostSystem;
                  config.allowUnfree = true;
                };
              };
              home-manager.useUserPackages = true;
              home-manager.users.${user-info.name} = import ./home.nix;
            }
          ];
        };

      };
    };
}
