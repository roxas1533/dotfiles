{ pkgs, ... }:

{
  home.username = "ro";
  home.homeDirectory = "/home/ro";

  home.packages = with pkgs; [
    deno
    ripgrep
    lua
    luarocks
    gcc
    yazi
    docker

    # lsp
    lua-language-server
    typescript-language-server
    biome
    rust-analyzer
    clippy

    # nix関連
    nil
    nixfmt-rfc-style

    # fishPlugins
    fishPlugins.z
    fishPlugins.tide

    glibc.static
  ];
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
  home.stateVersion = "24.11";
}
