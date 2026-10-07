# Native-specific home-manager configuration
# This module contains user-level configuration specific to native NixOS

{ pkgs, inputs, ... }:

let
  # siroio/preview-psd-clip.yazi patched to avoid require("magick").with_limit()
  # which adds -limit disk 1MiB and causes exit 1 on large PSD files.
  preview-psd-clip = pkgs.writeTextDir "main.lua" ''
    local M = {}

    local function extract_psd_jpg(path, dst)
      local cmd = Command("magick"):arg { "-limit", "thread", 1 }
      cmd:arg { "-define", "image:frames=0", tostring(path) }
      cmd:arg { "-auto-orient", "-strip" }

      local size = string.format("%dx%d>", rt.preview.max_width, rt.preview.max_height)
      if rt.preview.image_filter == "nearest" then
        cmd:arg { "-sample", size }
      elseif rt.preview.image_filter == "catmull-rom" then
        cmd:arg { "-filter", "catrom", "-thumbnail", size }
      elseif rt.preview.image_filter == "lanczos3" then
        cmd:arg { "-filter", "lanczos", "-thumbnail", size }
      elseif rt.preview.image_filter == "gaussian" then
        cmd:arg { "-filter", "gaussian", "-thumbnail", size }
      else
        cmd:arg { "-filter", "triangle", "-thumbnail", size }
      end

      local status, err = cmd:arg { "-quality", rt.preview.image_quality, "JPG:" .. dst }:status()
      if not status then
        return false, Err("psd-clip: failed to start `magick`: %s", err)
      elseif not status.success then
        return false, Err("psd-clip: `magick` failed (exit code %s)", status.code)
      end
      return true
    end

    function M:peek(job)
      local start, cache = os.clock(), ya.file_cache(job)
      if not cache then return end

      if not fs.cha(cache) then
        local ok, err = extract_psd_jpg(job.file.path, tostring(cache))
        if not ok then return ya.preview_widget(job, err) end
      end

      ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

      local _, err = ya.image_show(cache, job.area)
      ya.preview_widget(job, err)
    end

    function M:seek() end

    function M:spot(job) require("file"):spot(job) end

    return M
  '';
in

{
  imports = [
    ./desktop.nix
    ./hyprland.nix
    ./noctalia.nix
    ./gaming.nix
  ];

  # Add custom scripts to PATH
  home.sessionPath = [ "$HOME/dotfiles/.bin" ];

  home.sessionVariables.LIBVA_DRIVER_NAME = "nvidia";

  # Native-specific home-manager configuration
  home.packages = with pkgs; [
    # Add native-specific user packages if needed
    ffmpeg
    libwebp # cwebp: batch image -> WebP conversion (cwebp + xargs)
    rclone
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
    inputs.psd-viewer.packages.${pkgs.stdenv.hostPlatform.system}.default
    imagemagick
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
    gst_all_1.gstreamer.out # core plugins (coreelements/typefind) not installed by default in 1.28+
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
      "image/vnd.adobe.photoshop" = "psd-viewer.desktop";
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

  # Disable gvfsd-wsdd (WS-Discovery) to avoid timeout on Nautilus startup
  xdg.dataFile."gvfs/mounts/wsdd.mount".text = "";

  # Font configuration
  fonts.fontconfig.enable = true;

  # PSD/PSB preview via siroio/preview-psd-clip.yazi (native only)
  programs.yazi.plugins.preview-psd-clip = preview-psd-clip;
  programs.yazi.settings.plugin.prepend_previewers = [
    {
      url = "*.{psd,psb}";
      run = "preview-psd-clip";
    }
  ];

  # PSD/PSB opener: xdg-open fails on Hyprland (no DE detection), use gio open.
  # Changing the app only requires updating xdg.mimeApps, not this rule.
  programs.yazi.settings.opener.psd = [
    {
      run = "gio open %s";
      desc = "Open";
      for = "unix";
    }
  ];
  programs.yazi.settings.open.prepend_rules = [
    {
      url = "*.{psd,psb}";
      use = "psd";
    }
  ];
}
