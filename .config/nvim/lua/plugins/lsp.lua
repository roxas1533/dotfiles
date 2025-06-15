return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "onsails/lspkind-nvim" },
        },
        event = { "BufReadPre", "BufNewFile" },
        enabled = not vim.g.vscode,
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local handlers = {
                ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }
            local servers = {
                "lua_ls",
                "ruff",
                "basedpyright",
                "biome",
                -- "djlsp",
                "ts_ls",
                "nil_ls",
                "rust_analyzer",
                "typos_lsp"
            }
            local on_attach = function(on_attach)
                local max_filesize = 1024 * 1024
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        local buffer = args.buf
                        local client = vim.lsp.get_client_by_id(args.client_id)
                        if vim.fn.getfsize(vim.api.nvim_buf_get_name(buffer)) > max_filesize then
                            return
                        end
                        if vim.lsp.inlay_hint then
                            vim.lsp.inlay_hint.enable(true, { 0 })
                        end
                        on_attach(client, buffer)
                    end,
                })
            end
            on_attach(function(_, buffer)
                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set("v", "gf", "<cmd>lua vim.lsp.buf.format()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set(
                    "n",
                    "<F12>",
                    "<cmd>lua vim.lsp.buf.definition()<CR>",
                    { silent = true, buffer = buffer }
                )
                vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set(
                    "n",
                    "gi",
                    "<cmd>lua vim.lsp.buf.implementation()<CR>",
                    { silent = true, buffer = buffer }
                )
                vim.keymap.set(
                    "n",
                    "gt",
                    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
                    { silent = true, buffer = buffer }
                )
                vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set(
                    "n",
                    "ge",
                    "<cmd>lua vim.diagnostic.open_float()<CR>",
                    { silent = true, buffer = buffer }
                )
                vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>", { silent = true, buffer = buffer })
                vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { silent = true, buffer = buffer })
            end)
            for _, server in ipairs(servers) do
                local capabilities = cmp_nvim_lsp.default_capabilities()
                capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                }
                capabilities.textDocument.documentColor = nil;
                local default_setup = {
                    capabilities = capabilities,
                    handlers = handlers,
                }
                if server == "lua_ls" then
                    default_setup.settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    }
                elseif server == "ts_ls" then
                    default_setup.on_attach = function(client, _)
                        client.server_capabilities.documentFormattingProvider = false
                    end
                elseif server == "rust_analyzer" then
                    default_setup.settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                        },
                    }
                end
                lspconfig[server].setup(default_setup)
            end

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                    { virtual_text = true, underline = true, signs = true, update_in_insert = true })
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
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                },
                float = {
                    border = "rounded"
                }
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        lazy = true,
    },
    {
        "hrsh7th/cmp-cmdline",
        event = { "CmdlineEnter" },
    },
    {
        "f3fora/cmp-spell",
        enabled = not vim.g.vscode,
        config = function()
            vim.opt.spelllang = { "en_us", "cjk" }
        end,
    },
    {
        "hrsh7th/cmp-buffer",
        enabled = not vim.g.vscode,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = true,
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
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup({
                options = {
                    show_source = true,
                    show_all_diags_on_cursorline = true,
                    multilines = {
                        enabled = true,
                        always_show = true,
                    },
                    -- show_diagnostic_number = true,
                    -- show_diagnostic_count = true,
                    -- show_diagnostic_icon = true,
                    -- show_diagnostic_message = true,
                },
            })
            -- vim.diagnostic.config({ virtual_text = false, options = { show_source = true } })
        end
    },
}
