local o, opt = vim.o, vim.opt

vim.g.maplocalleader = ','

opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}
o.updatetime = 300
o.timeout = true
o.timeoutlen = 500
o.ttimeoutlen = 10
if o.splitkeep then o.splitkeep = 'screen' end
o.splitbelow = true
o.splitright = true
o.eadirection = 'hor'
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
o.switchbuf = 'useopen,uselast'
opt.fillchars = {
  eob = ' ', -- suppress ~ at EndOfBuffer
  diff = '╱', -- alternatives = ⣿ ░ ─
  msgsep = ' ', -- alternatives: ‾ ─
  fold = ' ',
  foldopen = '▽', -- '▼'
  foldclose = '▷', -- '▶'
  foldsep = ' ',
}
opt.diffopt = opt.diffopt
  + {
    'vertical',
    'iwhite',
    'hiddenoff',
    'foldcolumn:0',
    'context:4',
    'algorithm:histogram',
    'indent-heuristic',
  }
opt.diffopt:append({ 'linematch:60' })
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//
opt.formatoptions = {
  ['1'] = true,
  ['2'] = true, -- Use indent from 2nd line of a paragraph
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 99
o.foldenable = true
vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
opt.grepformat = opt.grepformat ^ { '%f:%l:%c:%m' }
o.wildcharm = ('\t'):byte()
o.wildmode = 'list:full' -- Shows a menu bar as opposed to an enormous list
o.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
opt.wildignore = {
  '*.aux',
  '*.out',
  '*.toc',
  '*.o',
  '*.obj',
  '*.dll',
  '*.jar',
  '*.pyc',
  '*.rbc',
  '*.class',
  '*.gif',
  '*.ico',
  '*.jpg',
  '*.jpeg',
  '*.png',
  '*.avi',
  '*.wav',
  -- Temp/System
  '*.*~',
  '*~ ',
  '*.swp',
  '.lock',
  '.DS_Store',
  'tags.lock',
}
opt.wildoptions = { 'pum', 'fuzzy' }
o.pumblend = 3 -- Make popup window translucent
o.conceallevel = 2
o.breakindentopt = 'sbr'
o.linebreak = true -- lines wrap at words rather than random characters
o.synmaxcol = 1024 -- don't syntax highlight long lines
o.signcolumn = 'no'
o.ruler = false
o.cmdheight = 0
o.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
o.list = true -- invisible chars
opt.listchars = {
  eol = nil,
  tab = '  ', -- Alternatives: '▷▷',
  extends = '…', -- Alternatives: … » ›
  precedes = '░', -- Alternatives: … « ‹
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}
o.wrap = false
o.wrapmargin = 2
o.textwidth = 140
o.autoindent = true
o.shiftround = true
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = -1 -- number of spaces that a <Tab> counts for while performing editing operations, negative means use 'shiftwidth' value
o.gdefault = true
o.pumheight = 15
o.confirm = true -- make vim prompt me to save before doing destructive things
opt.complete:remove({ -- disable scan for
  'u', -- unload buffers
  't', -- tag completion
})
opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
o.hlsearch = true
o.autowriteall = true -- automatically :write before running commands and changing files
opt.clipboard = ''
o.laststatus = 3
o.termguicolors = true
o.guifont = 'MonoLisa variable:h15'
o.linespace = 0
o.emoji = false
opt.guicursor = 'n-c:hor100,i-ci-ve:ver25-ModesInsert' -- horizontal in normal, vertical in insert
o.title = true
o.titlelen = 70
o.showmode = false
opt.sessionoptions = {
  'globals',
  'buffers',
  'curdir',
  'winpos',
  'tabpages',
}
opt.viewoptions = { 'cursor', 'folds' } -- save/restore just these (with `:{mk,load}view`)
o.virtualedit = 'block' -- allow cursor to move where there is no text in visual block mode
opt.jumpoptions = { 'stack' } -- make the jumplist behave like a browser stack
o.backup = false
o.undofile = true
o.swapfile = false
o.ignorecase = true
o.smartcase = true
o.wrapscan = true -- Searches wrap around the end of the file
o.scrolloff = 9
o.sidescrolloff = 10
o.sidescroll = 1
opt.spellsuggest:prepend({ 12 })
opt.spelloptions:append({ 'camel', 'noplainbuffer' })
opt.spellcapcheck = '' -- don't check for capital letters at start of sentence
opt.fileformats = { 'unix', 'mac', 'dos' }
o.mousefocus = true
o.mousemoveevent = true
opt.mousescroll = { 'ver:1', 'hor:6' }
o.secure = true -- Disable autocmd etc for project local vimrc files.
opt.showtabline = 1
