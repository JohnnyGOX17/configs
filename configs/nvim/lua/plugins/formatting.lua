return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  -- NOTE 'editorconfig/editorconfig-vim' is redundant since vim-sleuth can use 
  -- [EditorConfig](https://editorconfig.org/) files or vim modeline statements
  -- event = "InsertEnter" NOTE: this does not load properly when set to this event nor "VeryLazy", though the loading time of this plugin has been profiled to be minimal
}
