return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	enable = not vim.g.vscode,
	lazy = false,
	keys = {
		{ "<C-k>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
		{ "<C-j>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
	},
	opts = {
		options = {
			--show_buffer_close_icons = false,
			--show_close_icon = false,
		},
	},
}
