-- nvim builtin options
vim.g.mapleader = " "

local opt = vim.opt

opt.list = true -- Show invisible chars
-- vim.o.listchars = "tab:⊢·,trail:␠,nbsp:⎵" -- same effect with the following line
opt.listchars = { tab = "⊢·", trail = "␠", nbsp = "⎵" }

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false -- Use tab by default, the Linux style (this is not work, I don't know why. maybe overwritten by the default c ftplugin?)

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

local function unmap(mode, lhs, opts)
  vim.keymap.del(mode, lhs, opts)
end

map("i", "jk", "<ESC>") -- out of insert mode without esc or C-[

-- Files related
map("n", "<leader>fs", ":w<CR>")

-- Movements
-- readlines-like movement
map("i", "<C-a>", "<Home>", { noremap = true })
map("i", "<C-e>", "<End>", { noremap = true })
map("i", "<C-b>", "<Left>", { noremap = true })
map("i", "<C-f>", "<Right>", { noremap = true })

-- Windows
--  splits
map("n", "<leader>wv", "<C-w>v")
map("n", "<leader>ws", "<C-w>s")
