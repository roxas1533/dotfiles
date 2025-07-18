# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  pkgs,
  ...
}:

{
  # imports = [
  #   # include NixOS-WSL modules
  #   <nixos-wsl/modules>
  # ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  wsl = {
    enable = true;
    defaultUser = "ro";
    wslConf = {
      boot.command = ''
        ln -s /mnt/wslg/runtime-dir/wayland-0* "$XDG_RUNTIME_DIR"
      '';
    };
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "gh-copilot"
      "claude-code"
    ];
  environment.systemPackages = with pkgs; [
    wget
    neovim
    fish
    git
    lsof
    wl-clipboard
    nodejs
  ];

  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  users.users.ro = {
    isNormalUser = true;
    home = "/home/ro";
    description = "Default my user";
    extraGroups = [
      "wheel"
      "users"
      "docker"
    ];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$QRezdLXPE44Zrgr39Sk.a/$GoopaJdSpCPXdF0sl1X7Qim3QAoDbdWOQXSOkyuzNIC";
  };
  i18n.defaultLocale = "ja_JP.UTF-8";
  time.timeZone = "Asia/Tokyo";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
