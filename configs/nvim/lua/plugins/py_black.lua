return {
  'psf/black', -- Black Python formatter
  ft = "python", -- only load for Python file types
  event = "InsertEnter",
  config = function ()
    -- Need to force Black python formatter to run on buffer write
    vim.api.nvim_create_autocmd(
      "BufWritePre",
      { pattern = "*.py", command = "Black" }
    )
  end
}
