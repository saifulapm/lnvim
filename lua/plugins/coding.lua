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
      opts.completion = { keyword_length = 3 }
      opts.window = {
        completion = {
          side_padding = 0,
          winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
          scrollbar = false,
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
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
      require('nvim-autopairs').setup({
        close_triple_quotes = true,
        check_ts = true,
        ts_config = {
          lua = { 'string' },
          dart = { 'string' },
          javascript = { 'template_string' },
        },
        fast_wrap = { map = '<c-e>' },
      })
    end,
  },
  {
    'numToStr/Comment.nvim',
    keys = { 'gcc', { 'gc', mode = { 'x', 'n', 'o' } } },
    opts = function(_, opts)
      local ok, integration = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
      if ok then opts.pre_hook = integration.create_pre_hook() end
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
      luasnip.filetype_extend('html', { 'svelte' })
      luasnip.filetype_extend('javascript', { 'svelte-script' })
      luasnip.filetype_extend('css', { 'svelte-style' })
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
  {
    'jackMort/ChatGPT.nvim',
    cmd = 'ChatGPT',
    config = true,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
}
