return {
    "kana/vim-smartword",
    config = function()
        vim.api.nvim_set_keymap("n", "w", "<Plug>(smartword-w)", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "b", "<Plug>(smartword-b)", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "e", "<Plug>(smartword-e)", { noremap = true, silent = true })
    end,
}
