return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        enabled = false,
        version = false,
        opts = {
            provider = "copilot",
            copilot = {
                model = "claude-3.7-sonnet",
            },
            auto_suggestions_provider = "copilot",
        },
        build = "make",
    },
    {
        "greggh/claude-code.nvim",
        config = function()
            require("claude-code").setup({
                keymaps = {
                    toggle = {
                        normal = "<leader>ae",
                        terminal = "<leader>ae",
                    },
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        enabled = not vim.g.vscode,
        cmd = { "Copilot" },
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                copilot_model = "gpt-4o-copilot",
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<tab>",
                    },
                },
            })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        enabled = not vim.g.vscode,
        opts = {
            file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
}
