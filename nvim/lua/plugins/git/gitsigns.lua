return {
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.vscode,
    event = { "BufRead", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signcolumn = true,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 100,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
        })
        require("scrollbar.handlers.gitsigns").setup({})
    end,
}
