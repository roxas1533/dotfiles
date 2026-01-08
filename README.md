# dotfiles

Personal dotfiles managed with Nix for WSL2 and Linux environments.

## Initial Setup

### NixOS (WSL2)

1. Clone this repository:
   ```sh
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Apply configuration:
   ```sh
   nix flake update
   sudo nixos-rebuild switch --flake .
   ```

3. Reload shell:
   ```sh
   exec fish
   ```

### NixOS (Native) - Fresh Install

Boot from [NixOS ISO](https://nixos.org/download), then run:

```sh
sudo nix run github:roxas1533/dotfiles#install-native \
  --experimental-features "nix-command flakes"
```

This will:
1. Show available disks and prompt for target device
2. Partition and format with disko (ESP + root)
3. Install NixOS with this configuration
4. Prompt to reboot

### NixOS (Native) - Existing System

1. Clone this repository:
   ```sh
   git clone https://github.com/roxas1533/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Apply configuration:
   ```sh
   nrs
   # または: nix run .#switch-native
   ```

### Linux (Home Manager)

1. Install Nix:
   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Clone and apply:
   ```sh
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   nix run . -- switch --flake .#ro
   ```

## Daily Usage

Apply changes after editing configuration:

```sh
# NixOS (WSL/Native auto-detect)
nrs

# Linux (Home Manager)
home-manager switch --flake .#ro

# Update dependencies
nix flake update
```

## Customization

### Add Packages

Edit `nix/modules/home/packages.nix`:
```nix
home.packages = with pkgs; [
  your-package
];
```

### Add Dotfiles

1. Move config to repository root
2. Add symlink in `nix/modules/home/dotfiles.nix`
3. Apply configuration

## Rollback

```sh
sudo nixos-rebuild switch --rollback
```

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)
- [disko](https://github.com/nix-community/disko) - Declarative disk partitioning
