return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({})
            require("nvim-treesitter").install({
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
            }, {})
            -- Enable treesitter highlighting and indentation
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
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
