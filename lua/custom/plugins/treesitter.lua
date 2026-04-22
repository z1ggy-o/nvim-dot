local parser_languages = {
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

local function enable_native_treesitter(buf)
	if not vim.treesitter or not vim.treesitter.start then
		return
	end

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
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		enabled = true,
		config = function()
			-- In diff mode we prefer builtin textobjects for c/C motions.
			local move = require("nvim-treesitter.textobjects.move")
			local configs = require("nvim-treesitter.configs")

			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name]
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		init = function()
			local group = vim.api.nvim_create_augroup("custom_treesitter_native", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"markdown",
					"python",
					"query",
					"toml",
					"vim",
					"yaml",
				},
				callback = function(args)
					enable_native_treesitter(args.buf)
				end,
				desc = "Enable native treesitter highlighting and folding",
			})
		end,
		opts = {
			ensure_installed = parser_languages,
			sync_install = false,
			auto_install = true,

			-- Neovim 0.12 can do highlighting natively via vim.treesitter.start().
			-- Keep plugin highlight disabled to avoid duplicate captures on newer setups.
			highlight = { enable = false },

			-- The indent module is still plugin-provided and remains experimental.
			indent = { enable = false },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			-- Make common filetypes explicit so parser names stay visible in config.
			if vim.treesitter and vim.treesitter.language and vim.treesitter.language.register then
				vim.treesitter.language.register("bash", { "sh", "zsh" })
				vim.treesitter.language.register("markdown", { "mdx" })
			end
		end,
	},
}
