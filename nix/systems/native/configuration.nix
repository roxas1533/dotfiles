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
  boot.loader.systemd-boot.consoleMode = "max";
  console.keyMap = "jp106";

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  virtualisation.hypervGuest.enable = true;
  boot.initrd.kernelModules = [ "hyperv_drm" ];
  # 動的解像度のためカーネルパラメータは指定しない

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # xdg-desktop-portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display manager for login (auto-login to ro)
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "ro";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Enable polkit for privilege escalation
  security.polkit.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Noise canceling (RNNoise-based)
  programs.noisetorch.enable = true;

  # Native-specific packages
  environment.systemPackages = with pkgs; [
    # Wayland core
    wayland
    xwayland

    # Hyprland ecosystem
    waybar # Status bar
    walker # Application launcher
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
      fcitx5-fluent # Fluentダークテーマ（blur効果付き）
    ];
  };

  # Fonts (native only - not needed in WSL)
  fonts.packages = with pkgs; [
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
