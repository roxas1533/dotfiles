# Native-specific home-manager configuration
# This module contains user-level configuration specific to native NixOS

{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./hyprland.nix
    ./noctalia.nix
  ];

  # Add custom scripts to PATH
  home.sessionPath = [ "$HOME/dotfiles/.bin" ];

  home.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";

  # Native-specific home-manager configuration
  home.packages = with pkgs; [
    # Add native-specific user packages if needed
    discord
    (vivaldi.override {
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        # Chromium blocks NVIDIA VA-API by default (kVaapiOnNvidiaGPUs = DISABLED_BY_DEFAULT)
        # VaapiIgnoreDriverChecks bypasses the non-Intel driver blocklist
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks"
        "--ozone-platform=wayland"
      ];
    })
    wezterm
    gimp
    nautilus
    remmina # RDP client with GUI
    # Disable gluploader: broken with GStreamer 1.26+ DRM modifier caps on NVIDIA
    # https://github.com/Rafostar/clapper/issues/560
    (clapper.override {
      clapper-unwrapped = clapper-unwrapped.overrideAttrs (old: {
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dgluploader=disabled" ];
      });
    })
    gst_all_1.gstreamer
    gst_all_1.gstreamer.out  # core plugins (coreelements/typefind) not installed by default in 1.28+
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
      # Video formats
      "video/mp4" = "com.github.rafostar.Clapper.desktop";
      "video/x-matroska" = "com.github.rafostar.Clapper.desktop";
      "video/webm" = "com.github.rafostar.Clapper.desktop";
      "video/mpeg" = "com.github.rafostar.Clapper.desktop";
      "video/quicktime" = "com.github.rafostar.Clapper.desktop";
      "video/x-msvideo" = "com.github.rafostar.Clapper.desktop";
      "video/x-flv" = "com.github.rafostar.Clapper.desktop";
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

  # Clapper: bypass GApplication D-Bus activation (crashes when activated via D-Bus on NVIDIA/Wayland)
  xdg.dataFile."applications/com.github.rafostar.Clapper.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Clapper
    Exec=sh -c 'clapper "$@"' -- %U
    Terminal=false
    MimeType=video/mp4;video/x-matroska;video/webm;video/mpeg;video/quicktime;video/x-msvideo;video/x-flv;
  '';

  # Disable gvfsd-wsdd (WS-Discovery) to avoid timeout on Nautilus startup
  xdg.dataFile."gvfs/mounts/wsdd.mount".text = "";

  # Font configuration
  fonts.fontconfig.enable = true;
}
