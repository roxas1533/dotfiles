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

### NixOS (Native)

1. Clone this repository:
   ```sh
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Generate and copy hardware configuration:
   ```sh
   sudo nixos-generate-config
   cp /etc/nixos/hardware-configuration.nix \
      ~/dotfiles/nix/systems/native/hardware-configuration.nix
   ```

3. Apply configuration:
   ```sh
   sudo nixos-rebuild switch --flake .#nixos-native
   # または: nix run .#switch-native
   ```

4. Reload shell:
   ```sh
   exec fish
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
# NixOS
nrc

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
