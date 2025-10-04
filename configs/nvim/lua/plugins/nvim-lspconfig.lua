return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = "InsertEnter",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- Useful status updates for LSP
    {'j-hui/fidget.nvim', tag = "legacy"},

    -- Additional lua configuration, makes nvim stuff amazing
    'folke/neodev.nvim',
  },
  init = function()
    -- Enable the following language servers (LSPs):
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. They will be passed to
    --  the `settings` field of the server config. You must look up that documentation yourself.
    --
    --  LSPs can be updated with `:MasonInstall <package>`, and debug info with `:MasonLog`
    --   - Specific versions specified as `:MasonInstall <package>@<version>`
    --
    -- Available LSPs: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    -- LSP Config doc: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    local servers = {
      bashls = {}, -- Bash
      clangd = {}, -- C/C++ (more options set below)
      cmake = {}, -- cmake
      cssls = {}, -- CSS
      --gopls = {}, -- Go
      html = {}, -- HTML
      jsonls = {}, -- JSON
      jdtls = {}, -- Java
      lua_ls = {},
      marksman = {},
      pyright = {}, -- Python (https://github.com/microsoft/pyright)
      ruff = {}, -- Python (https://github.com/charliermarsh/ruff) Options: https://github.com/charliermarsh/ruff-lsp
      ts_ls = {}, -- JavaScript/TypeScript: npm install -g typescript typescript-language-server
      verible = {}, -- [(System)Verilog](https://github.com/chipsalliance/verible/blob/master/verilog/tools/ls/README.md)
    }

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

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Setup mason so it can manage external tooling
    require('mason').setup()

    -- Ensure the servers above are installed
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    vim.lsp.config("clangd", { -- clangd specific setup opts (https://clangd.llvm.org/config)
      cmd = {
        -- See https://clangd.llvm.org/installation.html and https://clangd.llvm.org/installation.html#project-setup
        -- for how to install & setup for a given project/system
        "clangd",
        -- parses all files in the project in the background to build a complete index
        --  https://clangd.llvm.org/design/indexing#backgroundindex
        "--background-index",
        -- Enable clang-tidy linter. NOTE: by default, looks for `.clang-tidy` file in project root,
        --  which can be generated with a given check/style with --dump-config. For example:
        --  $ clang-tidy -checks=google-* --dump-config > .clang-tidy
        -- Note also below where format-on-save is enabled for clangd, which uses clang-format.
        -- In this case see to make a project .clang-format file with https://clang.llvm.org/docs/ClangFormatStyleOptions.html or similarly:
        -- $ clang-format -style=google -dump-config > .clang-format
        "--clang-tidy",
        "--completion-style=bundled", -- combine similar completion items
        "--cross-file-rename",
        "--header-insertion=iwyu", -- include what you use, like https://github.com/include-what-you-use/include-what-you-use
        "--pch-storage=memory", -- store PCHs in memory to improve performance (increases memory usage however)
        "-j=4", -- number of async workers used by clangd & background index
      }
    })
    vim.lsp.enable("clangd")

    -- Run `:Format` on buffer save, if the LSP for a given file type/pattern supports it
    local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.c,*.cpp,*.h,*.hpp,*.py,*.rs,*.v,*.vhd,*.sv,*.svh",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
      group = format_sync_grp,
    })


    -- For VHDL syntax highlighting, indent similar to C-syntax operation (e.g. by shiftwidth())
    -- https://neovim.io/doc/user/indent.html#_vhdl
    vim.g.vhdl_indent_genportmap = 0


    -- Setup https://github.com/suoto/hdl_checker, only for VHDL files, requires:
    --  * [GHDL](https://ghdl.github.io/ghdl/getting.html)
    --  * HDL checker: `$ pip install hdl-checker --upgrade`
    --  * [How to setup HDL Checker project](https://github.com/suoto/hdl_checker/wiki/HOWTO:-Setting-up-a-project)
    -- As of now, easier than integrating [GHDL's LSP](https://github.com/ghdl/ghdl-language-server)
    if not require'lspconfig.configs'.hdl_checker then
      require'lspconfig.configs'.hdl_checker = {
        default_config = {
        cmd = {"hdl_checker", "--lsp", };
        filetypes = {"vhdl"};
          root_dir = function(fname)
            -- will look for the .hdl_checker.config file in parent directory, a
            -- .git directory, or else use the current directory, in that order.
            local util = require'lspconfig'.util
            return util.root_pattern('.hdl_checker.config')(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
          end;
          settings = {};
        };
      }
    end
    vim.lsp.enable("hdl_checker")

    -- Note that verible's formatter will take care of indentation, but there are options like:
    -- https://neovim.io/doc/user/indent.html#_verilog
    vim.lsp.config("verible", {
      cmd = {"verible-verilog-ls"};
      filetypes = {"systemverilog", "verilog"};
    })
    vim.lsp.enable("verible")

    vim.lsp.enable("marksman")

    vim.lsp.enable("ts_ls")

    -- Turn on lsp status information
    require('fidget').setup()

    -- Diagnostic keymaps
    vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    --vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    -- Customize nvim-lspconfig UI (https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter)
    -- Automatically update diagnostics
    vim.diagnostic.config({
      -- virtual_text (end of line diagnostic messages) are now off by default since nvim 0.11
      virtual_lines = true, -- https://git.sr.ht/~whynothugo/lsp_lines.nvim is now upstreamed in nvim 0.11!
      signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰅏 ",
        },
      },
      underline = true,
      update_in_insert = true,
      severity_sort = false,
    })
  end
}
