# Hardware configuration for physical machine
# Note: fileSystems are managed by disko.nix
#
# After running nixos-anywhere, you may want to generate machine-specific
# settings with: nixos-generate-config --show-hardware-config
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ ];

  # Common kernel modules for physical machines
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "nvme"
    "usbhid"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "kvm-amd"
  ];
  boot.extraModulePackages = [ ];

  # Swap (optional - uncomment and configure if needed)
  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # CPU microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
