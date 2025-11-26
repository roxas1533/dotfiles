return {
    {
        "folke/snacks.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        opts = {
            bigfile = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            picker = {
                enable = true,
                layout = {
                    preset = "telescope",
                },
                sources = {
                    files = { hidden = false },
                    recent = {
                        filter = {
                            cwd = true,
                        },
                    },
                },
            },
            dashboard = {
                enable = true,
            },
        },
        keys = {
            {
                "<C-p>",
                function()
                    require("snacks.picker").smart()
                end,
                desc = "Find file",
            },
            {
                "<C-S-f>",
                function()
                    require("snacks.picker").grep()
                end,
                desc = "Live grep",
            },
        },
    },
}
