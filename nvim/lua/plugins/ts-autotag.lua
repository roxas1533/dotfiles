return {
    "windwp/nvim-ts-autotag",
    enabled = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    config = true,
}
