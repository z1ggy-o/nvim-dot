--  Better diagnostics list
return {
	"folke/trouble.nvim",
	cmd = { "TroubleToggle", "Trouble" },
	opts = { use_diagnostic_signs = true },
	keys = {
		{ "<leader>dd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Diagnostics Document (Trouble)" },
		{ "<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Diagnostics Workspace (Trouble)" },
		{ "<leader>dl", "<cmd>TroubleToggle loclist<cr>", desc = "[D]iagnostics [L]ocation List (Trouble)" },
		{ "<leader>dq", "<cmd>TroubleToggle quickfix<cr>", desc = "[D]iagnostics [Q]uickfix List (Trouble)" },
		{
			"[q",
			function()
				if require("trouble").is_open() then
					require("trouble").previous({ skip_groups = true, jump = true })
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
