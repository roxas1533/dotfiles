{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development Tools
    deno
    gcc
    gnumake
    #    rustup
    glibc.static
    sqlit-tui

    # Version Control & Git Tools
    lazygit
    gh
    delta

    # Search & File Utilities
    ripgrep
    fd
    eza
    yazi
    jq
    chafa
    ouch-rar
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
    nixfmt

    # AI & CLI Tools
    claude-code
    codex

    # Bugzilla
    bugzilla-cli
    rclone

    # Infrastructure & Services
    docker
    cloudflared
    sshpass

    # Fish Shell Plugins
    fishPlugins.z
    fishPlugins.hydro

    # MCP Servers
    mcp-language-server
    github-mcp-server
  ];
}
