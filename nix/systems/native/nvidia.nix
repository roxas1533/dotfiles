# NVIDIA GPU configuration for native hardware
{ config, pkgs, ... }:

{
  # Load nvidia-uvm at boot (required for CUDA / VA-API)
  boot.kernelModules = [ "nvidia-uvm" ];

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
    extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };

  # Environment variables for Wayland/Hyprland
  environment.sessionVariables = {
    # Hint to use NVIDIA GPU
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";

    # Cursor fix for NVIDIA
    WLR_NO_HARDWARE_CURSORS = "1";

    # Explicit sync (for newer drivers)
    __GL_GSYNC_ALLOWED = "1";
  };

  # Additional packages for NVIDIA
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia # GPU monitoring
    libva-utils # VA-API utilities
  ];
}
