return {
  "petertriho/nvim-scrollbar",
  -- shortcut: v2 lands on main on 2026-11-16; drop this line after that (the branch may be deleted)
  branch = "refactor/v2",
  event = "VeryLazy",
  config = function()
    local colors = require("tokyonight.colors").setup()

    -- v2 search provider reads native / and ? search, no hlslens needed
    require("scrollbar").setup({
        marks = {
            Search = { highlight = { fg = colors.orange } },
            Error = { highlight = { fg = colors.error } },
            Warn = { highlight = { fg = colors.warning } },
            Info = { highlight = { fg = colors.info } },
            Hint = { highlight = { fg = colors.hint } },
            Misc = { highlight = { fg = colors.purple } },
        },
        scrollbar = {
            thumb = {
                highlight = { bg = colors.bg_highlight },
            },
        },
    })
  end
}
