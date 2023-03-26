return {
  {
    'uga-rosa/ccc.nvim',
    cmd = { 'CccPick', 'CccHighlighterEnable', 'CccConvert' },
    opts = {
      highlighter = {
        auto_enable = true,
        excludes = { 'dart' },
      },
    },
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', '<Plug>(dial-increment)', mode = 'n' },
      { '<C-x>', '<Plug>(dial-decrement)', mode = 'n' },
      { '<C-a>', '<Plug>(dial-increment)', mode = 'v' },
      { '<C-x>', '<Plug>(dial-decrement)', mode = 'v' },
      { 'g<C-a>', 'g<Plug>(dial-increment)', mode = 'v' },
      { 'g<C-x>', 'g<Plug>(dial-decrement)', mode = 'v' },
    },
    config = function()
      local augend = require('dial.augend')
      local config = require('dial.config')

      local casing = augend.case.new({
        types = { 'camelCase', 'snake_case', 'PascalCase', 'SCREAMING_SNAKE_CASE' },
        cyclic = true,
      })

      config.augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          casing,
        },
      })

      config.augends:on_filetype({
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.constant.new({ elements = { 'let', 'const' } }),
          casing,
        },
        markdown = {
          augend.integer.alias.decimal,
          augend.misc.alias.markdown_header,
        },
        yaml = {
          augend.semver.alias.semver,
        },
        toml = {
          augend.semver.alias.semver,
        },
      })
    end,
  },
  {
    'gbprod/substitute.nvim',
    config = true,
    keys = {
      { 'S', function() require('substitute').visual() end, mode = 'x' },
      { 'S', function() require('substitute').operator() end, mode = 'n' },
      { 'X', function() require('substitute.exchange').operator() end, mode = 'n' },
      { 'X', function() require('substitute.exchange').visual() end, mode = 'x' },
      { 'Xc', function() require('substitute.exchange').cancel() end, mode = { 'n', 'x' } },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    keys = {
      { '<C-n>', '<leader>fE', desc = 'Explorer NeoTree (root dir)', remap = true },
    },
    opts = {
      window = {
        mappings = { o = 'toggle_node', ['<CR>'] = 'open', ['<c-s>'] = 'open_split', ['<c-v>'] = 'open_vsplit' },
      },
      nesting_rules = {
        ['dart'] = { 'freezed.dart', 'g.dart' },
        ['json'] = { 'package.json', 'package-lock.json', 'bower.json', 'firebase.json', 'package.nls*.json' },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signcolumn = false,
      numhl = true,
    },
  },
  {
    'numToStr/FTerm.nvim',
    opts = { hl = 'NormalFloat', dimensions = { height = 0.4, width = 0.9 } },
    keys = {
      { '<A-t>', function() require('FTerm').toggle() end, desc = 'Toggle Terminal' },
      { '<A-t>', function() require('FTerm').toggle() end, desc = 'Toggle Terminal', mode = 't' },
    },
  },
  {
    'RRethy/vim-illuminate',
    opts = { delay = 200, large_file_cutoff = 5000 },
  },
  {
    'cbochs/portal.nvim',
    cmd = { 'Portal' },
    keys = {
      { '<leader>jb', '<cmd>Portal jumplist backward<cr>', desc = 'jump: backwards' },
      { '<leader>jf', '<cmd>Portal jumplist forward<cr>', desc = 'jump: forwards' },
    },
    config = function()
      local function different_portals()
        local found = {}
        return function(content)
          local buf = content.buffer
          if buf == vim.api.nvim_get_current_buf() then return false end
          if not vim.startswith(vim.api.nvim_buf_get_name(buf), vim.fn.getcwd()) then return false end
          if vim.tbl_contains(found, buf) then return false end
          table.insert(found, buf)
          return true
        end
      end
      require('portal').setup({ filter = different_portals() })
    end,
  },
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  {
    url = 'https://gitlab.com/yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    config = true,
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },
}
