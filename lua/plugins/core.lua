return {
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = function()
        require('themes').setup()
        require('statusline').setup()
      end,
    },
  },
}
