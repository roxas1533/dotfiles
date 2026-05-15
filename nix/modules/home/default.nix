{
  inputs,
  ...
}:

{
  imports = [
    ./packages.nix
    ./dotfiles.nix
    inputs.nix-index-database.homeModules.nix-index
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

    nix-index-database.comma.enable = true;
  };

  # XDG directories
  xdg.enable = true;
}
