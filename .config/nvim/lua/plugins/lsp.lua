return {
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            -- { "echasnovski/mini.completion", version = false },
            { "onsails/lspkind-nvim" },
        },
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
        config = function()
            local lspconfig = require("lspconfig")
            local handlers = {
                ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }
            require("mason").setup({})
            --         require("mini.completion").setup({})
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                        handlers = handlers,
                    })
                end,
                ["vtsls"] = function()
                    lspconfig["vtsls"].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    })
                end,
                ["ts_ls"] = function()
                    lspconfig["ts_ls"].setup({
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig["lua_ls"].setup({
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    })
                end,
                ["typos_lsp"] = function()
                    lspconfig["typos_lsp"].setup({
                        cmd_env = { RUST_LOG = "error" },
                        init_options = {
                            diagnosticSeverity = "Error",
                            config = "~/.config/nvim/spell/.typos.toml",
                        },
                    })
                end,
            })
            -- vim.lsp.set_log_level("debug")
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(_)
                    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
                    vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")
                    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
                    vim.keymap.set("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>")
                    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
                    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
                    vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
                    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>")
                    vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
                    vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
                    vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
                    vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
                end,
            })

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = true })
            local cmp = require("cmp")
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    {
                        name = "spell",
                        option = {
                            keep_all_entries = false,
                            enable_in_context = function()
                                return true
                            end,
                            preselect_correct_word = true,
                        },
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-l>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                experimental = {
                    ghost_text = true,
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "symbol_text",
                        preset = "codicons",
                    }),
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
    },
    {
        "f3fora/cmp-spell",
        enabled = not vim.g.vscode,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            vim.opt.spelllang = { "en_us", "cjk" }
        end,
    },
    {
        "hrsh7th/cmp-buffer",
        enabled = not vim.g.vscode,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
    },

    {
        "williamboman/mason.nvim",
        lazy = true,
        enabled = not vim.g.vscode,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        enabled = not vim.g.vscode,
    },
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        event = "VeryLazy",
        enabled = not vim.g.vscode,
        config = function()
            require("trouble").setup({
                modes = {
                    diagnostics = {
                        auto_open = false,
                        auto_close = true,
                    },
                },
                warn_no_results = false,
                -- stylua: ignore
            })
        end,
    },
}
