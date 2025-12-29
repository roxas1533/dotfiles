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
    disko = {
      url = "github:nix-community/disko";
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
      disko,
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
            (if isWSL then nixos-wsl.nixosModules.default else { })
            # Import disko module only for native (physical machine)
            (if isWSL then { } else disko.nixosModules.disko)
            ./nix/systems/common
            # Import platform-specific configuration
            (if isWSL then ./nix/systems/wsl/configuration.nix else ./nix/systems/native/configuration.nix)
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
                  imports = homeModules pkgs ++ (if isWSL then [ ./nix/modules/wsl ] else [ ./nix/modules/native ]);
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

          # Install NixOS from ISO boot (local installation)
          # Usage: Boot NixOS ISO, then run: nix run github:roxas1533/dotfiles#install-native
          install-native = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "install-native" ''
                set -euo pipefail

                echo "=== NixOS Native Installation ==="
                echo ""

                # Check if running as root
                if [ "$EUID" -ne 0 ]; then
                  echo "Error: Please run as root (sudo)"
                  exit 1
                fi

                # Show available disks
                echo "Available disks:"
                lsblk -d -o NAME,SIZE,MODEL
                echo ""

                # Default disk from disko.nix is /dev/sda
                read -p "Target disk [/dev/sda]: " DISK
                DISK=''${DISK:-/dev/sda}

                if [ ! -b "$DISK" ]; then
                  echo "Error: $DISK is not a valid block device"
                  exit 1
                fi

                echo ""
                echo "WARNING: This will ERASE ALL DATA on $DISK"
                read -p "Are you sure? (yes/no): " CONFIRM
                if [ "$CONFIRM" != "yes" ]; then
                  echo "Aborted."
                  exit 1
                fi

                echo ""
                echo "Step 1/3: Partitioning $DISK with disko..."
                nix run github:nix-community/disko -- \
                  --mode disko \
                  --arg device "\"$DISK\"" \
                  ${self}/nix/systems/native/disko.nix

                echo ""
                echo "Step 2/3: Installing NixOS..."
                nixos-install --flake ${self}#nixos-native --no-root-passwd

                echo ""
                echo "Step 3/3: Installation complete!"
                echo "You can now reboot into your new NixOS system."
                echo ""
                read -p "Reboot now? (yes/no): " REBOOT
                if [ "$REBOOT" = "yes" ]; then
                  reboot
                fi
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
