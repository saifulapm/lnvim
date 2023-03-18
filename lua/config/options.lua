local set = vim.opt

vim.g.maplocalleader = ","
set.clipboard = ""
set.textwidth = 150
set.colorcolumn = { "+1" } -- draw a vertical ruler at (textwidth + 1)th column
set.fillchars = {
  foldopen = "",
  foldclose = "",
  diff = "/",
  eob = " ", -- use 'space' for lines after the last buffer line in a window
}
set.guicursor = "n-c:hor50,i-ci-ve:ver25-ModesInsert" -- horizontal in normal, vertical in insert
set.signcolumn = "no" -- disable signcolumn
set.wrap = false -- disable line wrap
set.softtabstop = -1 -- number of spaces that a <Tab> counts for while performing editing operations, negative means use 'shiftwidth' value

set.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
set.foldlevelstart = 99
set.foldenable = true
