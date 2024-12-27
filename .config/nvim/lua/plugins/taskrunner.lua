return {
    "stevearc/overseer.nvim",
    enabled = not vim.g.vscode,
    keys = {
        { "<F7>", "<cmd>OverseerRun<cr>" },
        { "<F8>", "<cmd>OverseerToggle<cr>" },
    },
    opts ={
            templates = { "builtin", "user.cp" },
            form = {
                -- border = "rounded",
                -- zindex = 40,
                -- min_width = 80,
                -- max_width = 0.9,
                -- width = nil,
                -- min_height = 10,
                -- max_height = 0.9,
                -- height = nil,
                win_opts = {
                    winblend = 0,
                },
            },
            task_launcher = {
                -- Set keymap to false to remove default behavior
                -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
                bindings = {
                    i = {
                        ["<C-s>"] = "Submit",
                        ["<C-c>"] = "Cancel",
                    },
                    n = {
                        ["<CR>"] = "Submit",
                        ["<C-s>"] = "Submit",
                        ["q"] = "Cancel",
                        ["?"] = "ShowHelp",
                    },
                },
            },
            task_win = {
                padding = 2,
                border = "rounded",
                win_opts = {
                    winblend = 0,
                },
            },
        },
}
