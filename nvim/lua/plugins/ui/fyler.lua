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
                    require("fyler").toggle({ kind = "floating" })
                end,
                desc = "Toggle Fyler (floating)",
            },
        },
        opts = {
            integrations = {
                icon = "mini_icons",
            },
            extensions = {
                git = {
                    enabled = true,
                    inline = false,
                    icons = {
                        ["??"] = { icon = "U", hl = "FylerGitUntracked" },
                        ["A "] = { icon = "A", hl = "FylerGitStaged" },
                        ["AM"] = { icon = "A", hl = "FylerGitStaged" },
                        [" M"] = { icon = "M", hl = "FylerGitModified" },
                        ["M "] = { icon = "M", hl = "FylerGitStaged" },
                        ["MM"] = { icon = "M", hl = "FylerGitStaged" },
                        [" D"] = { icon = "D", hl = "FylerGitDeleted" },
                        ["D "] = { icon = "D", hl = "FylerGitStaged" },
                        ["R "] = { icon = "R", hl = "FylerGitRenamed" },
                        ["C "] = { icon = "C", hl = "FylerGitRenamed" },
                        ["UU"] = { icon = "!", hl = "FylerGitConflict" },
                        ["!!"] = { icon = "#", hl = "FylerGitIgnored" },
                    },
                },
            },
            kind_presets = {
                floating = {
                    height = "90%",
                },
            },
            win_opts = {
                cursorline = true,
            },
            ui = {
                indent_guides = true,
            },
            mappings = {
                n = {
                    ["<Esc>"] = { action = "close" },
                    ["gY"] = {
                        action = function(finder)
                            local entry = require("fyler.finder").parse_cursor_line(finder)
                            if entry then
                                vim.fn.setreg("+", entry.full_path)
                                vim.schedule(function()
                                    vim.notify("Copied: " .. entry.full_path)
                                end)
                            end
                        end,
                    },
                    ["gy"] = {
                        action = function(finder)
                            local entry = require("fyler.finder").parse_cursor_line(finder)
                            if entry then
                                local rel = vim.fn.fnamemodify(entry.full_path, ":.")
                                vim.fn.setreg("+", rel)
                                vim.schedule(function()
                                    vim.notify("Copied: " .. rel)
                                end)
                            end
                        end,
                    },
                    ["uu"] = {
                        action = function(finder)
                            local entry = require("fyler.finder").parse_cursor_line(finder)
                            if entry then
                                vim.cmd("TransferUpload " .. vim.fn.fnameescape(entry.full_path))
                            end
                        end,
                    },
                    ["ud"] = {
                        action = function(finder)
                            local entry = require("fyler.finder").parse_cursor_line(finder)
                            if entry then
                                local dir = entry.type == "directory" and entry.full_path
                                    or vim.fn.fnamemodify(entry.full_path, ":h")
                                vim.cmd("TransferUpload " .. vim.fn.fnameescape(dir))
                            end
                        end,
                    },
                },
            },
        },
    },
}
