{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./packages.nix
    ./dotfiles.nix
  ];

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };

  xdg.enable = true;
}
