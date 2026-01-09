vim.loader.enable()
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" },
        -- { import = "plugins/dap" },
        { import = "plugins/git" },
        { import = "plugins/ui" },
        { import = "plugins/treesitter" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- automatically check for plugin updates
    checker = { enabled = true },
    ui = {
        border = "rounded",
        size = {
            width = 0.8,
            height = 0.8,
        },
    },
})
require("keymap")

local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("autoupdate"),
    callback = function()
        require("lazy").update({
            show = false,
        })
    end,
})

vim.opt["clipboard"] = "unnamedplus"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.guicursor = vim.o.guicursor .. ",c:ver25,t:ver25"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.updatetime = 100
vim.opt.scrolloff = 5
vim.o.number = true
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "ucs-bom", "utf-8", "cp932", "sjis" }
vim.o.shell = "fish"

if false then
    if vim.fn.has("wsl") == 1 then
        if vim.fn.executable("wl-copy") == 0 then
            print("wl-clipboard not found, clipboard integration won't work")
        else
            vim.g.clipboard = {
                name = "wl-clipboard (wsl)",
                copy = {
                    ["+"] = "wl-copy --foreground --type text/plain",
                    ["*"] = "wl-copy --foreground --primary --type text/plain",
                },
                paste = {
                    ["+"] = function()
                        return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { "" }, 1) -- '1' keeps empty lines
                    end,
                    ["*"] = function()
                        return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { "" }, 1)
                    end,
                },
                cache_enabled = true,
            }
        end
    end
end

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
})
vim.cmd([[highlight DiagnosticUnderlineError guisp=#FF0000 gui=undercurl]])
vim.cmd([[highlight DiagnosticUnderlineWarn guisp=#FFA500 gui=undercurl]])
vim.cmd([[highlight DiagnosticUnderlineInfo guisp=#00FFFF gui=underline]])
vim.cmd([[highlight DiagnosticUnderlineHint guisp=#00FF00 gui=underdotted]])

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("ForceTerminalMode", { clear = true }),
    pattern = "term://*",
    command = "startinsert",
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("TerminalMouseDisable", { clear = true }),
    pattern = "term://*",
    callback = function()
        vim.keymap.set("n", "<LeftMouse>", "<LeftMouse>i", { buffer = true })
        vim.keymap.set("n", "<RightMouse>", "<RightMouse>i", { buffer = true })
        vim.keymap.set("n", "<2-LeftMouse>", "i", { buffer = true })
        vim.keymap.set("n", "<3-LeftMouse>", "i", { buffer = true })
        vim.keymap.set("n", "<4-LeftMouse>", "i", { buffer = true })
        vim.keymap.set("v", "<LeftMouse>", "<Esc>i", { buffer = true })
        vim.keymap.set("v", "<2-LeftMouse>", "<Esc>i", { buffer = true })
        vim.keymap.set("x", "<LeftMouse>", "<Esc>i", { buffer = true })
        vim.keymap.set("x", "<2-LeftMouse>", "<Esc>i", { buffer = true })
    end,
})
