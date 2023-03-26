-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('i', '<A-h>', '<left>', { desc = 'Go to left' })
vim.keymap.set('i', '<A-j>', '<Down>', { desc = 'Go to lower' })
vim.keymap.set('i', '<A-k>', '<Up>', { desc = 'Go to upper' })
vim.keymap.set('i', '<A-l>', '<Right>', { desc = 'Go to right' })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', function() require('utils').tmux('h') end, { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', function() require('utils').tmux('j') end, { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', function() require('utils').tmux('k') end, { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', function() require('utils').tmux('l') end, { desc = 'Go to right window' })

-- Move to window using the <alt> hjkl keys
vim.keymap.set('n', '<A-h>', function() require('utils').tmux('h') end, { desc = 'Go to left window' })
vim.keymap.set('n', '<A-j>', function() require('utils').tmux('j') end, { desc = 'Go to lower window' })
vim.keymap.set('n', '<A-k>', function() require('utils').tmux('k') end, { desc = 'Go to upper window' })
vim.keymap.set('n', '<A-l>', function() require('utils').tmux('l') end, { desc = 'Go to right window' })

vim.keymap.set({ 'n', 'x' }, '<S-h>', '^', { desc = 'beginning of line' })
vim.keymap.set({ 'n', 'x' }, '<S-l>', 'g_', { desc = 'end of line' })

vim.keymap.set('n', '<A-Tab>', '<C-w>w', { desc = 'next window jumping' })
vim.keymap.set('n', '<localleader>,', function() require('utils').toggle_char(',') end, { desc = 'Toggle ,' })
vim.keymap.set('n', '<localleader>;', function() require('utils').toggle_char(';') end, { desc = 'Toggle ;' })

vim.keymap.set('n', '<localleader>z', [[zMzvzz]], { desc = 'Refocus folds' })

-- windows
vim.keymap.set('n', '<localleader>wh', '<C-W>t <C-W>K', { desc = 'horizontal to vertical splits' })
vim.keymap.set('n', '<localleader>wv', '<C-W>t <C-W>K', { desc = 'vertical to horizontal splits' })

-- Quotes
vim.keymap.set('n', '<leader>"', [[ciw"<c-r>""<esc>]], { desc = 'wrap word by "' })
vim.keymap.set('n', "<leader>'", [[ciw'<c-r>"'<esc>]], { desc = "wrap word by '" })
vim.keymap.set('n', '<leader>)', [[ciw(<c-r>")<esc>]], { desc = 'wrap word by ()' })
vim.keymap.set('n', '<leader>}', [[ciw{<c-r>"}<esc>]], { desc = 'wrap word by {}' })

-- Open plugin directly to github
vim.keymap.set('n', 'g/', function()
  local repo = vim.fn.expand('<cfile>')
  if not repo or #vim.split(repo, '/') ~= 2 then return vim.cmd('norm! gf') end
  local url = string.format('https://www.github.com/%s', repo)
  vim.fn.jobstart('open ' .. url)
  vim.notify(string.format('Opening %s at %s', repo, url))
end, { desc = 'Open plugin directly to github' })

-- Clipboard
vim.keymap.set({ 'n', 'x' }, '<leader>p', '"+p', { desc = 'Clipboard p' })
vim.keymap.set({ 'n', 'x' }, '<leader>P', '"+P', { desc = 'Clipboard P' })
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Clipboard y' })
vim.keymap.set('n', '<leader>Y', '"+y$', { desc = 'Clipboard Y' })
vim.keymap.set('n', '<leader>d', '"+d', { desc = 'Clipboard d' })

vim.keymap.set('x', 'cn', '*``cgn')
vim.keymap.set('x', 'cN', '*``cgN')
vim.keymap.set('x', '//', [[y/<C-R>"<CR>]])
vim.keymap.set('x', 'p', 'pgv')

-- Zen mode
vim.keymap.set('n', 'gZ', function() require('utils.zen').enter() end)

vim.keymap.set('n', 'gzz', function() require('utils.zen').toggle({ laststatus = true }) end)

------------------------------------------------------------------------------------------------------------------------------------------------------
--  Laravel Specific Keymaps
------------------------------------------------------------------------------------------------------------------------------------------------------
if vim.fn.glob('artisan') ~= '' then
  local tinker = require('FTerm'):new({
    cmd = 'php artisan tinker',
  })
  vim.keymap.set('n', '<Leader>Ll', ':e storage/logs/laravel.log<CR>', { desc = 'Laravel Log' })
  vim.keymap.set('n', '<Leader>Le', ':e .env<CR>', { desc = 'Laravel Env' })
  vim.keymap.set('n', '<Leader>Lt', function() tinker:toggle() end, { desc = 'Laravel Tinker' })
end
