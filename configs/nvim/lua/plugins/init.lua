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
        'systemverilog',
        'vim',
        'vimdoc',
        'yaml',
      })
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          -- Bail out for filetypes with no installed parser, rather than pointing
          -- 'foldexpr'/'indentexpr' at treesitter functions that can't work.
          if not pcall(vim.treesitter.start, ev.buf) then
            return
          end
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- Only hand 'indentexpr' to treesitter when it actually ships an
          -- `indents.scm` query for a language.
          local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
          if vim.treesitter.query.get(lang, 'indents') then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
