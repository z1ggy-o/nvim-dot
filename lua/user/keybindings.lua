-- vim.api.nvim_set_keymap(): set global keymap
-- vim.api.nvim_buf_set_keymap(): set buffer local keymap
-- also have `get`, `set`
-- After 0.7 version, we can use `vim.keymap.set()`

-- nvim uses `vim.api.nvim_set_keymap()` to bind keys.
-- To reduce the typing, we create a shortcut for it
local map = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true}
-- Now, we can use `map(mode, key, target, option)` to bind keys
-- e.g., vim.keymap.set({'n', 'c'}, '<Leader>ex2', '<Cmd>lua vim.notify("Example 2")<CR>')
-- 其实还有第四个可选参数，比如可以加一个描述：{desc = "xxx"}

-- Remap space as the leader key
map("", "<Space>", "<Nop>", opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

--
-- Visual Mode
--

-- Use <> to continuously change indentions
map('v', '<', '<gv', opt)
map('v', '>', '>gv', opt)

-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", opt)
map("x", "K", ":move '<-2<CR>gv-gv", opt)

--
-- Normal Mode
--

map("n", "<leader>fw", ":w<CR>", opt)

-- Window related
-- Window splits
map("n", "<leader>ws", ":sp<CR>", opt)
map("n", "<leader>wv", ":vsp<CR>", opt)

map("n", "<leader>wd", "<C-w>c", opt) -- close current window
map("n", "<leader>wo", "<C-w>o", opt) -- close other windows

-- Window navigation
map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-l>", "<C-w>l", opt)

-- Window resize with arrow keys
map("n", "<C-S-Up>", ":resize +2<CR>", opt)
map("n", "<C-S-Down>", ":resize -2<CR>", opt)
map("n", "<C-S-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-S-Right>", ":vertical resize +2<CR>", opt)


-- buffers
map("n", "<S-h>", ":bprevious<CR>", opt)
map("n", "<S-l>", ":bnext<CR>", opt)

map("n", "<leader>e", ':NvimTreeToggle<CR>', opt)

-- Insert Mode --
-- press jk and kj as esc
map("i", "jk", "<ESC>", opt)
map("i", "kj", "<ESC>", opt)

-- Telescope --
--[[ map("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_ivy({ previewer = false }))<cr>", opt) ]]
map("n", "<leader>ff", ":Telescope find_files theme=ivy<CR>", opt)
map("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opt)
