return {
    "uga-rosa/ccc.nvim",
    enabled = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local ccc = require("ccc")
        ccc.setup({
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
            pickers = {
                ccc.picker.trailing_whitespace({
                    palette = {},
                    default_color = "#db7093",
                    enable = true,
                    disable = function(bufnr)
                        return not vim.bo[bufnr].buftype == "" or
                            not vim.bo[bufnr].modifiable
                    end
                }),
            },
        });
    end,
}
