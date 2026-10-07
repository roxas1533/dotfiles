# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using NixOS with Home Manager for declarative configuration management. It supports multiple platforms: WSL2, native Linux (with Hyprland), and standalone home-manager for non-NixOS Linux.

## Key Architecture

**Nix Configuration**: Flake-based system with multiple targets
- `flake.nix` - Main system configuration with inputs and outputs
- `nix/systems/wsl/` - WSL2-specific NixOS configuration
- `nix/systems/native/` - Native Linux configuration (Hyprland, disko)
- `nix/modules/wsl/`, `nix/modules/native/`, `nix/modules/linux/` - Platform-specific Home Manager modules

Available configurations:
- `nixosConfigurations.nixos-wsl` — WSL2
- `nixosConfigurations.nixos-native` — Native Linux
- `homeConfigurations.ro` — Standalone home-manager (non-NixOS Linux)
- `homeConfigurations.server` — Server (rocky user)

**Neovim Configuration**: Modern Lua-based setup with Lazy.nvim plugin manager
- Organized in `/lua/plugins/` with subdirectories for git, ui, and treesitter plugins
- Uses space as leader key; clipboard integration varies by platform

**Fish Shell**: Primary shell with platform-specific functions and development aliases
- Contains `cdw` function for Windows path conversion (WSL only)
- `setWsl` function for Wayland display setup (WSL only)

## Common Commands

**System Management**:
```bash
# Update system
nix flake update
sudo nixos-rebuild switch --flake .

# Home Manager updates
sudo nixos-rebuild switch --flake .
```

**Git Workflow**:
- Use `lazygit` for interactive git operations (integrated with delta pager)
- Use `gh` for GitHub CLI operations
- Delta is configured for enhanced diff viewing

**Development**:
- `nvim` - Primary editor with LSP support for TypeScript, Lua, Rust, Nix
- `direnv allow` - Enable project-specific environments
- Language servers are pre-configured through Nix

## File Organization

- `nix/` - Nix module configurations (packages, dotfiles, platform-specific)
- `flake.nix` - Main flake configuration with inputs and outputs
- `fish/` - Fish shell configuration and functions
- `nvim/` - Neovim configuration with plugin management
- `git/`, `lazygit/`, `gh/` - Version control tool configurations
- `.bin/` - Custom utility scripts

Configuration files are symlinked to `~/.config/` by Nix home-manager activation scripts.

## Platform Notes

**WSL2** (`nixos-wsl`, `nixos`): Wayland display via `setWsl`, Windows path conversion via `cdw`, WSL clipboard in Neovim. Japanese locale (ja_JP.UTF-8, Asia/Tokyo).

**Native Linux** (`nixos-native`): Hyprland compositor, disko for disk partitioning. `nix run .#switch-native` to apply; reboots if kernel was updated.

**Common**: Japanese locale applied across all platforms.
