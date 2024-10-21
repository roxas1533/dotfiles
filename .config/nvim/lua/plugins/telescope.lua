return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        enabled = not vim.g.vscode,
        --	cmd = "Telescope",
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "" },
            {
                "<C-S-f>",
                '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>',
                desc = "Find file",
            },
            --{ "n", "<leader>fb", builtin.buffers, {} },
            --{ "n", "<leader>fh", builtin.help_tags, {} },
        },
        config = function()
            local telescope = require("telescope")
            local lga_actions = require("telescope-live-grep-args.actions")
            telescope.setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git", "env" },
                    mappings = {
                        i = {
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-p>"] = require("telescope.actions").cycle_history_prev,
                        },
                    },
                },
                extensions = {
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                },
            })
            telescope.load_extension("live_grep_args")
        end,
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        lazy = true,
    },
}
