local set = vim.opt

vim.g.maplocalleader = ','
set.clipboard = ''
set.textwidth = 150
set.colorcolumn = { '+1' } -- draw a vertical ruler at (textwidth + 1)th column
set.fillchars = {
  foldopen = '',
  foldclose = '',
  diff = '/',
  eob = ' ', -- use 'space' for lines after the last buffer line in a window
}
set.guicursor = 'n-c:hor50,i-ci-ve:ver25-ModesInsert' -- horizontal in normal, vertical in insert
set.signcolumn = 'no' -- disable signcolumn
set.wrap = false -- disable line wrap
set.softtabstop = -1 -- number of spaces that a <Tab> counts for while performing editing operations, negative means use 'shiftwidth' value
set.laststatus = 3

set.complete:remove({ -- disable scan for
  'u', -- unload buffers
  't', -- tag completion
})
set.completeopt:append({
  'menuone', -- use the popup menu also when there is only one match
  'noinsert', -- do not insert any text for a match until the user selects a match from the menu
  'noselect', -- do not selecr a match in the menu, forece the user to select one from the menu
})

set.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
set.foldlevelstart = 99
set.foldenable = true
set.breakindent = true -- continue indenting wrapped lines
set.pumblend = 10 -- pseudo-transparency for the popup-menu, value : 0 - 100
set.showtabline = 1 -- show tab-page only if there are at least 2 tab pages
set.wrapmargin = 2
set.autoindent = true
set.shiftround = true
set.expandtab = true
set.shiftwidth = 2
