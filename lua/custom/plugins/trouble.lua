--  Better diagnostics list
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {},
	keys = {
		{ "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics Document (Trouble)" },
		{ "<leader>dw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics Workspace (Trouble)" },
		{ "<leader>dl", "<cmd>Trouble loclist toggle<cr>", desc = "[D]iagnostics [L]ocation List (Trouble)" },
		{ "<leader>dq", "<cmd>Trouble qflist toggle<cr>", desc = "[D]iagnostics [Q]uickfix List (Trouble)" },
		{
			"[q",
			function()
				if require("trouble").is_open() then
					require("trouble").prev({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cprev)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
			end,
			desc = "Previous trouble/quickfix item",
		},
		{
			"]q",
			function()
				if require("trouble").is_open() then
					require("trouble").next({ skip_groups = true, jump = true })
				else
					local ok, err = pcall(vim.cmd.cnext)
					if not ok then
						vim.notify(err, vim.log.levels.ERROR)
					end
				end
			end,
			desc = "Next trouble/quickfix item",
		},
	},
}
