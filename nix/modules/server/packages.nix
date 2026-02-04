{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Shell
    fish
    fishPlugins.z
    fishPlugins.hydro

    # Editor
    neovim

    # Terminal Multiplexer
    zellij

    # Log Viewer
    lnav

    # Version Control & Git Tools
    git
    lazygit
    gh
    delta

    # Search & File Utilities
    ripgrep
    fd
    eza
    jq

    # Languages & Runtimes
    lua
    tree-sitter

    # LSP & Language Servers (for Neovim)
    lua-language-server
    nil # Nix LSP
    nixfmt-rfc-style

    # Infrastructure & Services
    docker
  ];
}
