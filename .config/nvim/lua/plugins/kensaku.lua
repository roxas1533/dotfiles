return {
    {
        "lambdalisue/vim-kensaku-search",
        enabled = not vim.g.vscode,
        dependencies = { "lambdalisue/kensaku.vim", "vim-denops/denops.vim" },
        -- enabled = false,
        event = { "CmdlineEnter" },
        config = function()
            vim.keymap.set({ "c" }, "<CR>", "<Plug>(kensaku-search-replace)<CR>", { noremap = true, silent = true })
        end,
    },
}
