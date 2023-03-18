return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("themes").setup("gruvchad")
        require("statusline").setup()
      end,
    },
  },
}