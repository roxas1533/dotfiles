# Disko configuration for physical machine
# Supports both fresh install and dual-boot scenarios
#
# Fresh install (creates new ESP):
#   nix run github:nix-community/disko -- --mode disko \
#     --arg device '"/dev/sda"' ./disko.nix
#
# Dual-boot (reuse existing ESP):
#   nix run github:nix-community/disko -- --mode disko \
#     --arg device '"/dev/sda"' \
#     --arg espDevice '"/dev/sda1"' ./disko.nix

{ lib, ... }:

let
  # Default values for standalone disko usage
  # When used as NixOS module, these define the actual disk layout
  device = "/dev/nvme0n1";
  espDevice = null; # Set to e.g. "/dev/nvme0n1p1" for dual-boot
in

{
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions =
          # Fresh install: create ESP + root
          (lib.optionalAttrs (espDevice == null) {
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
          })
          # Root partition (always created)
          // {
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

    # Dual-boot: mount existing ESP without formatting
    nodev = lib.optionalAttrs (espDevice != null) {
      "/boot" = {
        fsType = "vfat";
        device = espDevice;
      };
    };
  };
}
