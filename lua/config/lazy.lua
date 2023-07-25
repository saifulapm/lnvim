local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require('lazy').setup({
  spec = {
    -- add LazyVim and import its plugins
    { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
    -- import any extras modules here
    -- { import = 'lazyvim.plugins.extras.ui.mini-starter' },
    -- { import = 'lazyvim.plugins.extras.lang.typescript' },
    -- { import = 'lazyvim.plugins.extras.linting.eslint' },
    -- { import = 'lazyvim.plugins.extras.formatting.prettier' },
    -- { import = 'lazyvim.plugins.extras.lang.json' },
    -- { import = 'lazyvim.plugins.extras.lang.rust' },
    -- { import = 'lazyvim.plugins.extras.lang.tailwind' },
    { import = 'lazyvim.plugins.extras.ui.mini-starter' },
    { import = 'lazyvim.plugins.extras.vscode' },
    -- { import = 'lazyvim.plugins.extras.test.core' },
    -- { import = 'lazyvim.plugins.extras.dap.core' },
    -- { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
    { import = 'lazyvim.plugins.extras.editor.leap' },
    -- { import = 'lazyvim.plugins.extras.coding.yanky' },
    -- { import = 'lazyvim.plugins.extras.editor.mini-files' },
    { import = 'plugins' },
  },
  defaults = {
    lazy = true,
  },
  install = { colorscheme = { 'habamax' } },
  checker = {
    enabled = true,
    concurrency = 30,
    notify = false,
    frequency = 3600, -- check for updates every hour
  },
  change_detection = { notify = false },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- 'matchit',
        -- 'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ---@diagnostic disable-next-line: assign-type-mismatch
  dev = {
    path = '~/Sites/nvim',
    patterns = { 'saifulapm' },
    fallback = true,
  },
})
