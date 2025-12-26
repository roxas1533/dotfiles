# Native-specific home-manager configuration
# This module contains user-level configuration specific to native NixOS

{
  pkgs,
  ...
}:

{
  imports = [
    ./desktop.nix
    ./hyprland.nix
  ];

  # Native-specific home-manager configuration
  home.packages = with pkgs; [
    # Add native-specific user packages if needed
    hyprpanel
    discord
    vivaldi
    wezterm
    nautilus
    freerdp # wlfreerdp for RDP connections

    # Fonts for hyprpanel icons
    (pkgs.nerd-fonts.jetbrains-mono)
    (pkgs.nerd-fonts.symbols-only)
    noto-fonts-cjk-sans
    hackgen-nf-font
  ];

  # Font configuration
  fonts.fontconfig.enable = true;
}
