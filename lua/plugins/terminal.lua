return {
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    opts = {
      open_mapping = [[<c-\>]],
      shade_filetypes = {},
      direction = 'horizontal',
      autochdir = true,
      persist_mode = true,
      insert_mappings = false,
      start_in_insert = true,
      winbar = { enabled = false },
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
    },
    config = function(_, opts) require('toggleterm').setup(opts) end,
  },
  {
    'numToStr/FTerm.nvim',
    opts = { hl = 'NormalFloat', dimensions = { height = 0.4, width = 0.9 } },
    keys = {
      { '<A-t>', function() require('FTerm').toggle() end, desc = 'Toggle Terminal' },
      { '<A-t>', function() require('FTerm').toggle() end, desc = 'Toggle Terminal', mode = 't' },
    },
  },
}
