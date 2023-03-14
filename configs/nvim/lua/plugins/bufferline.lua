return { -- 
  'akinsho/bufferline.nvim',
  version = "v3.*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup{
      options = {
        separator_style = "slant",
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_default_icon = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
      }
    }
  end
}
