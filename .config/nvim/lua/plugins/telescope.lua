return {
    {
        "nvim-telescope/telescope.nvim",
        enabled = not vim.g.vscode,
        keys = {
            -- { "<C-p>", function() require("telescope.builtin").find_files() end, desc = "" },
            -- {
            --     "<C-p>",
            --     function()
            --         require("telescope").extensions.smart_open.smart_open {
            --             filename_first = false,
            --         }
            --     end,
            --     desc = ""
            -- },
            -- {
            --     "<C-S-f>",
            --     '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>',
            --     desc = "Find file",
            -- },
            {
                "<leader>h",
                function()
                    require("telescope.builtin").command_history(
                        {
                            filter_fn = function(entry)
                                return #entry > 3
                            end
                        }
                    )
                end,
                desc = ""
            },
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
            telescope.load_extension("fzy_native")
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
    {
        "nvim-telescope/telescope-fzy-native.nvim",
        lazy = true,
    },
    {
        "danielfalk/smart-open.nvim",
        enabled = false,
        config = function()
            require("telescope").load_extension("smart_open")
        end
    },
    {
        "kkharji/sqlite.lua",
        lazy = true,
    }
}
