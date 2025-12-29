# Disko configuration for physical machine
# Simple GPT layout: ESP (512M) + root (ext4)
#
# Usage from NixOS ISO:
#   sudo nix run github:roxas1533/dotfiles#install-native
#
# Or manually:
#   sudo nix run github:nix-community/disko -- --mode disko \
#     --arg device '"/dev/nvme0n1"' ./disko.nix

{ lib, device ? "/dev/sda", ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
