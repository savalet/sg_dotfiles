{
  description = "Sigma dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    hosts.url = "github:StevenBlack/hosts";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    onelink.url = "github:Sigmanificient/1l.is";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    ecsls.url = "github:Sigmapitech-meta/ecsls";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , nix-index-database
    , nixos-hardware
    , home-manager
    , onelink
    , hosts
    , ecsls
    , ...
    }:
    let
      username = "sigmanificient";
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};
      colors = import ./colors.nix;

      default_modules = [
        ./config

        nix-index-database.nixosModules.nix-index

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./home;
            extraSpecialArgs = {
              inherit username system ecsls colors;
            };
          };
        }

        hosts.nixosModule
        {
          networking.stevenBlackHosts.enable = true;
        }
      ];

    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        Bacon = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit username colors;
            hostname = "Bacon";
          };

          modules = default_modules ++ [
            ./hardware/bacon.nix

            nixos-hardware.nixosModules.asus-battery
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
          ];
        };

        Sigmachine = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit username colors;
            hostname = "Sigmachine";
          };

          modules = default_modules ++ [
            ./hardware/sigmachine.nix
            ./config/sigmachine.nix
          ];
        };

        Server = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            onelink.nixosModules.${system}.default
            {
              services.onelink.enable = true;
            }

            ./server/configuration.nix
            ./server/hardware-configuration.nix
          ];
        };
      };
    };
}
