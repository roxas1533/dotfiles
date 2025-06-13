# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a WSL2 development environment using NixOS with Home Manager for declarative configuration management.

## Key Architecture

**Nix Configuration**: Flake-based system using nixos-wsl for WSL integration
- `flake.nix` - Main system configuration with inputs and outputs
- `configuration.nix` - NixOS system-level configuration  
- `home.nix` - Home Manager user-level configuration

**Neovim Configuration**: Modern Lua-based setup with Lazy.nvim plugin manager
- Organized in `/lua/plugins/` with subdirectories for git, ui, and treesitter plugins
- Uses space as leader key with WSL clipboard integration

**Fish Shell**: Primary shell with WSL-specific functions and development aliases
- Contains `cdw` function for Windows path conversion
- `setWsl` function for Wayland display setup

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

- `.config/nix/` - All Nix configurations
- `.config/nvim/` - Neovim configuration with plugin management
- `.config/fish/` - Fish shell configuration and functions
- `Code/` - VS Code settings and extensions
- `.bin/` - Custom utility scripts

## WSL Integration

The configuration is heavily optimized for WSL2 with:
- Wayland display server support
- Windows-Linux path conversion utilities
- WSL clipboard integration in Neovim
- Japanese locale support (ja_JP.UTF-8, Asia/Tokyo)
