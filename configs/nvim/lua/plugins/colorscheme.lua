-- Set colorscheme to Tokyo Night
-- Other color theme plugins:
--   * 'navarasu/onedark.nvim'    -- Theme inspired by Atom
--   * 'arcticicestudio/nord-vim'
return {
  'folke/tokyonight.nvim',
  lazy = false, -- make sure we load this during startup since main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- Tokyo Night colorscheme config
    -- NOTE: must set options _before_ loading `colorscheme` command
    require("tokyonight").setup({
      style = "night",
      dim_inactive = true,
      lualine_bold = true,
      -- Override colors for background and background dark to allow dim_inactive 
      -- to work for "night" scheme (inactive slightly darker bg color)
      on_colors = function(colors)
        colors.bg = "#181818"
        colors.bg_dark = "#101010"
      end
    })
    vim.cmd [[colorscheme tokyonight]]
    vim.cmd [[hi WinSeparator guifg=orange]]
    -- show trailing whitespace as red
    vim.cmd [[hi ExtraWhitespace ctermfg=NONE ctermbg=red cterm=NONE guifg=NONE guibg=red gui=NONE]]
    -- lighten up completion window background (only guibg need be set 
    -- with vim.o.termguicolors = true (init.lua)
    vim.cmd [[hi Pmenu guibg=#2C2C2C]]
    -- Italicize comments (not needed, already in theme)
    -- vim.cmd [[hi Comment cterm=italic gui=italic]]
    -- vim.cmd [[hi SpecialComment cterm=italic gui=italic]]
  end
}
