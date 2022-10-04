-- From https://github.com/LunarVim/Neovim-from-scratch/blob/03-plugins/lua/user/plugins.lua

local fn = vim.fn

-- Automatically install packer

-- this `data` path is `~/.local/share/nvim` in unix systems.
-- `site` is where our plugins are.
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packages.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use.
-- Have the same effective as: local packer = require("packer"), however, we
-- can know if it okay.
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("Cannot find Packer!")
  return
end
-- after this, we can make sure Packer is loaded.

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return require('packer').startup(function(use)
  -- Normal load examples
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API for vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use "windwp/nvim-autopairs" -- autopairs, integrates with cmp and treesitter
  use "numtoStr/Comment.nvim" -- Easily comment
  use "JoosepAlviste/nvim-ts-context-commentstring" -- integrates with treesitter to better comment
  use "kylechui/nvim-surround" -- a better surround, can integrates with treesitter

  -- Lazy load examples (can load on commands, event, or a combination of conditions, e.g., file type)
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- gruvbox theme
  use {
      "ellisonleao/gruvbox.nvim",
      requires = {"rktjmp/lush.nvim"}
  }
  -- zephyr theme
  use 'glepnir/zephyr-nvim'
  -- a set of themes from lunarvim
  use "lunarvim/colorschemes"

  -- Readline keybindings in insert mode and commandline (not all)
  use 'tpope/vim-rsi'

  -- nvim-tree, vscode like directory explorer
  use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }

  -- bufferline. Show buffers at the top
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use "moll/vim-bbye"

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use "p00f/nvim-ts-rainbow" -- rainbow parenthsis (settings in treesitter.lua)

  -- completion plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp" -- add LSP as source of nvim-cmp
  use "hrsh7th/cmp-nvim-lua" -- completion support for Lua

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "jose-elias-alvarez/null-ls.nvim" -- formatter and linter

  -- Telescope: the fuzzy finder
  use "nvim-telescope/telescope.nvim"

  -- Git: show modifications and other git integrations
  use "lewis6991/gitsigns.nvim"

-- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
