return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		-- Setup Neotree
		vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem reveal left<cr>", { silent = true })
		-- Quit Neotree
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "neo-tree",
			callback = function()
				vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true, silent = true }) -- 0: means current buffer, n: means in normal mode
				-- vim.api.nvim_buf_set_keymap(0, "n", "<leader>e", ":q<CR>", { noremap = true, silent = true }) -- 0: means current buffer, n: means in normal mode
			end,
		})
	end,
}
