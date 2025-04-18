return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        enabled = not vim.g.vscode,
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
        "zbirenbaum/copilot.lua",
        enabled = not vim.g.vscode,
        lazy = false,
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<tab>",
                    },
                },
            })
        end
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
