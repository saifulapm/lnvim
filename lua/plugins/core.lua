return {
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = function()
        require('themes').setup()
        require('statusline').setup()
      end,
      icons = {
        diagnostics = {
          Error = '',
          Warn = '',
          Hint = '',
          Info = '',
        },
        git = {
          added = ' ',
          modified = ' ',
          removed = ' ',
        },
      },
    },
  },
}
