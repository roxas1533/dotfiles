return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({})

            local parsers = {
                "bash",
                "c",
                "cpp",
                "css",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "rust",
                "typescript",
            }

            -- Install parsers asynchronously
            require("nvim-treesitter").install(parsers)

            -- Enable treesitter highlighting and indentation
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
    {
        "tzachar/local-highlight.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        config = function()
            require("local-highlight").setup({
                insert_mode = true,
            })
        end,
    },
}
