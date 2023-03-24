return { -- Markdown/LaTeX highlighting & tools
  'preservim/vim-markdown',
  branch = 'master',
  ft = {
    "markdown",
    "tex",
    "plaintex",
  },
  dependencies = {
    'godlygeek/tabular', -- Easy text alignment plugin
    'jbyuki/nabla.nvim', -- Generate ASCII math from LaTeX equations in popup
  },
  config = function ()
    -- VimMarkdown options
    -- NOTE: you can follow Markdown file links like `[link text](link-url)` with `ge` shortcut
    vim.o.conceallevel = 2  -- enable conceal for math/syntax use
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_toml_frontmatter = 1
    vim.g.vim_markdown_json_frontmatter = 1
    -- Don't auto indent or add new list bullets, as `autolist` plugin will do that
    vim.g.vim_markdown_auto_insert_bullets  = 0
    vim.g.vim_markdown_new_list_item_indent = 0
    --vim.g.vim_markdown_emphasis_multiline = 0
    vim.g.vim_markdown_strikethrough = 1
    -- When following a link (`ge` command), open target file in new tab
    vim.g.vim_markdown_edit_url_in = 'tab'

    vim.keymap.set('n', '<leader>p', ':lua require("nabla").popup()<CR>')

    -- Wrap long lines at 'breakat' characters (keeps whole words while wrapping)
    vim.o.linebreak = true
  end
}
