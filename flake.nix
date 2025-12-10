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
    mcp-server-mysql = {
      url = "github:benborla/mcp-server-mysql";
      flake = false;
    };
    mcp-language-server = {
      url = "github:isaacphi/mcp-language-server";
      flake = false;
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
      overlays = import ./nix/overlays { inherit inputs; };

      # Helper function to create pkgs with overlays
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
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

      # Helper to build a NixOS configuration; WSL/native をユーザーが明示指定する
      mkNixosConfig =
        {
          name,
          isWSL,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs isWSL;
          };
          modules = [
            # Import nixos-wsl module only when in WSL
            (
              if isWSL then
                nixos-wsl.nixosModules.default
              else
                { }
            )
            ./nix/systems/common
            # Import platform-specific configuration
            (
              if isWSL then
                ./nix/systems/wsl/configuration.nix
              else
                ./nix/systems/native/configuration.nix
            )
            {
              system.stateVersion = "25.05";
              nixpkgs.overlays = overlays;
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ro =
                { pkgs, ... }:
                {
                  imports =
                    homeModules pkgs
                    ++ (
                      if isWSL then
                        [ ./nix/modules/wsl ]
                      else
                        [ ./nix/modules/native ]
                    );
                };
            }
          ];
        };
    in
    {
      # NixOS configurations: 明示的に WSL / Native を選択する
      # 互換のため `.#nixos` は WSL 用として扱う
      nixosConfigurations = {
        nixos = mkNixosConfig {
          name = "nixos";
          isWSL = true;
        };
        nixos-wsl = mkNixosConfig {
          name = "nixos-wsl";
          isWSL = true;
        };
        nixos-native = mkNixosConfig {
          name = "nixos-native";
          isWSL = false;
        };
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
          treefmtWrapper = treefmt-nix.lib.mkWrapper pkgs {
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
        in
        {
          # NixOS switch helpers
          switch = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "switch-wsl" ''
                exec sudo nixos-rebuild switch --flake ${self}#nixos-wsl "$@"
              ''
            );
          };
          switch-native = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "switch-native" ''
                exec sudo nixos-rebuild switch --flake ${self}#nixos-native "$@"
              ''
            );
          };

          # Format and lint code
          fmt = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "treefmt-wrapper" ''
                exec ${treefmtWrapper}/bin/treefmt "$@"
              ''
            );
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
