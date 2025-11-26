return {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = not vim.g.vscode,
    event = { "BufRead", "BufNewFile" },
    config = true,
}
