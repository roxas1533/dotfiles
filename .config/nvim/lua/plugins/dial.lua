return {
    "monaqa/dial.nvim",
    keys = {
        { "<C-a>",  mode = "n" },
        { "<C-x>",  mode = "n" },
        { "g<C-a>", mode = "n" },
        { "g<C-x>", mode = "n" },
        { "<C-a>",  mode = "v" },
        { "<C-x>",  mode = "v" },
        { "g<C-a>", mode = "v" },
        { "g<C-x>", mode = "v" },
    },
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group({
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.date.alias["%Y/%m/%d"],
                augend.constant.alias.bool,
                augend.constant.new {
                    elements = { "True", "False" },
                    word = true,
                    cyclic = true,
                }

            },
        })
        vim.keymap.set("n", "<C-a>", function()
            require("dial.map").manipulate("increment", "normal")
        end)
        vim.keymap.set("n", "<C-x>", function()
            require("dial.map").manipulate("decrement", "normal")
        end)
        vim.keymap.set("n", "g<C-a>", function()
            require("dial.map").manipulate("increment", "gnormal")
        end)
        vim.keymap.set("n", "g<C-x>", function()
            require("dial.map").manipulate("decrement", "gnormal")
        end)
        vim.keymap.set("v", "<C-a>", function()
            require("dial.map").manipulate("increment", "visual")
        end)
        vim.keymap.set("v", "<C-x>", function()
            require("dial.map").manipulate("decrement", "visual")
        end)
        vim.keymap.set("v", "g<C-a>", function()
            require("dial.map").manipulate("increment", "gvisual")
        end)
        vim.keymap.set("v", "g<C-x>", function()
            require("dial.map").manipulate("decrement", "gvisual")
        end)
    end,
}
