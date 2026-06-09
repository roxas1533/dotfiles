# Native-specific home-manager configuration
# This module contains user-level configuration specific to native NixOS

{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./desktop.nix
    ./hyprland.nix
    ./noctalia.nix
  ];

  # Add custom scripts to PATH
  home.sessionPath = [ "$HOME/dotfiles/.bin" ];

  home.sessionVariables = {
    GST_PLUGIN_SYSTEM_PATH_1_0 = "/etc/profiles/per-user/${config.home.username}/lib/gstreamer-1.0";
  };

  # Native-specific home-manager configuration
  home.packages = with pkgs; [
    # Add native-specific user packages if needed
    discord
    (vivaldi.override {
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        "--enable-features=VaapiVideoEncoder"
      ];
    })
    wezterm
    nautilus
    remmina # RDP client with GUI
    clapper
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    mission-center
    libnotify
    grim
    slurp
    loupe

    # Audio/Bluetooth settings apps
    pavucontrol
    blueman

    # Fonts for panel icons
    (pkgs.nerd-fonts.jetbrains-mono)
    (pkgs.nerd-fonts.symbols-only)
    noto-fonts-cjk-sans
    hackgen-nf-font
  ];

  # デフォルトの画像ビューアーをimvに設定
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
      # Archive formats — open with xarchiver for preview
      "application/zip" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
      "application/gzip" = "xarchiver.desktop";
      "application/x-bzip2" = "xarchiver.desktop";
      "application/x-xz" = "xarchiver.desktop";
      "application/x-7z-compressed" = "xarchiver.desktop";
      "application/x-rar" = "xarchiver.desktop";
    };
  };

  # Disable gvfsd-wsdd (WS-Discovery) to avoid timeout on Nautilus startup
  xdg.dataFile."gvfs/mounts/wsdd.mount".text = "";

  # Font configuration
  fonts.fontconfig.enable = true;
}
