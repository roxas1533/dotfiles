return {
    {
        "Aasim-A/scrollEOF.nvim",
        enabled = not vim.g.vscode,
        event = { "CursorMoved", "WinScrolled" },
        opts = {},
    },
}
