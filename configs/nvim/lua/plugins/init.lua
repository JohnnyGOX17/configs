return { -- Configure treesitter here, other plugins in other lua files
  {
    -- NOTE: may need to install tree-sitter-cli like `cargo install --locked tree-sitter-cli`
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter').install({
        'bash',
        'c',
        'cpp',
        'cuda',
        'dockerfile',
        'go',
        'html',
        'java',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'rust',
        'tcl',
        'typescript',
        'vhdl',
        'verilog',
        'vim',
        'vimdoc',
        'yaml',
      })
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
