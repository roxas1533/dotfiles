return {
    {
        "nvimtools/none-ls.nvim",
        enabled = not vim.g.vscode,
        lazy = true,
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                if vim.g.save_on_format then
                                    vim.lsp.buf.format({ async = false })
                                end
                            end,
                        })
                    end
                end,
            })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "InsertEnter" },
        enabled = not vim.g.vscode,
        opts = {
            handlers = {},
        },
    },
    {
        "williamboman/mason.nvim",
        lazy = true,
    },
    {
        vim.api.nvim_create_user_command("ToggleFormat", function()
            vim.g.save_on_format = not vim.g.save_on_format
            print("Save on format: " .. (vim.g.save_on_format and "enabled" or "disabled"))
        end, {}),
    },
}
