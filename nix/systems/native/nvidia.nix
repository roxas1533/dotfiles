# NVIDIA GPU configuration for native hardware
{ config, pkgs, ... }:

{
  # NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use the open source kernel module (for Turing+)
    open = true;

    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Power management (experimental)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable nvidia-settings
    nvidiaSettings = true;
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Environment variables for Wayland/Hyprland
  environment.sessionVariables = {
    # Hint to use NVIDIA GPU
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";

    # Cursor fix for NVIDIA
    WLR_NO_HARDWARE_CURSORS = "1";

    # Explicit sync (for newer drivers)
    __GL_GSYNC_ALLOWED = "1";
  };

  # Additional packages for NVIDIA
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia  # GPU monitoring
    libva-utils           # VA-API utilities
  ];
}
