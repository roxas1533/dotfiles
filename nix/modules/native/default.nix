# Native-specific home-manager configuration
# This module contains user-level configuration specific to native NixOS
# Currently minimal, can be expanded with:
# - Hyprland user config (~/.config/hypr/hyprland.conf)
# - Waybar configuration
# - GTK themes
# - Additional desktop tools

{
  pkgs,
  lib,
  config,
  ...
}:

{
  # Native-specific home-manager configuration
  home.packages = with pkgs; [
    # Add native-specific user packages if needed
  ];
}
