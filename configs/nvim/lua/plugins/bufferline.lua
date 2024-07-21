return { -- 
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup{
      options = {
        separator_style = "slant",
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
        indicator = { style = 'underline' },
        diagnostics = "nvim_lsp",
        update_in_insert = true,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end
      }
    }
  end
}
