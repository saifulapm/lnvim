local M = {}

M.load_colors = function(type)
  local name = vim.g.colors_name ~= nil and vim.g.colors_name or 'default'
  local colors = require('themes.colors.' .. name)

  return colors[type]
end

-- convert table into string
M.table_to_str = function(tb)
  local result = ''

  for hlgroupName, hlgroup_vals in pairs(tb) do
    local hlname = "'" .. hlgroupName .. "',"
    local opts = ''

    for optName, optVal in pairs(hlgroup_vals) do
      local valueInStr = ((type(optVal)) == 'boolean' or type(optVal) == 'number') and tostring(optVal) or '"' .. optVal .. '"'
      opts = opts .. optName .. '=' .. valueInStr .. ','
    end

    result = result .. 'vim.api.nvim_set_hl(0,' .. hlname .. '{' .. opts .. '})'
  end

  return result
end

M.compile = function(theme, reload)
  local dir = vim.fn.stdpath('cache')
  if not vim.loop.fs_stat(dir) then vim.fn.mkdir(dir, 'p') end

  local highlights = M.load_highlights()
  local bg_opt = "vim.opt.bg='" .. M.load_colors('type') .. "'"
  local lines = 'return string.dump(function()' .. bg_opt .. M.table_to_str(highlights) .. 'end, true)'
  local file = io.open(vim.fn.stdpath('cache') .. '/compiled_theme_' .. theme, 'wb')
  if file then
    file:write(load(lines)())
    file:close()
    if reload then
      dofile(vim.fn.stdpath('cache') .. '/compiled_theme_' .. theme)
      vim.notify(string.match(theme, '([%w%-_]+)%.%w+$') .. ' Theme compiled successfully')
    end
  end
end

M.compile_all = function()
  local colors_path = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
  local hl_files = colors_path .. '/colors'

  for _, file in ipairs(vim.fn.readdir(hl_files)) do
    local colorscheme = vim.fn.fnamemodify(file, ':r')
    vim.g.colors_name = colorscheme
    M.compile(file)
  end
end

M.load_highlights = function()
  local polish_hl = M.load_colors('polish_hl')
  local highlights = M.highlights()

  -- polish themes
  if polish_hl then
    for key, value in pairs(polish_hl) do
      if highlights[key] then highlights[key] = vim.tbl_deep_extend('force', highlights[key], value) end
    end
  end

  -- transparency
  if vim.g.transparency then
    local glassy = M.glassy_highlights()

    for key, value in pairs(glassy) do
      if highlights[key] then highlights[key] = M.merge_tb(highlights[key], value) end
    end
  end

  return highlights
end

M.glassy_highlights = function()
  local colors = M.load_colors('base_30')

  return {
    NvimTreeWinSeparator = { fg = colors.one_bg2, bg = 'NONE' },
    TelescopeResultsTitle = { fg = colors.black, bg = colors.blue },
    TelescopeBorder = { fg = colors.grey, bg = 'NONE' },
    TelescopePromptBorder = { fg = colors.grey, bg = 'NONE' },
    NormalFloat = { bg = 'NONE' },
    Normal = { bg = 'NONE' },
    Folded = { bg = 'NONE' },
    NvimTreeNormal = { bg = 'NONE' },
    NvimTreeNormalNC = { bg = 'NONE' },
    NvimTreeCursorLine = { bg = 'NONE' },
    TelescopeNormal = { bg = 'NONE' },
    TelescopePrompt = { bg = 'NONE' },
    TelescopeResults = { bg = 'NONE' },
    TelescopePromptNormal = { bg = 'NONE' },
    TelescopePromptPrefix = { bg = 'NONE' },
    CursorLine = { bg = 'NONE' },
    Pmenu = { bg = 'NONE' },
  }
end

