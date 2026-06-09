# Native NixOS configuration (non-WSL) with Hyprland
# This module is automatically imported by common/default.nix when NOT running in WSL

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  hardwareConfigPath = ./hardware-configuration.nix;
  hardwareConfigExists = builtins.pathExists hardwareConfigPath;
in
{
  imports = [
    ./disko.nix
    ./nvidia.nix
  ]
  ++ lib.optionals hardwareConfigExists [ hardwareConfigPath ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";
  console.keyMap = "jp106";

  # Automatic garbage collection (delete generations older than 7 days)
  nix.gc = {
    automatic = true;
    dates = "Tue 13:00";
    options = "--delete-older-than 7d";
  };

  # Rebuild bootloader after garbage collection
  systemd.services.nix-gc-bootloader = {
    description = "Rebuild bootloader after nix garbage collection";
    after = [ "nix-gc.service" ];
    wantedBy = [ "nix-gc.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/bin/switch-to-configuration boot";
    };
  };

  # Mount NTFS game drive
  fileSystems."/mnt/d" = {
    device = "/dev/disk/by-uuid/4CCAAEEACAAED00E";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=033" "nofail" ];
  };

  # Bluetooth (use USB dongle hci1, disable onboard hci0)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };
  # Load hid-nintendo for Pro Controller support
  boot.tmp.useTmpfs = true;
  boot.extraModulePackages = [ ];
  boot.kernelModules = [ "hid-nintendo" ];
  # Disable onboard Bluetooth adapter (13d3:3571)
  # Disable SSP on USB dongle (0a12:0001) for HID gamepad bonding compatibility
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3571", ATTR{authorized}="0"
    ACTION=="add", KERNEL=="hci*", SUBSYSTEM=="bluetooth", RUN+="${pkgs.bluez}/bin/hciconfig %k sspmode 0"
  '';

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Use local time for hardware clock (for Windows dual-boot compatibility)
  time.hardwareClockInLocalTime = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig."10-disable-capture-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_input.*"; }
          ];
          actions.update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        }
      ];
    };
  };

  # Enable Hyprland (from official flake, with portal)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
    portalPackage = inputs.hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland;
  };

  # Display manager for login (auto-login to ro)
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "ro";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Enable polkit for privilege escalation
  security.polkit.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Steam (requires FHS compatibility environment on NixOS)
  programs.steam = {
    enable = true;
    # __GLX_VENDOR_LIBRARY_NAME=nvidia causes Steam's 32-bit libraries to segfault
    package = pkgs.steam.override {
      extraProfile = ''
        unset __GLX_VENDOR_LIBRARY_NAME
        unset GBM_BACKEND
        unset LIBVA_DRIVER_NAME
      '';
      extraBwrapArgs = [
        "--bind /mnt/d /mnt/d"
      ];
    };
  };

  # Required for EasyEffects
  programs.dconf.enable = true;

  # Native-specific packages
  environment.systemPackages = with pkgs; [
    # Wayland core
    wayland
    xwayland

    # Hyprland ecosystem
    swaylock # Screen locker
    swayidle # Idle management daemon
    grim # Screenshot tool
    slurp # Screen area selector
    wlr-randr # Display configuration

    # File manager and utilities
    thunar
    xfce.thunar-archive-plugin # Archive operations in Thunar context menu
    tumbler # Thumbnail service for Thunar
    ffmpegthumbnailer # Video thumbnails for Tumbler
    xarchiver # Lightweight archive manager (zip preview etc.)
    brightnessctl # Backlight control
    playerctl # Media player control
    pavucontrol # PulseAudio volume control
    qpwgraph # PipeWire patchbay GUI
    deepfilternet # DeepFilterNet noise suppression
    alsa-utils # ALSA mixer control (for alsa-mixer-init.service)
  ];

  # Thunar: enable gvfs for trash, MTP, and remote filesystems
  services.gvfs.enable = true;

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
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-hazkey
      fcitx5-gtk
      fcitx5-fluent # Fluentダークテーマ（blur効果付き）
    ];
  };

  # fcitx5をsystemd user serviceとして起動
  # exec-onceで起動するとsession-1.scope内で管理され、シャットダウン時に
  # fcitx5とhazkey-serverが同時にSIGTERMを受けるため、fcitx5のsave()が
  # hazkey-serverを再起動してしまい90秒のタイムアウトが発生する
  systemd.user.services.fcitx5 = {
    description = "Fcitx5 Input Method";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # Electron/Chromiumアプリ（Discord等）をWaylandネイティブで起動させる。
  # XWayland経由ではElectronのXIM入力が壊れておりfcitx5に繋がらないため、
  # NixOSのElectronラッパーがこの変数を見てtext-input-v3経路に切替える。
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Fonts (native only - not needed in WSL)
  fonts.packages = with pkgs; [
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
