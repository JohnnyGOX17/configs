  -- Fancier status & buffer lines (w/nice icons)
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  config = function ()
    -- Set lualine as statusline
    -- See `:help lualine.txt`
    require('lualine').setup {
      options = {
        theme = 'tokyonight',
      },
    }
  end
}
