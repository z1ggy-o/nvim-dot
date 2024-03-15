return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  --  This is equivalent to:
  --    require('Comment').setup({})
  { 'numToStr/Comment.nvim', opts = {} },
}
