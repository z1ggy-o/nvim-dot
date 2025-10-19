return {
	'MeanderingProgrammer/render-markdown.nvim',
	ft = { 'markdown' },
	enabled = true,
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	config = function()
		-- Put config into a different file so we can make the config
		-- work directly without restart nvim
		require("custom.render-markdown")
	end,
}
