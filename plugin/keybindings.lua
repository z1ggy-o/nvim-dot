-- vim.api.nvim_set_keymap(): set global keymap
-- vim.api.nvim_buf_set_keymap(): set buffer local keymap
-- also have `get`, `set`
-- After 0.7 version, we can use `vim.keymap.set()`

-- nvim uses `vim.api.nvim_set_keymap()` to bind keys.
-- To reduce the typing, we create a shortcut for it
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	if opts.remap and not vim.g.vscode then
		opts.remap = nil
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local function unmap(mode, lhs, opts)
	vim.keymap.del(mode, lhs, opts)
end

local opt = { noremap = true, silent = true }

-- Now, we can use `map(mode, key, target, option)` to bind keys
-- e.g., vim.keymap.set({'n', 'c'}, '<Leader>ex2', '<Cmd>lua vim.notify("Example 2")<CR>')
-- 其实还有第四个可选参数，比如可以加一个描述：{desc = "xxx"}

-- execute current lua line
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("n", "<space>x", ":lua<CR>")

-- quickfix list move prev next
vim.keymap.set("n", "M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "M-k>", "<cmd>cprev<CR>")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

map("n", "<leader>`", "<C-^>", { desc = "Switch to previous buffer" })
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "[Q]uit all" })

-- press jk and kj as esc
map("i", "jk", "<ESC>", opt)
map("i", "kj", "<ESC>", opt)

-- readlines-like movement
map("i", "<C-a>", "<Home>", { noremap = true })
map("i", "<C-e>", "<End>", { noremap = true })
map("i", "<C-b>", "<Left>", { noremap = true })
map("i", "<C-f>", "<Right>", { noremap = true })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Use <> to continuously change indentions
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv", opt)
map("x", "K", ":move '<-2<CR>gv-gv", opt)

-- Files related
map("n", "<leader>fs", ":w<CR>", opt)
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Window related --
-- Window splits
map("n", "<leader>ws", ":sp<CR>", opt)
map("n", "<leader>wv", ":vsp<CR>", opt)

map("n", "<leader>wd", "<C-w>c", opt) -- close current window
map("n", "<leader>wo", "<C-w>o", opt) -- close other windows

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })

-- Window resize with arrow keys
map("n", "<C-S-Up>", ":resize +2<CR>", opt)
map("n", "<C-S-Down>", ":resize -2<CR>", opt)
map("n", "<C-S-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-S-Right>", ":vertical resize +2<CR>", opt)

-- Buffers --
map("n", "<S-h>", ":bprevious<CR>", opt)
map("n", "<S-l>", ":bnext<CR>", opt)
-- map("n", "<leader>bd", ":bdelete<CR>", { desc = "[B]uffer [D]elete" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show [D]iagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal --
