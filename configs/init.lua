-- ////////////////////////////////////////////////////////////////////////////
--
-- Neovim Configuration
--
-- Prerequisites:
--  * neovim >= 0.8 (for built-in LSP and other features)
--  * LSP and associated tools like [rust-analyzer](https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary)
--
-- Install Steps:
--  * Place this file in '$HOME/.config/nvim/'
--  * Packer will run on first invocation, then restart Neovim
--  * Do `$ python3 -m pip install --user --upgrade pynvim` to have provider available below
--
-- References:
--  * Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
--  * [How to Configure Neovim to make it Amazing - typecraft YouTube](https://www.youtube.com/watch?v=J9yqSdvAKXY)
--  * [Neovim from Scratch - chris@machine YouTube Series](https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ)
--
-- ////////////////////////////////////////////////////////////////////////////

-- Manually set the Python3 host path to make startup much faster (https://neovim.io/doc/user/provider.html)
-- This makes a drastic difference in startup time: https://www.reddit.com/r/neovim/comments/r9acxp/comment/hnbuwy7/?utm_source=share&utm_medium=web2x&context=3
-- NOTE: for now, this path should be manually changed on each system
-- NOTE: startup time can be profiled with `nvim --startuptime <filename>`
vim.g.python3_host_prog = '/usr/local/bin/python3'

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Detect OS being used
local current_OS = vim.loop.os_uname().sysname

-- Use system clipboard register for shared copy/paste
if current_OS == 'Darwin' then
  vim.api.nvim_set_option("clipboard", "unnamed")
else
  vim.api.nvim_set_option("clipboard", "unnamedplus")
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'hrsh7th/cmp-path'
    },
  }

  use { 'nvim-tree/nvim-tree.lua', requires = 'nvim-tree/nvim-web-devicons' }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use({ -- Nice diagnositc lines
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  })

  use({
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          --bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  })

  use 'gaoDean/autolist.nvim' -- Helpful formatter to Markdown lists

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Color theme plugins
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'arcticicestudio/nord-vim'
  use 'folke/tokyonight.nvim'

  use 'editorconfig/editorconfig-vim' -- Maintain consistent coding styles for projects

  use 'godlygeek/tabular' -- Easy text alignment plugin

  -- Fancier status & buffer lines (w/nice icons)
  use {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  use 'psf/black' -- Black Python formatter

  use 'plasticboy/vim-markdown' -- Markdown highlighting

  use 'jbyuki/nabla.nvim' -- Generate ASCII math from LaTeX equations in popup

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Disable mode indicator since we show mode in statusline
vim.o.showmode = false

-- Disable mouse mode
vim.o.mouse = ''

-- Enable folding by default and fold by indent (rather than syntax or marker)
vim.o.foldenable = true
vim.o.foldmethod = "indent"
-- high value here means files open unfolded by default
vim.o.foldlevel = 99

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time for CursorHold and timeout for events
vim.o.updatetime = 250
vim.o.timeoutlen = 250
vim.wo.signcolumn = 'yes'

-- Highlight current line horizontally
vim.o.cursorline = true

-- Show tab characters in files
vim.wo.list = true
vim.wo.listchars = "tab:» ,extends:>,precedes:<,nbsp:+"

-- Use global status line (vs per window status line)
vim.o.laststatus = 3

-- Have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
-- setting from static 'yes' -> 'number' merges number and diag's to one column
--   like -> https://www.reddit.com/r/neovim/comments/neaeej/only_just_discovered_set_signcolumnnumber_i_like/
vim.o.signcolumn = "number"

-- disable netrw at the very start of your init.lua (strongly advised for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme tokyonight-night]]
vim.cmd [[hi WinSeparator guifg=orange]]
-- show trailing whitespace as red
vim.cmd [[hi ExtraWhitespace ctermfg=NONE ctermbg=red cterm=NONE guifg=NONE guibg=red gui=NONE]]
-- Italicize comments (not needed, already in theme)
-- vim.cmd [[hi Comment cterm=italic gui=italic]]
-- vim.cmd [[hi SpecialComment cterm=italic gui=italic]]

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- `jk` to escape from insert mode
vim.keymap.set('i', 'jk', '<Esc>')
-- Since 'chage inner word' allows you to not have the cursor at the beginning
-- of the word, map ciw -> cw by default.
vim.keymap.set('n', 'cw', 'ciw')

-- Buffer keymaps
vim.keymap.set('n', '<leader>n', ':enew<CR>', { desc = 'Open new empty buffer' })
vim.keymap.set('n', '<leader>fl', ':bnext<CR>', { desc = 'Move to next open buffer' })
vim.keymap.set('n', '<leader>fh', ':bprevious<CR>', { desc = 'Move to previous open buffer' })
vim.keymap.set('n', '<leader>fq', ':bp <BAR> bd #<CR>', { desc = 'Close current buffer and move to previous one (similar to closing tab)' })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'Vertical split (into another window) current file' })
vim.keymap.set('n', '<leader>s', ':split<CR>', { desc = 'Horizontal split (into another window) current file' })
vim.keymap.set('n', '<leader>h', '<C-w><Left>', { desc = 'Move to window left' })
vim.keymap.set('n', '<leader>l', '<C-w><Right>', { desc = 'Move to window right' })
vim.keymap.set('n', '<leader>k', '<C-w><Up>', { desc = 'Move to window up' })
vim.keymap.set('n', '<leader>j', '<C-w><Down>', { desc = 'Move to window down' })
vim.keymap.set('n', '<leader>q', ':hide<CR>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>K', ':res +10<CR>', { desc = 'Enlarge current window by 10 lines' })
vim.keymap.set('n', '<leader>J', ':res -10<CR>', { desc = 'Shrink current window by 10 lines' })
vim.keymap.set('n', '<leader>L', ':vertical resize +10<CR>', { desc = 'Enlarge current window width by 10 lines' })
vim.keymap.set('n', '<leader>H', ':vertical resize -10<CR>', { desc = 'Shrink current window widht by 10 lines' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Go to Last Location of Buffer on open
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

-- Set .xdc filetype to Tcl
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufFilePre", "BufRead" },
  { pattern = "*.xdc", command = "set filetype=tcl" }
)

-- Turn on spell-check for Markdown & txt files, while turning off line numbering
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufFilePre", "BufRead" },
  { pattern = "*.{md,tex,txt}", command = "setlocal spell spelllang=en_us | set nonu" }
)

