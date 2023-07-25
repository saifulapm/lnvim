local function border(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

local source_hl = {
  nvim_lua = '@constant.builtin',
  luasnip = '@comment',
  buffer = '@string',
  path = 'Directory',
}

return {
  {
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.completion = { keyword_length = 2 }
      opts.window = {
        completion = {
          side_padding = 0,
          winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
          scrollbar = false,
          border = 'shadow',
          col_offset = -3,
        },
        documentation = { border = border('CmpDocBorder'), winhighlight = 'Normal:CmpDoc' },
      }
      opts.formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, item)
          local icons = require('lazyvim.config').icons.kinds
          local kind_hl_group = ('CmpItemKind%s'):format(item.kind)
          item.kind_hl_group = ('%sIcon'):format(kind_hl_group)
          item.kind = (' %s '):format(icons[item.kind])
          item.menu_hl_group = source_hl[entry.source.name] or kind_hl_group
          item.menu = ({
            nvim_lsp = '[LSP]',
            nvim_lua = '[Lua]',
            emoji = '[E]',
            path = '[Path]',
            neorg = '[N]',
            luasnip = '[SN]',
            dictionary = '[D]',
            buffer = '[B]',
            spell = '[SP]',
            cmdline = '[Cmd]',
            cmdline_history = '[Hist]',
            orgmode = '[Org]',
            norg = '[Norg]',
            rg = '[Rg]',
            git = '[Git]',
          })[entry.source.name]
          return item
        end,
      }
      opts.experimental = {
        ghost_text = false,
      }

      local cmp = require('cmp')
      -- local luasnip = require('luasnip')
      local function shift_tab(fallback)
        if not cmp.visible() then return fallback() end
        -- if luasnip.jumpable(-1) then luasnip.jump(-1) end
      end

      local function tab(fallback) -- make TAB behave like Android Studio
        if not cmp.visible() then return fallback() end
        if not cmp.get_selected_entry() then return cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) end
        -- if luasnip.expand_or_jumpable() then return luasnip.expand_or_jump() end
        cmp.confirm()
      end

      opts.mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<S-TAB>'] = cmp.mapping(shift_tab, { 'i', 's' }),
        ['<TAB>'] = cmp.mapping(tab, { 'i', 's' }),
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      local autopairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      local ts_conds = require('nvim-autopairs.ts-conds')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
      autopairs.setup({
        close_triple_quotes = true,
        check_ts = true,
        ts_config = {
          lua = { 'string' },
          dart = { 'string' },
          javascript = { 'template_string' },
        },
        fast_wrap = { map = '<c-e>' },
      })
      -- credit: https://github.com/JoosepAlviste
      -- Typing space when (|) -> ( | )
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      autopairs.add_rules({
        Rule(' ', ' '):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({
            brackets[1][1] .. brackets[1][2],
            brackets[2][1] .. brackets[2][2],
            brackets[3][1] .. brackets[3][2],
          }, pair)
        end),
      })
      for _, bracket in pairs(brackets) do
        autopairs.add_rules({
          Rule(bracket[1] .. ' ', ' ' .. bracket[2])
            :with_pair(function() return false end)
            :with_move(function(opts) return opts.prev_char:match('.%' .. bracket[2]) ~= nil end)
            :use_key(bracket[2]),
        })
      end
      autopairs.add_rules({
        -- Typing { when {| -> {{ | }} in Vue files
        Rule('{{', '  }', 'vue'):set_end_pair_length(2):with_pair(ts_conds.is_ts_node('text')),

        -- Typing = when () -> () => {|}
        Rule('%(.*%)%s*%=$', '> {}', { 'typescript', 'typescriptreact', 'javascript', 'vue' }):use_regex(true):set_end_pair_length(1),

        -- Typing n when the| -> then|end
        Rule('then', 'end', 'lua'):end_wise(function(opts) return string.match(opts.line, '^%s*if') ~= nil end),
      })
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function()
      local luasnip = require('luasnip')
      local types = require('luasnip.util.types')
      local extras = require('luasnip.extras')
      local fmt = require('luasnip.extras.fmt').fmt
      local fmta = require('luasnip.extras.fmt').fmta

      luasnip.config.set_config({
        history = false,
        region_check_events = 'CursorMoved,CursorHold,InsertEnter',
        delete_check_events = 'InsertLeave',
        ext_opts = {
          [types.choiceNode] = { active = { hl_mode = 'combine', virt_text = { { '●', 'Operator' } } } },
          [types.insertNode] = { active = { hl_mode = 'combine', virt_text = { { '●', 'Type' } } } },
        },
        enable_autosnippets = true,
        snip_env = {
          fmt = fmt,
          fmta = fmta,
          rep = extras.rep,
          m = extras.match,
          t = luasnip.text_node,
          f = luasnip.function_node,
          c = luasnip.choice_node,
          d = luasnip.dynamic_node,
          i = luasnip.insert_node,
          s = luasnip.snippet,
          sn = luasnip.snippet_node,
        },
      })

      vim.api.nvim_create_user_command(
        'LuaSnipEdit',
        function() require('luasnip.loaders.from_lua').edit_snippet_files() end,
        { desc = 'Edit Snippet File' }
      )

      -- <c-l> is selecting within a list of options.
      vim.keymap.set({ 's', 'i' }, '<c-l>', function()
        if luasnip.choice_active() then luasnip.change_choice(1) end
      end)

      vim.keymap.set({ 's', 'i' }, '<c-j>', function()
        if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
      end)

      vim.keymap.set({ 's', 'i' }, '<c-k>', function()
        if luasnip.jumpable(-1) then luasnip.jump(-1) end
      end)

      require('luasnip.loaders.from_lua').lazy_load({ paths = './snippets' })
      require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets' })
      luasnip.filetype_extend('dart', { 'flutter' })
      luasnip.filetype_extend('svelte', { 'html' })
      luasnip.filetype_extend('svelte-script', { 'javascript' })
      luasnip.filetype_extend('javascriptreact', { 'javascript' })
      luasnip.filetype_extend('typescript', { 'javascript' })
      luasnip.filetype_extend('typescriptreact', { 'javascript' })
      luasnip.filetype_extend('svelte-style', { 'css' })
      -- For Shopify Json Schema
      luasnip.filetype_extend('json', { 'liquid' })
    end,
    keys = function() return {} end,
  },
  {
    'danymat/neogen',
    cmd = 'Neogen',
    opts = { snippet_engine = 'luasnip' },
  },
}
