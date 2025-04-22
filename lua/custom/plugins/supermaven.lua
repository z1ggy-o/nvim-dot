return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  cmd = {
    "SupermavenUseFree",
    "SupermavenUsePro",
  },
  opts = {
    -- keymaps = {
    --   accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
    --   clear_suggestion = "<C-e>",
    -- },
    -- disable_keymaps = true,
    disable_inline_completion = false, -- disable inline completion for use with nvim-cmp/blink.cmp, see https://github.com/supermaven/supermaven-nvim/issues/10
    ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
  },
}
