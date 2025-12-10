# Native NixOS configuration (non-WSL) with Hyprland
# This module is automatically imported by common/default.nix when NOT running in WSL

{
  lib,
  pkgs,
  ...
}:

let
  hardwareConfigPath = ./hardware-configuration.nix;
  hardwareConfigExists = builtins.pathExists hardwareConfigPath;
in
{
  imports = lib.optionals hardwareConfigExists [ hardwareConfigPath ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display manager for login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable polkit for privilege escalation
  security.polkit.enable = true;

  # Native-specific packages
  environment.systemPackages = with pkgs; [
    # Wayland core
    wayland
    xwayland

    # Hyprland ecosystem
    waybar # Status bar
    wofi # Application launcher
    mako # Notification daemon
    swaylock # Screen locker
    swayidle # Idle management daemon
    grim # Screenshot tool
    slurp # Screen area selector
    wlr-randr # Display configuration

    # File manager and utilities
    xfce.thunar
    brightnessctl # Backlight control
    playerctl # Media player control
    pavucontrol # PulseAudio volume control
  ];

  # Additional user groups for native (adds to common)
  users.users.ro.extraGroups = [
    "networkmanager"
    "video" # For brightness control
    "audio" # For audio control
  ];

  # Japanese input method (native only - not useful in WSL headless)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  # Fonts (native only - not needed in WSL)
  fonts.packages = with pkgs; [
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
