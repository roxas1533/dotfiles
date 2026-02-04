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
    bash = {
      enable = true;
      initExtra = ''
        # Launch fish as default shell (if interactive, TTY attached, and fish available)
        if [[ $- == *i* ]] && [[ -t 0 ]] && command -v fish &> /dev/null; then
          exec fish
        fi
      '';
    };
  };

  xdg.enable = true;
}
