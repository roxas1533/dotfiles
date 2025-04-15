vim.opt.number = true

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>p", '"_viwP', { noremap = true })
vim.api.nvim_set_keymap("n", '<leader>"', '"_vi"P', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader><space>", '"_', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>dd", '"_dd', { noremap = true })
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })

vim.keymap.set({ "n", "v" }, "<s-tab>", "5k", { noremap = true })

vim.keymap.set({ "i" }, "<c-v>", "<c-r>+", { noremap = true })
vim.keymap.set({ "n", "v" }, "<tab>", "5j", { noremap = true })

vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { noremap = true })
vim.keymap.set({ "c" }, "<C-v>", "<C-r><C-o>+", { noremap = true })

vim.keymap.set({ "v" }, ">", ">gv", { noremap = true })
vim.keymap.set({ "v" }, "<", "<gv", { noremap = true })

vim.keymap.set({ "i" }, "<C-g><C-u>", "<esc>gUiwgi", { noremap = true })

vim.keymap.set({ "n" }, "i", function()
    if vim.fn.empty(vim.fn.getline(".")) == 1 then
        return '"_cc'
    else
        return "i"
    end
end, { expr = true, noremap = true })

-- vim.keymap.set({ "n" }, "/", "/\\V", { noremap = true })
vim.keymap.set({ "n" }, "p", "]p", { noremap = true })
vim.keymap.set({ "n" }, "P", "]P", { noremap = true })

for _, quote in ipairs({ '"', "'", "`" }) do
    vim.keymap.set({ "x", "o" }, "a" .. quote, "2i" .. quote)
end

-- Quickfix
vim.keymap.set({ "n" }, "[", "<cmd>cn<CR>", { noremap = true })
vim.keymap.set({ "n" }, "<C-[>", "<cmd>cp<CR>", { noremap = true })
local function toggle_quickfix()
    local is_open = false
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            is_open = true
            break
        end
    end

    if is_open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end

vim.keymap.set("n", "<leader>q", toggle_quickfix, { noremap = true, silent = true })
