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
    hyprpaper # Wallpaper daemon
    discord
    vivaldi
    wezterm
    nautilus
    remmina # RDP client with GUI
    clapper

    # Notification daemon (started via exec-once)
    swaynotificationcenter

    # Audio/Bluetooth settings apps (for Ashell Settings panel)
    pavucontrol
    blueman

    # Fonts for panel icons
    (pkgs.nerd-fonts.jetbrains-mono)
    (pkgs.nerd-fonts.symbols-only)
    noto-fonts-cjk-sans
    hackgen-nf-font
  ];

  # SwayNC - Notification daemon config (started via exec-once in hyprland.nix)
  xdg.configFile."swaync/config.json".text = builtins.toJSON {
    positionX = "right";
    positionY = "top";
    timeout = 10;
    timeout-low = 5;
    timeout-critical = 10; # Critical通知も10秒で消える
    notification-grouping = true;
  };

  # Ashell bar configuration (config managed via symlink in dotfiles/ashell/)
  programs.ashell = {
    enable = true;
    systemd.enable = true; # systemdサービスとして起動
  };

  # SwayOSD - Volume/Brightness OSD indicator
  services.swayosd = {
    enable = true;
    topMargin = 0.9; # 画面下部に表示
  };

  # Font configuration
  fonts.fontconfig.enable = true;
}
