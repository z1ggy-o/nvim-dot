-- nvim builtin options
vim.g.mapleader = " "


-- Install lazy.nvim
-- It just checks if there are lazy.nvim installed in "data"/lazy/lazy.nvim
-- If not, use git to clone it for us
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)  -- Add lazy.nvim to nvim runtime

-- Install packages
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.5', -- or , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
}

local opts = { }

require("lazy").setup(plugins, opts) -- lazy.nvim install packages

-- Setup colorscheme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Setup fuzzy finder telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
