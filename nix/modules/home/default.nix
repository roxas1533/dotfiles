{
  ...
}:

{
  imports = [
    ./packages.nix
    ./dotfiles.nix
  ];

  home = {
    username = "ro";
    homeDirectory = "/home/ro";
    stateVersion = "25.05";
  };

  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # XDG directories
  xdg.enable = true;
}
