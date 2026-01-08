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
    ./walker.nix
  ];

  # Add custom scripts to PATH
  home.sessionPath = [ "$HOME/dotfiles/.bin" ];

  # Native-specific home-manager configuration
  home.packages = with pkgs; [
    # Add native-specific user packages if needed
    hyprpanel
    hyprpaper # Wallpaper daemon
    discord
    vivaldi
    wezterm
    nautilus
    remmina # RDP client with GUI

    # Fonts for hyprpanel icons
    (pkgs.nerd-fonts.jetbrains-mono)
    (pkgs.nerd-fonts.symbols-only)
    noto-fonts-cjk-sans
    hackgen-nf-font
  ];

  # Font configuration
  fonts.fontconfig.enable = true;
}
