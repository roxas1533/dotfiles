{
  description = "ro's dotfiles with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Import overlays
      overlays = import ./nix/overlays;

      # Helper function to create pkgs with overlays
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "gh-copilot"
            "claude-code"
          ];
        overlays = overlays;
      };

      # Import helper functions
      helpers = import ./nix/modules/lib/helpers/activation.nix { lib = nixpkgs.lib; };

      # Common home-manager modules
      homeModules = pkgs: [
        ./nix/modules/home
        {
          _module.args = {
            inherit helpers;
            dotfilesDir = "/home/ro/dotfiles";
          };
        }
      ];
    in
    {
      # NixOS configuration for WSL2
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          nixos-wsl.nixosModules.default
          ./.config/nix/configuration.nix
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
            nixpkgs.overlays = overlays;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ro = { pkgs, ... }: {
              imports = homeModules pkgs ++ [
                ./nix/modules/wsl
              ];
            };
          }
        ];
      };

      # Standalone home-manager configuration for non-NixOS Linux
      homeConfigurations.ro = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        modules = homeModules (mkPkgs system) ++ [
          ./nix/modules/linux
        ];
      };

      # Apps for CI and development
      apps.${system} =
        let
          pkgs = mkPkgs system;
          treefmtEval = treefmt-nix.lib.evalModule pkgs {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };
              stylua.enable = true;
            };
            settings = {
              global.excludes = [
                ".git/**"
                "*.lock"
              ];
            };
          };
          treefmtWrapper = treefmtEval.config.build.wrapper;
        in
        {
          # Format and lint code
          fmt = {
            type = "app";
            program = toString treefmtWrapper;
          };

          # Restore Neovim plugins (placeholder for now)
          nvim-restore = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "nvim-restore" ''
                echo "Neovim plugin restore not yet implemented"
                exit 0
              ''
            );
          };
        };
    };
}
