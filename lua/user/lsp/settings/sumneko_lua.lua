return {
  settings = {

    Lua = {
			diagnostics = {
				globals = { "vim" }, -- Let it know `vim` is global so we can access it directly
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
