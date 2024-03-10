return { -- Git related plugins
  'tpope/vim-fugitive',
  event = "VeryLazy", -- Not needed for initial UI
  dependencies = { 'lewis6991/gitsigns.nvim' },
  config = function()
    -- See `:help gitsigns.txt`
    require('gitsigns').setup()
  end
}
