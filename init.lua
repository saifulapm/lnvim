-- Large file treesitter very slow. More than 800KB will not load treesitter
_G.allowed_max_size = 1020 * 1024 * 0.8
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
