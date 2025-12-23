# HyprPanel (AGS) Configuration

This directory contains the AGS (Aylur's Gtk Shell) configuration for HyprPanel.

## Initial Setup

HyprPanel will automatically generate its configuration on first run.
After the first run, you can customize the configuration files here.

## Configuration Files

The typical structure includes:
- `config.js` or `config.ts` - Main configuration file
- Additional module files as needed

## Customization

After running `sudo nixos-rebuild switch --flake /home/ro/dotfiles` and starting Hyprland,
HyprPanel will generate default configuration files in `~/.config/ags/`.

You can then customize those files, and they will be managed through this dotfiles directory.
