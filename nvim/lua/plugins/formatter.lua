return {
    {
        "nvimtools/none-ls.nvim",
        enabled = not vim.g.vscode,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            null_ls.setup({
                sources = {
                    null_ls.builtins.diagnostics.djlint,
                    null_ls.builtins.formatting.djlint,
                    null_ls.builtins.formatting.nixfmt,
                    null_ls.builtins.formatting.biome,
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
        vim.api.nvim_create_user_command("ToggleFormat", function()
            vim.g.save_on_format = not vim.g.save_on_format
            print("Save on format: " .. (vim.g.save_on_format and "enabled" or "disabled"))
        end, {}),
    },
}
