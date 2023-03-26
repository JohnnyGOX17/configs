return {
  'nvim-tree/nvim-tree.lua',
  event = "VeryLazy", -- not needed for initial UI
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("nvim-tree").setup({
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "h", action = "close_node" },
            { key = "l", action = "edit" },
          },
        },
      },
    })

    vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { desc = 'Open nvim-tree file viewer on the left', silent = true })
  end
}
