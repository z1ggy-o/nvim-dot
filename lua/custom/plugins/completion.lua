-- Welcome new king, blink.nvim
return {
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		build = 'cargo build --release', -- build lib from the source instead of download
		dependencies = {
			'rafamadriz/friendly-snippets',

			{ 'saghen/blink.compat', opts = { enable_events = true } }, -- add self-defined sources
			-- AI Autocomplete
			-- {
			-- 	-- use `export no_proxy=127.0.0.1` to disable proxy for localhost when we use proxy.
			-- 	-- otherwise, codeium cannot connect to the server properly
			-- 	-- cr: https://github.com/Exafunction/codeium.nvim/issues/164
			-- 	"Exafunction/codeium.nvim",
			-- 	opts = {
			-- 		enable_chat = false, -- chat can only through the browser in neovim, so useless
			-- 	},
			-- },
		},

		-- use a release tag to download pre-built binaries
		version = '*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = 'default',
				['<C-n>'] = { 'show', 'select_next', 'fallback' }, -- default 'show' is C-space, but it is used by macOS
				['<C-j>'] = { 'snippet_forward', 'fallback' }, -- do not use Tab
				['<C-k>'] = { 'snippet_backward', 'fallback' }, -- do not use Tab
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			completion = {
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 3 },
							{ "kind_icon", "kind" }
						},
						treesitter = { "lsp" },
					},
				},

				-- Show documentation when selecting a completion item
				documentation = { auto_show = true, auto_show_delay_ms = 800 },

				-- Display a preview of the selected item on the current line
				ghost_text = { enabled = true },
			},

			signature = { enabled = true},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
				-- default = { 'lsp', 'path', 'snippets', 'codeium', 'buffer' },
				providers = {
					codeium = {
						enabled = false,
						name = 'codeium',
						module = 'blink.compat.source',
						score_offset = 3,
						async = true,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	}
}

--[[
-- old nvim-cmp configs, leave them for reference
return { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",

		-- If you want to add a bunch of pre-configured snippets,
		--    you can use this plugin to help you. It even has snippets
		--    for various frameworks/libraries/etc. but you will have to
		--    set up the ones that are useful for you.
		-- 'rafamadriz/friendly-snippets',

		-- Add vscode like pictogram to completion entries. (UI)
		"onsails/lspkind.nvim",

		-- AI Autocomplete
		{
			-- use `export no_proxy=127.0.0.1` to disable proxy for localhost when we use proxy.
			-- otherwise, codeium cannot connect to the server properly
			-- cr: https://github.com/Exafunction/codeium.nvim/issues/164
			"Exafunction/codeium.nvim",
			opts = {
				-- enable_chat = true, -- chat can only through the browser in neovim, so useless
			},
		},
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				{
					-- Predefined snippets
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			build = (function()
				-- Build Step is needed for regex support in snippets
				-- This step is not supported in many windows environments
				-- Remove the below condition to re-enable on windows
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
		},
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		-- require "custom.snippet" -- load personal snippets, do not have any yet.

		local lspkind = require("lspkind")
		lspkind.init({})

		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({
			history = false,
			updateevents = "TextChanged, TextChangedI",
		})

		cmp.setup({
			-- TODO: what is the following line means? read :h complete option
			completion = { completeopt = "menu,menuone,noinsert" },

			experimental = { ghost_text = true },

			sources = {
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "codeium" },
				{ name = "buffer" },
				-- { name = "luasnip" }, -- TJ does not have this, maybe cus we already have the snippet section
			},
			-- Enable luasnip to handle snippet expansion for nvim-cmp
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- For an understanding of why these mappings were
			-- chosen, you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			mapping = cmp.mapping.preset.insert({
				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.comple
				--  This will expand snippets if the LSP sent a snippet.
				-- ["<C-y>"] = cmp.mapping.confirm({ select = true }),
				-- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-y>"] = cmp.mapping(
					cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					{ "i", "c" }
				),

				-- Select the [n]ext item
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Inser }),
				-- Select the [p]revious item

				-- Scroll doc buffer
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don't need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-.>"] = cmp.mapping.complete({}),

				-- 'end' for abort
				["<C-e>"] = cmp.mapping.abort(),

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
			}),
		})
	end,
}
--]]
