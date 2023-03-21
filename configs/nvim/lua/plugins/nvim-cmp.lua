return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  -- load cmp on InsertEnter
  event = "InsertEnter",
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-path'
  },
  config = function()
    -- nvim-cmp setup
    --  See https://github.com/hrsh7th/nvim-cmp#basic-configuration
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    -- From: https://www.youtube.com/watch?v=h4g0m0Iwmys
    require("luasnip.loaders.from_vscode").lazy_load()

    local cmp_kinds = {
      Text = '  ',
      Method = '  ',
      Function = 'ƒ  ',
      Constructor = '  ',
      Field = '  ',
      Variable = '  ',
      Class = '  ',
      Interface = '  ',
      Module = '  ',
      Property = '  ',
      Unit = '  ',
      Value = '  ',
      Enum = '  ',
      Keyword = '  ',
      Snippet = '  ',
      Color = '  ',
      File = '  ',
      Reference = '  ',
      Folder = '  ',
      EnumMember = '  ',
      Constant = '  ',
      Struct = '  ',
      Event = '  ',
      Operator = '  ',
      TypeParameter = '  ',
    }

    cmp.setup {
      -- Add VS Code like icons to completion menus: 
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-codicons-to-the-menu
      formatting = {
        format = function(_, vim_item)
          vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
          return vim_item
        end,
      },
      window = {
        documentation = {
          -- Make documentation popup window use same colors as completion window
          winhighlight = "Normal:Pmenu",
        },
      },
      -- NOTE: a snippet engine is REQUIRED, here using luasnip
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
  end
}

