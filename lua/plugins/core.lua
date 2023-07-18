return {
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = function() require('themes').setup() end,
    },
  },
}
