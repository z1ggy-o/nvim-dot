-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Install lazy.nvim
-- It just checks if there are lazy.nvim installed in "data"/lazy/lazy.nvim
-- If not, use git to clone it for us
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- Add lazy.nvim to nvim runtime, so we can `require` it.
-- :h runtimepath to learn more
vim.opt.rtp:prepend(lazypath)

-- 24.05.21: move them to `plugin` dir so nvim will load them automatically after load all plugins
-- require("options") -- neovim builtin options
-- require("keybindings") -- neovim builtin keybings
-- require("autocmds")

-- Tells lazy.nvim to load modules from plugins directory
require("lazy").setup({
	{ import = "custom/plugins" },
}, {
	ui = {
		-- If you have a Nerd Font, set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
