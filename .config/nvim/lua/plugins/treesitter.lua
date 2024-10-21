return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "elixir",
                    "heex",
                    "javascript",
                    "html",
                    "python",
                    "json",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "tzachar/local-highlight.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        config = function()
            require("local-highlight").setup({
                file_types = { "lua" },
                insert_mode = true,
            })
        end,
    },
}
