return {
	"akinsho/toggleterm.nvim",
	version = "*",
	enable = not vim.g.vscode,
	event = "VeryLazy",
	config = function()
		local toggleterm = require("toggleterm")
		vim.o.shell = "/usr/bin/fish"
		toggleterm.setup({
			size = 20,
			open_mapping = [[<C-t>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
	end,
}
