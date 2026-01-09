{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development Tools
    deno
    gcc
    gnumake
    rustup
    glibc.static

    # Version Control & Git Tools
    lazygit
    gh
    delta

    # Search & File Utilities
    ripgrep
    eza
    yazi
    jq
    python313Packages.markitdown

    # Languages & Runtimes
    lua
    luarocks
    tree-sitter

    # LSP & Language Servers
    lua-language-server
    typescript-language-server
    biome
    typos-lsp
    nil # Nix LSP
    nixfmt-rfc-style

    # AI & CLI Tools
    claude-code
    gemini-cli

    # Infrastructure & Services
    docker
    cloudflared
    sshpass

    # Fish Shell Plugins
    fishPlugins.z
    fishPlugins.hydro

    # MCP Servers
    mcp-server-mysql
    mcp-language-server
    github-mcp-server
  ];
}
