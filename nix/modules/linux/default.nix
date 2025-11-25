{
  pkgs,
  lib,
  config,
  ...
}:

{
  # Linux-specific packages and configurations
  # For standalone home-manager on non-NixOS Linux distributions

  home.packages = with pkgs; [
    # Add Linux-specific packages here if needed
  ];
}
