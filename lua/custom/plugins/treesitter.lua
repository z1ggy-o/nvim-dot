local core_parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"toml",
	"vim",
	"vimdoc",
	"yaml",
}

-- Group same type of textobject queries together
local textobject_queries = {
	next_start = {
		["]f"] = "@function.outer",
		["]c"] = "@class.outer",
		["]a"] = "@parameter.inner",
	},
	next_end = {
		["]F"] = "@function.outer",
		["]C"] = "@class.outer",
		["]A"] = "@parameter.inner",
	},
	prev_start = {
		["[f"] = "@function.outer",
		["[c"] = "@class.outer",
		["[a"] = "@parameter.inner",
	},
	prev_end = {
		["[F"] = "@function.outer",
		["[C"] = "@class.outer",
		["[A"] = "@parameter.inner",
	},
}

local function set_textobject_move_keymaps()
	local move = require("nvim-treesitter-textobjects.move")

	local function map_query_keys(mode, query_map, mover)
		for key, query in pairs(query_map) do
			vim.keymap.set(mode, key, function()
				if vim.wo.diff and key:find("[cC]") then
					vim.cmd("normal! " .. key)
					return
				end

				mover(query, "textobjects")
			end, { silent = true, desc = "Treesitter " .. key })
		end
	end

	map_query_keys({ "n", "x", "o" }, textobject_queries.next_start, move.goto_next_start)
	map_query_keys({ "n", "x", "o" }, textobject_queries.next_end, move.goto_next_end)
	map_query_keys({ "n", "x", "o" }, textobject_queries.prev_start, move.goto_previous_start)
	map_query_keys({ "n", "x", "o" }, textobject_queries.prev_end, move.goto_previous_end)
end

local function enable_native_treesitter(buf)
	if not vim.treesitter or not vim.treesitter.start then
		return
	end

	-- Try to enable native treesitter highlight for this buffer.
	local ok = pcall(vim.treesitter.start, buf)
	if not ok then
		return
	end

	if vim.treesitter.foldexpr and vim.bo[buf].buftype == "" then
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end
end

return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			enable = true,
			max_lines = 0,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		enabled = true,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				move = {
					set_jumps = true,
				},
			})

			set_textobject_move_keymaps()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		init = function()
			local group = vim.api.nvim_create_augroup("custom_treesitter_native", { clear = true })

			-- After nvim 0.12, highlight and fold are provided by nvim itself.
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = function(args)
					enable_native_treesitter(args.buf)
				end,
				desc = "Enable native treesitter highlighting and folding",
			})
		end,
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			ts.install(core_parsers)

			-- Register parsers when filetype names differ from parser names.
			if vim.treesitter and vim.treesitter.language and vim.treesitter.language.register then
					vim.treesitter.language.register("bash", { "sh", "zsh" })
					vim.treesitter.language.register("markdown", { "mdx" })
			end
		end,
	},
}
