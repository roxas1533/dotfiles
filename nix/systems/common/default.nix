# Common NixOS configuration shared between WSL and native systems
# This module contains settings that are platform-agnostic

{
  config,
  lib,
  pkgs,
  isWSL,
  ...
}:

{
  # Enable flakes and nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Virtualization & Services
  virtualisation.docker.enable = true;
  services.openssh.enable = true;

  # Programs
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # User configuration
  users.users.ro = {
    isNormalUser = true;
    home = "/home/ro";
    description = "Default my user";
    extraGroups = [
      "wheel"
      "docker"
    ]; # Platform-specific modules can add more groups
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$QRezdLXPE44Zrgr39Sk.a/$GoopaJdSpCPXdF0sl1X7Qim3QAoDbdWOQXSOkyuzNIC";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRs42T+W9UElw7eC4o5zYW0cvm3GLNwdOWdrjGFo0AW ro@nixos"
    ];
  };

  # Unfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "gh-copilot"
      "claude-code"
    ];

  # Core system packages (minimal set needed on all platforms)
  environment.systemPackages = with pkgs; [
    wget
    neovim
    fish
    git
    lsof
    nodejs
    wl-clipboard # Works on both WSL (wslg) and native (wayland)
  ];

  # Localization
  i18n.defaultLocale = "ja_JP.UTF-8";
  time.timeZone = "Asia/Tokyo";

  # Security: Custom CA certificates
  security.pki.certificateFiles = [
    ./sharedpx_ca_sha2.crt
  ];
}
