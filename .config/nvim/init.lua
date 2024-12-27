-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
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
        { import = "plugins/git" },
        { import = "plugins/ui" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "everforest" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
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

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter" }, {
    pattern = "*",
    group = augroup("zenhan"),
    callback = function()
        vim.fn.jobstart({ "/mnt/c/desktop/tools/bin/zenhan.exe", "0" })
    end,
})

vim.opt["clipboard"] = "unnamedplus"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.shell = "/usr/bin/fish"
vim.o.cursorline = true
vim.o.updatetime = 100
vim.opt.scrolloff = 5

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

if not vim.g.vscode then
    vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red" })
    vim.cmd([[match ExtraWhitespace /\s\+$/]])

    vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
        pattern = "*",
        callback = function()
            local exclude = { "terminal", "prompt" }
            if vim.tbl_contains(exclude, vim.bo.filetype) then
                return
            end
            vim.cmd("match ExtraWhitespace /\\s\\+$/")
        end,
    })
    vim.api.nvim_create_autocmd("BufWinLeave", {
        pattern = "*",
        command = "call clearmatches()",
    })
end
