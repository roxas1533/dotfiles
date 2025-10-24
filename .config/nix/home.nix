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
    gnumake
    yazi
    docker
    lazygit
    gh
    sshpass
    claude-code
    gemini-cli
    cloudflared

    # unar

    # lsp
    lua-language-server
    typescript-language-server
    biome
    typos-lsp

    # nix関連
    nil
    nixfmt-rfc-style

    # fishPlugins
    fishPlugins.z
    fishPlugins.tide

    # gh extensions
    gh-copilot

    # git
    delta

    rustup
    glibc.static

    #mcp server
    (callPackage ./packages/mcp-server-mysql.nix { })
    github-mcp-server
  ];
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
  home.stateVersion = "25.05";
}
