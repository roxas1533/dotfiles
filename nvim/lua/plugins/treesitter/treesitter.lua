return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = true,
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                sync_install = false,
                highlight = {
                    enable = true,
                    -- disable = function(_, buf)
                    --     local max_filesize = 1024 * 1024
                    --     local max_lines = 300
                    --
                    --     local ok, status = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    --     if ok and status ~= nil then
                    --         if status.size < max_filesize then
                    --             return true
                    --         end
                    --     end
                    --     return false
                    -- end,
                },
                ensure_installed = {
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
                },
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
                insert_mode = true,
            })
        end,
    },
}
