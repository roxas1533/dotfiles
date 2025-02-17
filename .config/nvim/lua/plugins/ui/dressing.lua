return {
    {
        "folke/snacks.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        opts = {
            indent = {
                enable = true,
            },
            picker = {
                enable = true,
                layout = {
                    preset = "telescope",
                }
            },
        },
        keys = {
            { "<C-p>", function() require("snacks.picker").smart() end, desc = "Find file" },
            { "<C-S-f>", function() require("snacks.picker").grep() end, desc = "Find file" }
        }
    }
}
