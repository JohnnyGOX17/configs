return { -- Nice diagnositc lines
  url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  -- This can be very lazily loaded as most LSP/diagnositcs will take some time to laod anyways
  event = "VeryLazy",
  config = function()
    require("lsp_lines").setup()
  end
}
