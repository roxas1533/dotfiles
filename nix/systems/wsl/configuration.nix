# WSL-specific NixOS configuration
# This module is automatically imported by common/default.nix when running in WSL

{ ... }:

{
  # WSL-specific settings
  wsl = {
    enable = true;
    defaultUser = "ro";
    wslConf.boot.command = ''
      ln -s /mnt/wslg/runtime-dir/wayland-0* "$XDG_RUNTIME_DIR"
    '';
  };

  # Enable systemd-networkd (config in /etc/systemd/network/)
  systemd.network.enable = true;

  # WSL doesn't need additional user groups beyond common
  # WSL doesn't need additional packages beyond common

  # Cloudflare WARP VPN
  services.cloudflare-warp.enable = true;

  # Nix settings
  nix.settings = {
    trusted-users = [
      "root"
      "ro"
    ];
  };
}
