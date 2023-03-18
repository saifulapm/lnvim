local M ={}

M.load_colors = function(type)
  local name = vim.g.colors_name ~= nil and vim.g.colors_name or "default"
  local colors = require('themes.colors.' .. name)

  return colors[type]
end

-- convert table into string
M.table_to_str = function(tb)
  local result = ""

  for hlgroupName, hlgroup_vals in pairs(tb) do
    local hlname = "'" .. hlgroupName .. "',"
    local opts = ""

    for optName, optVal in pairs(hlgroup_vals) do
      local valueInStr = ((type(optVal)) == "boolean" or type(optVal) == "number") and tostring(optVal)
        or '"' .. optVal .. '"'
      opts = opts .. optName .. "=" .. valueInStr .. ","
    end

    result = result .. "vim.api.nvim_set_hl(0," .. hlname .. "{" .. opts .. "})"
  end

  return result
end

M.compile = function ()
  local dir = vim.fn.stdpath "cache"
  if not vim.loop.fs_stat(dir) then
    vim.fn.mkdir(dir, "p")
  end

  local highlights = M.load_highlights()
  local bg_opt = "vim.opt.bg='" .. M.load_colors("type") .. "'"
  local lines = "return string.dump(function()" .. bg_opt .. M.table_to_str(highlights) .. "end, true)"
  local file = io.open(vim.fn.stdpath("cache") .. "/compiled_theme.lua", "wb")
  if file then
    file:write(load(lines)())
    file:close()
    dofile(vim.fn.stdpath("cache") .. "/compiled_theme.lua")
    vim.notify('Theme compiled successfully')
  end
end

M.load_highlights = function()
  local polish_hl = M.load_colors('polish_hl')
  local highlights = M.highlights()

  -- polish themes
  if polish_hl then
    for key, value in pairs(polish_hl) do
      if highlights[key] then
        highlights[key] = vim.tbl_deep_extend("force", highlights[key], value)
      end
    end
  end

  -- transparency
  if vim.g.transparency then
    local glassy = M.glassy_highlights()

    for key, value in pairs(glassy) do
      if highlights[key] then
        highlights[key] = M.merge_tb(highlights[key], value)
      end
    end
  end

  return highlights
end

M.glassy_highlights = function()
  local colors = M.load_colors('base_30')

  return {
    NvimTreeWinSeparator = { fg = colors.one_bg2, bg = "NONE", },
    TelescopeResultsTitle = { fg = colors.black, bg = colors.blue, },
    TelescopeBorder = { fg = colors.grey, bg = "NONE", },
    TelescopePromptBorder = { fg = colors.grey, bg = "NONE", },
    NormalFloat = { bg = "NONE" },
    Normal = { bg = "NONE" },
    Folded = { bg = "NONE" },
    NvimTreeNormal = { bg = "NONE" },
    NvimTreeNormalNC = { bg = "NONE" },
    NvimTreeCursorLine = { bg = "NONE" },
    TelescopeNormal = { bg = "NONE" },
    TelescopePrompt = { bg = "NONE" },
    TelescopeResults = { bg = "NONE" },
    TelescopePromptNormal = { bg = "NONE" },
    TelescopePromptPrefix = { bg = "NONE" },
    CursorLine = { bg = "NONE" },
    Pmenu = { bg = "NONE" },
  }
end