-- Highlight trailing whitespace as match to ExtraWhitespace
vim.api.nvim_create_autocmd(
  { "BufWinEnter", "InsertLeave" },
  { pattern = "*.{c,cpp,h,hpp,py,rs,sh,sv,v,vhd}", command = "match ExtraWhitespace /\\s\\+$/" }
)
-- Don't highlight while in insert mode and clear when leaving for performance issues
vim.api.nvim_create_autocmd(
  { "InsertEnter", "BufWinLeave" },
  { pattern = "*.{c,cpp,h,hpp,py,rs,sh,sv,v,vhd}", command = "call clearmatches()" }
)
-- Automatically remove all trailing whitespace when buffer is saved
vim.api.nvim_create_autocmd(
  "BufWritePre",
  { pattern = "*.{c,cpp,h,hpp,py,rs,sh,sv,v,vhd}", command = "%s/\\s\\+$//e" }
)

-- Need to force Black python formatter to run on buffer write
vim.api.nvim_create_autocmd(
  "BufWritePre",
  { pattern = "*.py", command = "Black" }
)

-- Set cursorline only when not in insert mode
local hcursor_group = vim.api.nvim_create_augroup('HorizCursor', { clear = true })
vim.api.nvim_create_autocmd(
  { "InsertLeave", "WinEnter" },
  { pattern = "*", command = "set cursorline", group = hcursor_group }
)
vim.api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = hcursor_group }
)

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    theme = 'tokyonight',
  },
}

-- Configure buffer line
require("bufferline").setup{
  options = {
    separator_style = "slant",
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_default_icon = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    always_show_bufferline = false,
  }
}

-- Enable Comment.nvim
require('Comment').setup()

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>rf', require('telescope.builtin').oldfiles, { desc = 'Find [R]ecently opened [F]iles' })
vim.keymap.set('n', '<leader>eb', require('telescope.builtin').buffers, { desc = 'Find [E]xisting [B]uffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>p', ':lua require("nabla").popup()<CR>')

-- Disable search highlighting when moving after non-search key
--  From: https://www.reddit.com/r/neovim/comments/zc720y/comment/iyvcdf0/?utm_source=share&utm_medium=web2x&context=3
vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  end
end, vim.api.nvim_create_namespace "auto_hlsearch")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'cuda',
    'dockerfile',
    'go',
    'html',
    'java',
    'javascript',
    'latex',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'regex',
    'rust',
    'typescript',
    'verilog',
    'vim',
    'help'
  },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>fs', vim.lsp.buf.signature_help, '[F]unction [S]ignature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers (LSPs):
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
-- Available LSPs: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local servers = {
  bashls = {}, -- Bash
  clangd = {}, -- C/C++, see https://clangd.llvm.org/installation.html
  cssls = {}, -- CSS
  -- gopls = {}, -- Go
  html = {}, -- HTML
  jsonls = {}, -- JSON
  jdtls = {}, -- Java
  pyright = {}, -- Python
  rust_analyzer = {}, -- Rust
  tsserver = {}, -- JavaScript/TypeScript

  --sumneko_lua = { -- Lua
  --  Lua = {
  --    workspace = { checkThirdParty = false },
  --    telemetry = { enable = false },
  --  },
  --},
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
--  See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- From: https://www.youtube.com/watch?v=h4g0m0Iwmys
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto }),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

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

require('autolist').setup({})

-- Customize nvim-lspconfig UI (https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter)
-- Automatically update diagnostics
vim.diagnostic.config({
  virtual_text = false, -- disable end of line diagnostic message since using lsp_lines plugin
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- VimMarkdown options
vim.o.conceallevel = 2
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_new_list_item_indent = 0
vim.g.vim_markdown_emphasis_multiline = 0
vim.g.vim_markdown_strikethrough = 1

-- For VHDL syntax highlighting, indent similar to C-syntax operation (e.g. by shiftwidth())
vim.g.vhdl_indent_genportmap = 0

vim.api.nvim_exec(
  [[
  func! SpacesToTabs()
    setlocal noexpandtab " don't expand tabs to spaces
    %retab!              " Retabulate the whole file
    normal mzgg=G`z      " Re-indent file and keep cursor position
  endfu
  com! SpacesToTabs call SpacesToTabs()
]], true)

vim.api.nvim_exec(
  [[
  func! TabsToSpaces()
    setlocal expandtab " expand tabs to spaces
    %retab!            " Retabulate the whole file
    normal mzgg=G`z    " Re-indent file and keep cursor position
  endfu
  com! TabsToSpaces call TabsToSpaces()
]], true)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
