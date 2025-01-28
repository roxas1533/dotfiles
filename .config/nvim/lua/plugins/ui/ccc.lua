return {
    "uga-rosa/ccc.nvim",
    enabled = not vim.g.vscode,
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        require("ccc").setup({
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        });
    end,
}