M.highlights = function()
  local colors = M.load_colors('base_30')
  local theme = M.load_colors('base_16')
  local util = require('utils.color')

  -- defaults
  return {
    Normal = { fg = theme.base05, bg = theme.base00 },
    Bold = { bold = true },
    Debug = { fg = theme.base08 },
    Directory = { fg = theme.base0D },
    Error = { fg = theme.base00, bg = theme.base08 },
    ErrorMsg = { fg = theme.base08, bg = theme.base00 },
    Exception = { fg = theme.base08 },
    FoldColumn = { fg = theme.base0C, bg = theme.base01 },
    Folded = { fg = theme.base03, bg = theme.base01 },
    IncSearch = { fg = theme.base01, bg = theme.base09 },
    Italic = { italic = true },
    Macro = { fg = theme.base08 },
    ModeMsg = { fg = theme.base0B },
    MoreMsg = { fg = theme.base0B },
    Question = { fg = theme.base0D },
    Search = { fg = theme.base01, bg = theme.base0A },
    Substitute = { fg = theme.base01, bg = theme.base0A, sp = 'none' },
    SpecialKey = { fg = theme.base03 },
    TooLong = { fg = theme.base08 },
    UnderLined = { fg = theme.base0B },
    Visual = { bg = theme.base02 },
    VisualNOS = { fg = theme.base08 },
    WarningMsg = { fg = theme.base08 },
    WildMenu = { fg = theme.base08, bg = theme.base0A },
    Title = { fg = theme.base0D, sp = 'none' },
    Conceal = { bg = 'NONE' },
    Cursor = { fg = theme.base00, bg = theme.base05 },
    NonText = { fg = theme.base03 },
    SignColumn = { fg = theme.base03, sp = 'NONE' },
    ColorColumn = { bg = theme.base01, sp = 'none' },
    CursorColumn = { bg = theme.base01, sp = 'none' },
    CursorLine = { bg = 'none', sp = 'none' },
    QuickFixLine = { bg = theme.base01, sp = 'none' },
    MatchWord = { bg = colors.grey, fg = colors.white },
    Pmenu = { bg = colors.one_bg },
    PmenuSbar = { bg = colors.one_bg },
    PmenuSel = { bg = colors.pmenu_bg, fg = colors.black },
    PmenuThumb = { bg = colors.grey },
    MatchParen = { link = 'MatchWord' },
    Comment = { fg = colors.grey_fg },
    CursorLineNr = { fg = colors.white },
    LineNr = { fg = colors.grey },

    -- floating windows
    FloatBorder = { fg = colors.blue },
    NormalFloat = { bg = colors.darker_black },
    NvimInternalError = { fg = colors.red },
    WinSeparator = { fg = colors.line },

    -- spell
    SpellBad = { undercurl = true, sp = theme.base08 },
    SpellLocal = { undercurl = true, sp = theme.base0C },
    SpellCap = { undercurl = true, sp = theme.base0D },
    SpellRare = { undercurl = true, sp = theme.base0E },
    healthSuccess = { bg = colors.green, fg = colors.black },

    -- lazy.nvim
    LazyH1 = { bg = colors.green, fg = colors.black },
    LazyButton = { bg = colors.one_bg, fg = util.change_hex_lightness(colors.light_grey, vim.o.bg == 'dark' and 10 or -20) },
    LazyH2 = { fg = colors.red, bold = true, underline = true },
    LazyReasonPlugin = { fg = colors.red },
    LazyValue = { fg = colors.teal },
    LazyDir = { fg = theme.base05 },
    LazyUrl = { fg = theme.base05 },
    LazyCommit = { fg = colors.green },
    LazyNoCond = { fg = colors.red },
    LazySpecial = { fg = colors.blue },
    LazyReasonFt = { fg = colors.purple },
    LazyOperator = { fg = colors.white },
    LazyReasonKeys = { fg = colors.teal },
    LazyTaskOutput = { fg = colors.white },
    LazyCommitIssue = { fg = colors.pink },
    LazyReasonEvent = { fg = colors.yellow },
    LazyReasonStart = { fg = colors.white },
    LazyReasonRuntime = { fg = colors.nord_blue },
    LazyReasonCmd = { fg = colors.sun },
    LazyReasonSource = { fg = colors.cyan },
    LazyReasonImport = { fg = colors.white },
    LazyProgressDone = { fg = colors.green },

    -- Syntax Highlights
    Boolean = { fg = theme.base09 },
    Character = { fg = theme.base08 },
    Conditional = { fg = theme.base0E },
    Constant = { fg = theme.base08 },
    Define = { fg = theme.base0E, sp = 'none' },
    Delimiter = { fg = theme.base0F },
    Float = { fg = theme.base09 },
    Variable = { fg = theme.base05 },
    Function = { fg = theme.base0D },
    Identifier = { fg = theme.base08, sp = 'none' },
    Include = { fg = theme.base0D },
    Keyword = { fg = theme.base0E },
    Label = { fg = theme.base0A },
    Number = { fg = theme.base09 },
    Operator = { fg = theme.base05, sp = 'none' },
    PreProc = { fg = theme.base0A },
    Repeat = { fg = theme.base0A },
    Special = { fg = theme.base0C },
    SpecialChar = { fg = theme.base0F },
    Statement = { fg = theme.base08 },
    StorageClass = { fg = theme.base0A },
    String = { fg = theme.base0B },
    Structure = { fg = theme.base0E },
    Tag = { fg = theme.base0A },
    Todo = { fg = theme.base0A, bg = theme.base01 },
    Type = { fg = theme.base0A, sp = 'none' },
    Typedef = { fg = theme.base0A },
    -- Lsp Semantic hls
    ['@lsp.type.class'] = { fg = theme.base0E },
    ['@lsp.type.decorator'] = { fg = theme.base08 },
    ['@lsp.type.enum'] = { fg = theme.base0A },
    ['@lsp.type.enumMember'] = { fg = theme.base08 },
    ['@lsp.type.function'] = { fg = theme.base0D },
    ['@lsp.type.interface'] = { fg = theme.base08 },
    ['@lsp.type.macro'] = { fg = theme.base08 },
    ['@lsp.type.method'] = { fg = theme.base0D },
    ['@lsp.type.namespace'] = { fg = theme.base08 },
    ['@lsp.type.parameter'] = { fg = theme.base08 },
    ['@lsp.type.property'] = { fg = theme.base08 },
    ['@lsp.type.struct'] = { fg = theme.base0E },
    ['@lsp.type.type'] = { fg = theme.base0A },
    ['@lsp.type.typeParamater'] = { fg = theme.base0A },
    ['@lsp.type.variable'] = { fg = theme.base05 },
    -- ["@event"] = { fg = theme.base08 },
    -- ["@modifier"] = { fg = theme.base08 },
    -- ["@regexp"] = { fg = theme.base0F },

    -- Treesitter
    -- `@annotation` is not one of the default capture group, should we keep it
    ['@annotation'] = { fg = theme.base0F },
    ['@attribute'] = { fg = theme.base0A },
    ['@character'] = { fg = theme.base08 },
    ['@constructor'] = { fg = theme.base0C },
    ['@constant'] = { fg = theme.base08 },
    ['@constant.builtin'] = { fg = theme.base09 },
    ['@constant.macro'] = { fg = theme.base08 },
    ['@error'] = { fg = theme.base08 },
    ['@exception'] = { fg = theme.base08 },
    ['@float'] = { fg = theme.base09 },
    ['@keyword'] = { fg = theme.base0E },
    ['@keyword.function'] = { fg = theme.base0E },
    ['@keyword.return'] = { fg = theme.base0E },
    ['@function'] = { fg = theme.base0D },
    ['@function.builtin'] = { fg = theme.base0D },
    ['@function.macro'] = { fg = theme.base08 },
    ['@function.call'] = { fg = theme.base0D },
    ['@operator'] = { fg = theme.base05 },
    ['@keyword.operator'] = { fg = theme.base0E },
    ['@method'] = { fg = theme.base0D },
    ['@method.call'] = { fg = theme.base0D },
    ['@namespace'] = { fg = theme.base08 },
    ['@none'] = { fg = theme.base05 },
    ['@parameter'] = { fg = theme.base08 },
    ['@reference'] = { fg = theme.base05 },
    ['@punctuation.bracket'] = { fg = theme.base0F },
    ['@punctuation.delimiter'] = { fg = theme.base0F },
    ['@punctuation.special'] = { fg = theme.base08 },
    ['@string'] = { fg = theme.base0B },
    ['@string.regex'] = { fg = theme.base0C },
    ['@string.escape'] = { fg = theme.base0C },
    ['@string.special'] = { fg = theme.base0C },
    ['@symbol'] = { fg = theme.base0B },
    ['@tag'] = { link = 'Tag' },
    ['@tag.attribute'] = { link = '@property' },
    ['@tag.delimiter'] = { fg = theme.base0F },
    ['@text'] = { fg = theme.base05 },
    ['@text.strong'] = { bold = true },
    ['@text.emphasis'] = { fg = theme.base09 },
    ['@text.strike'] = { fg = theme.base0F, strikethrough = true },
    ['@text.literal'] = { fg = theme.base09 },
    ['@text.uri'] = { fg = theme.base09, underline = true },
    ['@type.builtin'] = { fg = theme.base0A },
    ['@variable'] = { fg = theme.base05 },
    ['@variable.builtin'] = { fg = theme.base09 },
    ['@definition'] = { sp = theme.base04, underline = true },
    TSDefinitionUsage = { sp = theme.base04, underline = true },
    ['@scope'] = { bold = true },
    ['@field'] = { fg = theme.base08 },
    ['@field.key'] = { fg = theme.base08 },
    ['@property'] = { fg = theme.base08 },
    ['@include'] = { link = 'Include' },
    ['@conditional'] = { link = 'Conditional' },

    -- IndentBlanklineChar
    -- IndentBlanklineChar = { fg = colors.line },
    -- IndentBlanklineSpaceChar = { fg = colors.line },
    -- IndentBlanklineContextChar = { fg = colors.grey },
    -- IndentBlanklineContextStart = { bg = colors.one_bg2 },

    -- Nvim Tree
    -- NvimTreeEmptyFolderName = { fg = colors.folder_bg },
    -- NvimTreeEndOfBuffer = { fg = colors.darker_black },
    -- NvimTreeFolderIcon = { fg = colors.folder_bg },
    -- NvimTreeFolderName = { fg = colors.folder_bg },
    -- NvimTreeGitDirty = { fg = colors.red },
    -- NvimTreeIndentMarker = { fg = colors.grey_fg },
    -- NvimTreeNormal = { bg = colors.darker_black },
    -- NvimTreeNormalNC = { bg = colors.darker_black },
    -- NvimTreeOpenedFolderName = { fg = colors.folder_bg },
    -- NvimTreeGitIgnored = { fg = colors.light_grey },
    -- NvimTreeWinSeparator = { fg = colors.darker_black, bg = colors.darker_black, },
    -- NvimTreeWindowPicker = { fg = colors.red, bg = colors.black2, },
    -- NvimTreeCursorLine = { bg = colors.black2, },
    -- NvimTreeGitNew = { fg = colors.yellow, },
    -- NvimTreeGitDeleted = { fg = colors.red, },
    -- NvimTreeSpecialFile = { fg = colors.yellow, bold = true, },
    -- NvimTreeRootFolder = { fg = colors.red, bold = true, },

    -- Neo Tree
    -- NvimTreeEmptyFolderName = { fg = colors.folder_bg },
    NeoTreeEndOfBuffer = { fg = colors.darker_black },
    NeoTreeDirectoryIcon = { fg = colors.folder_bg },
    NeoTreeDirectoryName = { fg = colors.folder_bg },
    NeoTreeGitConflict = { fg = colors.red },
    NeoTreeIndentMarker = { fg = colors.grey_fg },
    NeoTreeNormal = { bg = colors.darker_black },
    NeoTreeNormalNC = { bg = colors.darker_black },
    -- NvimTreeOpenedFolderName = { fg = colors.folder_bg },
    NeoTreeGitIgnored = { fg = colors.light_grey },
    NeoTreeWinSeparator = { fg = colors.darker_black, bg = colors.darker_black },
    -- NvimTreeWindowPicker = { fg = colors.red, bg = colors.black2, },
    NeoTreeCursorLine = { bg = colors.black2 },
    NeoTreeGitAdded = { fg = colors.yellow },
    NeoTreeGitDeleted = { fg = colors.red },
    -- NvimTreeSpecialFile = { fg = colors.yellow, bold = true, },
    NeoTreeRootName = { fg = colors.red, bold = true },

    -- Cmp
    CmpItemAbbr = { fg = colors.white },
    CmpItemAbbrMatch = { fg = colors.blue, bold = true },
    CmpDocBorder = { fg = colors.darker_black, bg = colors.darker_black },
    CmpPmenu = { bg = colors.one_bg },
    CmpSel = { link = 'PmenuSel', bold = true },
    CmpBorder = { fg = colors.grey_fg },
    -- cmp item kinds
    CmpItemKindConstant = { fg = theme.base09 },
    CmpItemKindFunction = { fg = theme.base0D },
    CmpItemKindIdentifier = { fg = theme.base08 },
    CmpItemKindField = { fg = theme.base08 },
    CmpItemKindVariable = { fg = theme.base0E },
    CmpItemKindSnippet = { fg = colors.red },
    CmpItemKindText = { fg = theme.base0B },
    CmpItemKindStructure = { fg = theme.base0E },
    CmpItemKindType = { fg = theme.base0A },
    CmpItemKindKeyword = { fg = theme.base07 },
    CmpItemKindMethod = { fg = theme.base0D },
    CmpItemKindConstructor = { fg = colors.blue },
    CmpItemKindFolder = { fg = theme.base07 },
    CmpItemKindModule = { fg = theme.base0A },
    CmpItemKindProperty = { fg = theme.base08 },
    CmpItemKindEnum = { fg = colors.blue },
    CmpItemKindUnit = { fg = theme.base0E },
    CmpItemKindClass = { fg = colors.teal },
    CmpItemKindFile = { fg = theme.base07 },
    CmpItemKindInterface = { fg = colors.green },
    CmpItemKindColor = { fg = colors.white },
    CmpItemKindReference = { fg = theme.base05 },
    CmpItemKindEnumMember = { fg = colors.purple },
    CmpItemKindStruct = { fg = theme.base0E },
    CmpItemKindValue = { fg = colors.cyan },
    CmpItemKindEvent = { fg = colors.yellow },
    CmpItemKindOperator = { fg = theme.base05 },
    CmpItemKindTypeParameter = { fg = theme.base08 },
    CmpItemKindCopilot = { fg = colors.green },

    -- Cmp item icon
    CmpItemKindConstantIcon = { fg = theme.base09, bg = util.blend(theme.base09, colors.one_bg, 0.15) },
    CmpItemKindFunctionIcon = { fg = theme.base0D, bg = util.blend(theme.base0D, colors.one_bg, 0.15) },
    CmpItemKindIdentifierIcon = { fg = theme.base08, bg = util.blend(theme.base08, colors.one_bg, 0.15) },
    CmpItemKindFieldIcon = { fg = theme.base08, bg = util.blend(theme.base08, colors.one_bg, 0.15) },
    CmpItemKindVariableIcon = { fg = theme.base0E, bg = util.blend(theme.base0E, colors.one_bg, 0.15) },
    CmpItemKindSnippetIcon = { fg = colors.red, bg = util.blend(colors.red, colors.one_bg, 0.15) },
    CmpItemKindTextIcon = { fg = theme.base0B, bg = util.blend(theme.base0B, colors.one_bg, 0.15) },
    CmpItemKindStructureIcon = { fg = theme.base0E, bg = util.blend(theme.base0E, colors.one_bg, 0.15) },
    CmpItemKindTypeIcon = { fg = theme.base0A, bg = util.blend(theme.base0A, colors.one_bg, 0.15) },
    CmpItemKindKeywordIcon = { fg = theme.base07, bg = util.blend(theme.base07, colors.one_bg, 0.15) },
    CmpItemKindMethodIcon = { fg = theme.base0D, bg = util.blend(theme.base0D, colors.one_bg, 0.15) },
    CmpItemKindConstructorIcon = { fg = colors.blue, bg = util.blend(colors.blue, colors.one_bg, 0.15) },
    CmpItemKindFolderIcon = { fg = theme.base07, bg = util.blend(theme.base07, colors.one_bg, 0.15) },
    CmpItemKindModuleIcon = { fg = theme.base0A, bg = util.blend(theme.base0A, colors.one_bg, 0.15) },
    CmpItemKindPropertyIcon = { fg = theme.base08, bg = util.blend(theme.base08, colors.one_bg, 0.15) },
    CmpItemKindEnumIcon = { fg = colors.blue, bg = util.blend(colors.blue, colors.one_bg, 0.15) },
    CmpItemKindUnitIcon = { fg = theme.base0E, bg = util.blend(theme.base0E, colors.one_bg, 0.15) },
    CmpItemKindClassIcon = { fg = colors.teal, bg = util.blend(colors.teal, colors.one_bg, 0.15) },
    CmpItemKindFileIcon = { fg = theme.base07, bg = util.blend(theme.base07, colors.one_bg, 0.15) },
    CmpItemKindInterfaceIcon = { fg = colors.green, bg = util.blend(colors.green, colors.one_bg, 0.15) },
    CmpItemKindColorIcon = { fg = colors.white, bg = util.blend(colors.white, colors.one_bg, 0.15) },
    CmpItemKindReferenceIcon = { fg = theme.base05, bg = util.blend(theme.base05, colors.one_bg, 0.15) },
    CmpItemKindEnumMemberIcon = { fg = colors.purple, bg = util.blend(colors.purple, colors.one_bg, 0.15) },
    CmpItemKindStructIcon = { fg = theme.base0E, bg = util.blend(theme.base0E, colors.one_bg, 0.15) },
    CmpItemKindValueIcon = { fg = colors.cyan, bg = util.blend(colors.cyan, colors.one_bg, 0.15) },
    CmpItemKindEventIcon = { fg = colors.yellow, bg = util.blend(colors.yellow, colors.one_bg, 0.15) },
    CmpItemKindOperatorIcon = { fg = theme.base05, bg = util.blend(theme.base05, colors.one_bg, 0.15) },
    CmpItemKindTypeParameterIcon = { fg = theme.base08, bg = util.blend(theme.base08, colors.one_bg, 0.15) },
    CmpItemKindCopilotIcon = { fg = colors.green, bg = util.blend(colors.green, colors.one_bg, 0.15) },

    -- Devicon
    DevIconDefault = { fg = colors.red },
    DevIconc = { fg = colors.blue },
    DevIconcss = { fg = colors.blue },
    DevIcondeb = { fg = colors.cyan },
    DevIconDockerfile = { fg = colors.cyan },
    DevIconhtml = { fg = colors.baby_pink },
    DevIconjpeg = { fg = colors.dark_purple },
    DevIconjpg = { fg = colors.dark_purple },
    DevIconjs = { fg = colors.sun },
    DevIconkt = { fg = colors.orange },
    DevIconlock = { fg = colors.red },
    DevIconlua = { fg = colors.blue },
    DevIconmp3 = { fg = colors.white },
    DevIconmp4 = { fg = colors.white },
    DevIconout = { fg = colors.white },
    DevIconpng = { fg = colors.dark_purple },
    DevIconpy = { fg = colors.cyan },
    DevIcontoml = { fg = colors.blue },
    DevIconts = { fg = colors.teal },
    DevIconttf = { fg = colors.white },
    DevIconrb = { fg = colors.pink },
    DevIconrpm = { fg = colors.orange },
    DevIconvue = { fg = colors.vibrant_green },
    DevIconwoff = { fg = colors.white },
    DevIconwoff2 = { fg = colors.white },
    DevIconxz = { fg = colors.sun },
    DevIconzip = { fg = colors.sun },
    DevIconZig = { fg = colors.orange },
    DevIconMd = { fg = colors.blue },
    DevIconTSX = { fg = colors.blue },

    -- Git
    DiffAdd = { fg = colors.blue },
    DiffAdded = { fg = colors.green },
    DiffChange = { fg = colors.light_grey },
    DiffChangeDelete = { fg = colors.red },
    DiffModified = { fg = colors.orange },
    DiffDelete = { fg = colors.red },
    DiffRemoved = { fg = colors.red },
    DiffText = { fg = colors.white, bg = colors.black2 },

    -- git commits
    gitcommitOverflow = { fg = theme.base08 },
    gitcommitSummary = { fg = theme.base08 },
    gitcommitComment = { fg = theme.base03 },
    gitcommitUntracked = { fg = theme.base03 },
    gitcommitDiscarded = { fg = theme.base03 },
    gitcommitSelected = { fg = theme.base03 },
    gitcommitHeader = { fg = theme.base0E },
    gitcommitSelectedType = { fg = theme.base0D },
    gitcommitUnmergedType = { fg = theme.base0D },
    gitcommitDiscardedType = { fg = theme.base0D },
    gitcommitBranch = { fg = theme.base09, bold = true },
    gitcommitUntrackedFile = { fg = theme.base0A },
    gitcommitUnmergedFile = { fg = theme.base08, bold = true },
    gitcommitDiscardedFile = { fg = theme.base08, bold = true },
    gitcommitSelectedFile = { fg = theme.base0B, bold = true },

    -- Git Sign
    GitSignsAddNr = { fg = colors.green, bg = util.blend(colors.green, colors.grey, 0.10) },
    GitSignsChangeNr = { fg = colors.light_grey, bg = util.blend(colors.light_grey, colors.grey, 0.10) },
    GitSignsDeleteNr = { fg = colors.red, bg = util.blend(colors.red, colors.grey, 0.10) },
    GitSignsAddLn = { bg = util.blend(colors.green, colors.grey, 0.05) },
    GitSignsChangeLn = { bg = util.blend(colors.light_grey, colors.grey, 0.05) },
    GitSignsDeleteLn = { bg = util.blend(colors.red, colors.grey, 0.05) },
    GitSignsAddInline = { bg = util.blend(colors.green, colors.grey, 0.35) },
    GitSignsChangeInline = { bg = util.blend(colors.light_grey, colors.grey, 0.35) },
    GitSignsDeleteInline = { bg = util.blend(colors.red, colors.grey, 0.35) },
    GitSignsAddPreview = { bg = util.blend(colors.green, colors.grey, 0.10) },
    GitSignsDeletePreview = { bg = util.blend(colors.red, colors.grey, 0.10) },

    -- LSP References
    LspReferenceText = { fg = colors.darker_black, bg = colors.white },
    LspReferenceRead = { fg = colors.darker_black, bg = colors.white },
    LspReferenceWrite = { fg = colors.darker_black, bg = colors.white },
    -- Lsp Diagnostics
    DiagnosticHint = { fg = colors.purple },
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInformation = { fg = colors.green },
    LspSignatureActiveParameter = { fg = colors.black, bg = colors.green },

    -- Mason
    MasonHeader = { bg = colors.red, fg = colors.black },
    MasonHighlight = { fg = colors.blue },
    MasonHighlightBlock = { fg = colors.black, bg = colors.green },
    MasonHighlightBlockBold = { link = 'MasonHighlightBlock' },
    MasonHeaderSecondary = { link = 'MasonHighlightBlock' },
    MasonMuted = { fg = colors.light_grey },
    MasonMutedBlock = { fg = colors.light_grey, bg = colors.one_bg },

    -- Mini Starter
    MiniStarterFooter = { fg = colors.grey_fg },
    MiniStarterHeader = { fg = colors.red },

    -- Alpha
    -- AlphaHeader = { fg = colors.grey_fg },
    -- AlphaButtons = { fg = colors.light_grey },

    -- Telescope
    TelescopeNormal = { bg = colors.darker_black },
    TelescopePreviewTitle = { fg = colors.black, bg = colors.green },
    TelescopePromptTitle = { fg = colors.black, bg = colors.red },
    TelescopeSelection = { bg = colors.black2, fg = colors.white },
    TelescopeResultsDiffAdd = { fg = colors.green },
    TelescopeResultsDiffChange = { fg = colors.yellow },
    TelescopeResultsDiffDelete = { fg = colors.red },
    TelescopeBorder = { fg = colors.darker_black, bg = colors.darker_black },
    TelescopePromptBorder = { fg = colors.black2, bg = colors.black2 },
    TelescopePromptNormal = { fg = colors.white, bg = colors.black2 },
    TelescopeResultsTitle = { fg = colors.darker_black, bg = colors.darker_black },
    TelescopePromptPrefix = { fg = colors.red, bg = colors.black2 },

    -- StatusLine
    StatusLine = { bg = colors.statusline_bg },
    -- Modes
    StatusLineNormal = { bg = colors.nord_blue, fg = colors.black, bold = true },
    StatusLineInsert = { bg = colors.green, fg = colors.black, bold = true },
    StatusLineVisual = { bg = colors.cyan, fg = colors.black, bold = true },
    StatusLineReplace = { bg = colors.orange, fg = colors.black, bold = true },
    StatusLineSelect = { bg = colors.blue, fg = colors.black, bold = true },
    StatusLineCommand = { bg = colors.dark_purple, fg = colors.black, bold = true },
    StatusLineTerminal = { bg = colors.dark_purple, fg = colors.black, bold = true },
    StatusLineNormalSep = { fg = colors.nord_blue, bg = colors.one_bg3, bold = true },
    StatusLineInsertSep = { fg = colors.green, bg = colors.one_bg3, bold = true },
    StatusLineVisualSep = { fg = colors.cyan, bg = colors.one_bg3, bold = true },
    StatusLineReplaceSep = { fg = colors.orange, bg = colors.one_bg3, bold = true },
    StatusLineSelectSep = { fg = colors.blue, bg = colors.one_bg3, bold = true },
    StatusLineCommandSep = { fg = colors.dark_purple, bg = colors.one_bg3, bold = true },
    StatusLineTerminalSep = { fg = colors.dark_purple, bg = colors.one_bg3, bold = true },

    StatusLinePath = { bg = colors.one_bg3, fg = colors.cyan },
    StatusLinePathSep = { bg = colors.one_bg3, fg = colors.orange },
    StatusLinePathArrow = { fg = colors.one_bg3, bg = colors.lightbg },
    StatusLineFileName = { bg = colors.lightbg, fg = colors.white },
    StatusLineFileArrow = { fg = colors.lightbg, bg = colors.statusline_bg },
    StatusLineLineCol = { bg = colors.lightbg, fg = colors.green },
    StatusLineLines = { bg = colors.one_bg3, fg = colors.white, bold = true },
    StatusLineLinesArrow = { fg = colors.one_bg3, bg = colors.lightbg, bold = true },
    StatusLineColArrow = { fg = colors.lightbg, bg = colors.statusline_bg },
    StatusLineEmptySpace = { fg = colors.grey, bg = colors.statusline_bg },
    StatusLineLsp = { fg = colors.nord_blue, bg = colors.statusline_bg },
    StatusLineGitBranch = { fg = colors.light_grey, bg = colors.statusline_bg, bold = true },
    StatusLineGitAdd = { fg = colors.green, bg = colors.statusline_bg },
    StatusLineGitChange = { fg = colors.light_grey, bg = colors.statusline_bg },
    StatusLineGitDelete = { fg = colors.red, bg = colors.statusline_bg },
    StatusLineDiagError = { fg = colors.red, bg = colors.statusline_bg },
    StatusLineDiagWarn = { fg = colors.yellow, bg = colors.statusline_bg },
    StatusLineDiagHint = { fg = colors.purple, bg = colors.statusline_bg },
    StatusLineDiagInfo = { fg = colors.green, bg = colors.statusline_bg },
    StatusLineNoice = { link = 'Statement' },

    -- Notify
    NotifyERRORBorder = { fg = colors.red },
    NotifyERRORIcon = { fg = colors.red },
    NotifyERRORTitle = { fg = colors.red },
    NotifyWARNBorder = { fg = colors.orange },
    NotifyWARNIcon = { fg = colors.orange },
    NotifyWARNTitle = { fg = colors.orange },
    NotifyINFOBorder = { fg = colors.green },
    NotifyINFOIcon = { fg = colors.green },
    NotifyINFOTitle = { fg = colors.green },
    NotifyDEBUGBorder = { fg = colors.grey },
    NotifyDEBUGIcon = { fg = colors.grey },
    NotifyDEBUGTitle = { fg = colors.grey },
    NotifyTRACEBorder = { fg = colors.purple },
    NotifyTRACEIcon = { fg = colors.purple },
    NotifyTRACETitle = { fg = colors.purple },

    -- ts-rainbow2 (maintained fork)
    TSRainbowRed = { fg = colors.red },
    TSRainbowOrange = { fg = colors.orange },
    TSRainbowYellow = { fg = colors.yellow },
    TSRainbowGreen = { fg = colors.green },
    TSRainbowBlue = { fg = colors.blue },
    TSRainbowViolet = { fg = colors.purple },
    TSRainbowCyan = { fg = colors.cyan },

    -- LspTrouble
    TroubleNormal = { bg = colors.darker_black },

    -- Illuminate
    illuminatedWord = { bg = colors.one_bg2 },
    illuminatedCurWord = { bg = colors.one_bg2 },
    IlluminatedWordText = { bg = colors.one_bg2 },
    IlluminatedWordRead = { bg = colors.one_bg2 },
    IlluminatedWordWrite = { bg = colors.one_bg2 },

    -- WhichKey
    WhichKey = { fg = colors.blue },
    WhichKeySeparator = { fg = colors.light_grey },
    WhichKeyDesc = { fg = colors.red },
    WhichKeyGroup = { fg = colors.green },
    WhichKeyValue = { fg = colors.green },

    -- Quickfix
    qfPosition = { link = 'String' },
    BqfPreviewBorder = { link = 'Comment' },

    -- Portal
    PortalNormal = { link = 'Normal' },
    PortalBorder = { link = 'Label' },
    PortalTitle = { link = 'Label' },
  }
end

M.setup = function()
  local colors_path = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h')
  local hl_files = colors_path .. '/colors'
  local themes = vim.fn.readdir(hl_files)
  math.randomseed(os.time())
  local ind = math.random(1, #themes)
  local selected_theme = themes[ind]
  local colorscheme = vim.fn.fnamemodify(selected_theme, ':r')

  local compiled_theme = vim.fn.stdpath('cache') .. '/compiled_theme_' .. selected_theme
  vim.g.colors_name = colorscheme

  if vim.loop.fs_stat(compiled_theme) then
    dofile(compiled_theme)
    vim.notify('Theme: ' .. colorscheme)
  else
    require('themes').compile(selected_theme, true)
  end
end

return M
