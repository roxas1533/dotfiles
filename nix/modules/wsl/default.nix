{
  pkgs,
  lib,
  config,
  ...
}:

{
  # WSL-specific packages and configurations
  # Currently minimal, can be expanded with WSL-specific needs

  home.packages = with pkgs; [
    # Add WSL-specific packages here if needed
  ];
}
