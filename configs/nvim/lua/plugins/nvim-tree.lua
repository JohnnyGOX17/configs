return {
  'nvim-tree/nvim-tree.lua',
  event = "VeryLazy", -- not needed for initial UI
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("nvim-tree").setup({
      view = {
        adaptive_size = true,
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
      end,
    })

    vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { desc = 'Open nvim-tree file viewer on the left', silent = true })
  end
}

