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
}
