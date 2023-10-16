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
        vim.keymap.set('n', '<C-h>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '<C-l>', api.tree.change_root_to_node, opts('CD'))
        vim.keymap.set('n', '<CR>', api.node.open.preview, opts('Open Preview'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
        vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
        vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
      end,
    })

    vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { desc = 'Open nvim-tree file viewer on the left', silent = true })
  end
}

