return {
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {},
        init = function()
            -- nvim-web-devicons 互換
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    {
        "A7Lavinraj/fyler.nvim",
        enabled = not vim.g.vscode,
        dependencies = { "echasnovski/mini.icons" },
        branch = "main",
        lazy = false,
        keys = {
            {
                "<C-n>",
                function()
                    require("fyler").toggle({ kind = "float" })
                end,
                desc = "Toggle Fyler (float)",
            },
        },
        opts = {
            views = {
                finder = {
                    columns = {
                        git = {
                            enabled = true,
                            symbols = {
                                Untracked = "U",
                                Added = "A",
                                Modified = "M",
                                Deleted = "D",
                                Renamed = "R",
                                Copied = "C",
                                Conflict = "!",
                                Ignored = "#",
                            },
                        },
                        diagnostic = {
                            enabled = true,
                            symbols = {
                                Error = "",
                                Warn = "",
                                Info = "",
                                Hint = "󰌵",
                            },
                        },
                    },
                    win = {
                        kinds = {
                            float = {
                                height = "90%",
                            },
                        },
                        win_opts = {
                            cursorline = true,
                        },
                    },
                    mappings = {
                        ["<Esc>"] = "CloseView",
                        ["gY"] = function(finder)
                            local entry = finder:cursor_node_entry()
                            if entry then
                                vim.fn.setreg("+", entry.path)
                                vim.notify("Copied: " .. entry.path)
                            end
                        end,
                        ["gy"] = function(finder)
                            local entry = finder:cursor_node_entry()
                            if entry then
                                local rel = vim.fn.fnamemodify(entry.path, ":.")
                                vim.fn.setreg("+", rel)
                                vim.notify("Copied: " .. rel)
                            end
                        end,
                        ["uu"] = function(finder)
                            local entry = finder:cursor_node_entry()
                            if entry then
                                vim.cmd("TransferUpload " .. entry.path)
                            end
                        end,
                        ["ud"] = function(finder)
                            local entry = finder:cursor_node_entry()
                            if entry then
                                local dir = entry.type == "directory" and entry.path
                                    or vim.fn.fnamemodify(entry.path, ":h")
                                vim.cmd("TransferUpload " .. dir)
                            end
                        end,
                    },
                },
            },
        },
    },
}