M.highlights = function()
  local colors = M.load_colors('base_30')
  local theme = M.load_colors('base_16')
  local util = require('utils.color')

  -- defaults
  return {
    Normal = { fg = theme.base05, bg = theme.base00, },
    Bold = { bold = true, },
    Debug = { fg = theme.base08, },
    Directory = { fg = theme.base0D, },
    Error = { fg = theme.base00, bg = theme.base08, },
    ErrorMsg = { fg = theme.base08, bg = theme.base00, },
    Exception = { fg = theme.base08, },
    FoldColumn = { fg = theme.base0C, bg = theme.base01, },
    Folded = { fg = theme.base03, bg = theme.base01, },
    IncSearch = { fg = theme.base01, bg = theme.base09, },
    Italic = { italic = true, },
    Macro = { fg = theme.base08, },
    ModeMsg = { fg = theme.base0B, },
    MoreMsg = { fg = theme.base0B, },
    Question = { fg = theme.base0D, },
    Search = { fg = theme.base01, bg = theme.base0A, },
    Substitute = { fg = theme.base01, bg = theme.base0A, sp = "none", },
    SpecialKey = { fg = theme.base03, },
    TooLong = { fg = theme.base08, },
    UnderLined = { fg = theme.base0B, },
    Visual = { bg = theme.base02, },
    VisualNOS = { fg = theme.base08, },
    WarningMsg = { fg = theme.base08, },
    WildMenu = { fg = theme.base08, bg = theme.base0A, },
    Title = { fg = theme.base0D, sp = "none", },
    Conceal = { bg = "NONE", },
    Cursor = { fg = theme.base00, bg = theme.base05, },
    NonText = { fg = theme.base03, },
    SignColumn = { fg = theme.base03, sp = "NONE", },
    ColorColumn = { bg = theme.base01, sp = "none", },
    CursorColumn = { bg = theme.base01, sp = "none", },
    CursorLine = { bg = "none", sp = "none", },
    QuickFixLine = { bg = theme.base01, sp = "none", },
    MatchWord = { bg = colors.grey, fg = colors.white, },
    Pmenu = { bg = colors.one_bg },
    PmenuSbar = { bg = colors.one_bg },
    PmenuSel = { bg = colors.pmenu_bg, fg = colors.black },
    PmenuThumb = { bg = colors.grey },
    MatchParen = { link = "MatchWord" },
    Comment = { fg = colors.grey_fg },
    CursorLineNr = { fg = colors.white },
    LineNr = { fg = colors.grey },

    -- floating windows
    FloatBorder = { fg = colors.blue },
    NormalFloat = { bg = colors.darker_black },
    NvimInternalError = { fg = colors.red },
    WinSeparator = { fg = colors.line },

    -- spell
    SpellBad = { undercurl = true, sp = theme.base08, },
    SpellLocal = { undercurl = true, sp = theme.base0C, },
    SpellCap = { undercurl = true, sp = theme.base0D, },
    SpellRare = { undercurl = true, sp = theme.base0E, },
    healthSuccess = { bg = colors.green, fg = colors.black, },

    -- lazy.nvim
    LazyH1 = { bg = colors.green, fg = colors.black, },
    LazyButton = { bg = colors.one_bg, fg = util.change_hex_lightness(colors.light_grey, vim.o.bg == "dark" and 10 or -20), },
    LazyH2 = { fg = colors.red, bold = true, underline = true, },
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
    Boolean = { fg = theme.base09, },
    Character = { fg = theme.base08, },
    Conditional = { fg = theme.base0E, },
    Constant = { fg = theme.base08, },
    Define = { fg = theme.base0E, sp = "none", },
    Delimiter = { fg = theme.base0F, },
    Float = { fg = theme.base09, },
    Variable = { fg = theme.base05, },
    Function = { fg = theme.base0D, },
    Identifier = { fg = theme.base08, sp = "none", },
    Include = { fg = theme.base0D, },
    Keyword = { fg = theme.base0E, },
    Label = { fg = theme.base0A, },
    Number = { fg = theme.base09, },
    Operator = { fg = theme.base05, sp = "none", },
    PreProc = { fg = theme.base0A, },
    Repeat = { fg = theme.base0A, },
    Special = { fg = theme.base0C, },
    SpecialChar = { fg = theme.base0F, },
    Statement = { fg = theme.base08, },
    StorageClass = { fg = theme.base0A, },
    String = { fg = theme.base0B, },
    Structure = { fg = theme.base0E, },
    Tag = { fg = theme.base0A, },
    Todo = { fg = theme.base0A, bg = theme.base01, },
    Type = { fg = theme.base0A, sp = "none", },
    Typedef = { fg = theme.base0A, },
    -- Lsp Semantic hls
    ["@lsp.type.class"] = { fg = theme.base0E },
    ["@lsp.type.decorator"] = { fg = theme.base08 },
    ["@lsp.type.enum"] = { fg = theme.base0A },
    ["@lsp.type.enumMember"] = { fg = theme.base08 },
    ["@lsp.type.function"] = { fg = theme.base0D },
    ["@lsp.type.interface"] = { fg = theme.base08 },
    ["@lsp.type.macro"] = { fg = theme.base08 },
    ["@lsp.type.method"] = { fg = theme.base0D },
    ["@lsp.type.namespace"] = { fg = theme.base08 },
    ["@lsp.type.parameter"] = { fg = theme.base08 },
    ["@lsp.type.property"] = { fg = theme.base08 },
    ["@lsp.type.struct"] = { fg = theme.base0E },
    ["@lsp.type.type"] = { fg = theme.base0A },
    ["@lsp.type.typeParamater"] = { fg = theme.base0A },
    ["@lsp.type.variable"] = { fg = theme.base05 },
    -- ["@event"] = { fg = theme.base08 },
    -- ["@modifier"] = { fg = theme.base08 },
    -- ["@regexp"] = { fg = theme.base0F },

    -- Treesitter
    -- `@annotation` is not one of the default capture group, should we keep it
    ["@annotation"] = { fg = theme.base0F, },
    ["@attribute"] = { fg = theme.base0A, },
    ["@character"] = { fg = theme.base08, },
    ["@constructor"] = { fg = theme.base0C, },
    ["@constant"] = { fg = theme.base08, },
    ["@constant.builtin"] = { fg = theme.base09, },
    ["@constant.macro"] = { fg = theme.base08, },
    ["@error"] = { fg = theme.base08, },
    ["@exception"] = { fg = theme.base08, },
    ["@float"] = { fg = theme.base09, },
    ["@keyword"] = { fg = theme.base0E, },
    ["@keyword.function"] = { fg = theme.base0E, },
    ["@keyword.return"] = { fg = theme.base0E, },
    ["@function"] = { fg = theme.base0D, },
    ["@function.builtin"] = { fg = theme.base0D, },
    ["@function.macro"] = { fg = theme.base08, },
    ["@function.call"] = { fg = theme.base0D, },
    ["@operator"] = { fg = theme.base05, },
    ["@keyword.operator"] = { fg = theme.base0E, },
    ["@method"] = { fg = theme.base0D, },
    ["@method.call"] = { fg = theme.base0D, },
    ["@namespace"] = { fg = theme.base08, },
    ["@none"] = { fg = theme.base05, },
    ["@parameter"] = { fg = theme.base08, },
    ["@reference"] = { fg = theme.base05, },
    ["@punctuation.bracket"] = { fg = theme.base0F, },
    ["@punctuation.delimiter"] = { fg = theme.base0F, },
    ["@punctuation.special"] = { fg = theme.base08, },
    ["@string"] = { fg = theme.base0B, },
    ["@string.regex"] = { fg = theme.base0C, },
    ["@string.escape"] = { fg = theme.base0C, },
    ["@string.special"] = { fg = theme.base0C, },
    ["@symbol"] = { fg = theme.base0B, },
    ["@tag"] = { link = "Tag", },
    ["@tag.attribute"] = { link = "@property", },
    ["@tag.delimiter"] = { fg = theme.base0F, },
    ["@text"] = { fg = theme.base05, },
    ["@text.strong"] = { bold = true, },
    ["@text.emphasis"] = { fg = theme.base09, },
    ["@text.strike"] = { fg = theme.base0F, strikethrough = true, },
    ["@text.literal"] = { fg = theme.base09, },
    ["@text.uri"] = { fg = theme.base09, underline = true, },
    ["@type.builtin"] = { fg = theme.base0A, },
    ["@variable"] = { fg = theme.base05, },
    ["@variable.builtin"] = { fg = theme.base09, },
    ["@definition"] = { sp = theme.base04, underline = true, },
    TSDefinitionUsage = { sp = theme.base04, underline = true, },
    ["@scope"] = { bold = true, },
    ["@field"] = { fg = theme.base08, },
    ["@field.key"] = { fg = theme.base08, },
    ["@property"] = { fg = theme.base08, },
    ["@include"] = { link = "Include", },
    ["@conditional"] = { link = "Conditional", },

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

    -- Cmp
    CmpItemAbbr = { fg = colors.white },
    CmpItemAbbrMatch = { fg = colors.blue, bold = true },
    CmpDocBorder = { fg = colors.darker_black, bg = colors.darker_black },
    CmpPmenu = { bg = colors.black },
    CmpSel = { link = "PmenuSel", bold = true },
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
    DevIconMd = {fg = colors.blue},
    DevIconTSX = {fg = colors.blue},

    -- Git
    DiffAdd = { fg = colors.blue, },
    DiffAdded = { fg = colors.green, },
    DiffChange = { fg = colors.light_grey, },
    DiffChangeDelete = { fg = colors.red, },
    DiffModified = { fg = colors.orange, },
    DiffDelete = { fg = colors.red, },
    DiffRemoved = { fg = colors.red, },
    DiffText = { fg = colors.white, bg = colors.black2 },

    -- git commits
    gitcommitOverflow = { fg = theme.base08, },
    gitcommitSummary = { fg = theme.base08, },
    gitcommitComment = { fg = theme.base03, },
    gitcommitUntracked = { fg = theme.base03, },
    gitcommitDiscarded = { fg = theme.base03, },
    gitcommitSelected = { fg = theme.base03, },
    gitcommitHeader = { fg = theme.base0E, },
    gitcommitSelectedType = { fg = theme.base0D, },
    gitcommitUnmergedType = { fg = theme.base0D, },
    gitcommitDiscardedType = { fg = theme.base0D, },
    gitcommitBranch = { fg = theme.base09, bold = true, },
    gitcommitUntrackedFile = { fg = theme.base0A, },
    gitcommitUnmergedFile = { fg = theme.base08, bold = true, },
    gitcommitDiscardedFile = { fg = theme.base08, bold = true, },
    gitcommitSelectedFile = { fg = theme.base0B, bold = true, },

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
    MasonHighlightBlockBold = { link = "MasonHighlightBlock" },
    MasonHeaderSecondary = { link = "MasonHighlightBlock" },
    MasonMuted = { fg = colors.light_grey },
    MasonMutedBlock = { fg = colors.light_grey, bg = colors.one_bg },

    -- Telescope
    TelescopeNormal = { bg = colors.darker_black },
    TelescopePreviewTitle = { fg = colors.black, bg = colors.green, },
    TelescopePromptTitle = { fg = colors.black, bg = colors.red, },
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
  StatusLine = { bg = colors.statusline_bg, },
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

  StatusLineArrowLeft = { fg = colors.lightbg, bg = colors.statusline_bg, },

  StatusLinePath = { bg = colors.one_bg3, fg = colors.red, },
  StatusLinePathSep = { bg = colors.one_bg3, fg = colors.nord_blue, },
  StatusLinePathArrow = { fg = colors.one_bg3, bg = colors.lightbg },
  StatusLineFileName = { bg = colors.lightbg, fg = colors.white, },
  StatusLineFileArrow = { fg = colors.lightbg, bg = colors.statusline_bg, },
  StatusLineLineCol = { bg = colors.lightbg, fg = colors.green, },
  StatusLineLines = { bg = colors.one_bg3, fg = colors.white, bold  = true },
  StatusLineLinesArrow = { fg = colors.one_bg3, bg = colors.lightbg, bold  = true },

  StatusLineEmptySpace = { fg = colors.grey, bg = colors.statusline_bg, },
  StatusLineEmptySpace2 = {
    fg = colors.grey,
    bg = colors.lightbg,
  },


  -- St_cwd_icon = {
  --   fg = colors.one_bg,
  --   bg = colors.red,
  -- },

  -- St_cwd_text = {
  --   fg = colors.white,
  --   bg = colors.lightbg,
  -- },

  -- St_cwd_sep = {
  --   fg = colors.red,
  --   bg = colors.statusline_bg,
  -- },

  -- St_pos_sep = {
  --   fg = colors.green,
  --   bg = colors.lightbg,
  -- },

  -- St_pos_icon = {
  --   fg = colors.black,
  --   bg = colors.green,
  -- },

  -- St_pos_text = {
  --   fg = colors.green,
  --   bg = colors.lightbg,
  -- },
  }
end

M.setup = function(colorscheme)
  local NVIM_COLORSCHEME = os.getenv("NVIM_COLORSCHEME")
  if NVIM_COLORSCHEME then
    vim.g.colors_name = NVIM_COLORSCHEME
  else
    vim.g.colors_name = colorscheme
  end

  local compiled_theme = vim.fn.stdpath("cache") .. "/compiled_theme.lua"
  if vim.loop.fs_stat(compiled_theme) then
    dofile(compiled_theme)
  else
    require("themes").compile()
  end
end

return M
