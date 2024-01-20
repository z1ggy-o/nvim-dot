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

require("options") -- neovim builtin options

-- Tells lazy.nvim to load modules form plugins directory
require("lazy").setup("plugins") -- lazy.nvim install packages

