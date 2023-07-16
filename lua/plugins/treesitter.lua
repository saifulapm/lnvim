local function ts_disable(bufnr) return vim.api.nvim_buf_line_count(bufnr) > 5000 end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    keys = function() return {} end,
    opts = {
      ensure_installed = {
        'html',
        'javascript',
        'json',
        'luap',
        'markdown',
        'markdown_inline',
        'php',
        'dart',
        'tsx',
        'typescript',
        'vim',
        'vue',
        'bash',
        'c',
        'lua',
        'luadoc',
        'python',
        'query',
        'regex',
        'vimdoc',
        'yaml',
      },
      highlight = {
        enable = true,
        disable = function(_, bufnr) return ts_disable(bufnr) end,
      },
      incremental_selection = {
        enable = true,
        disable = function(_, bufnr) return ts_disable(bufnr) end,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<nop>',
          node_decremental = '<bs>',
        },
      },
      context_commentstring = {
        enable = false,
        disable = function(_, bufnr) return ts_disable(bufnr) end,
        enable_autocmd = false,
      },
      indent = {
        enable = true,
        disable = function(lang, bufnr) return lang == 'python' or ts_disable(bufnr) end,
      },
    },
  },
  {
    'Wansmer/treesj',
    opts = { use_default_keymaps = false },
    keys = {
      { 'gS', '<Cmd>TSJSplit<CR>', desc = 'split expression to multiple lines' },
      { 'gJ', '<Cmd>TSJJoin<CR>', desc = 'join expression to single line' },
    },
  },
  {
    'Wansmer/sibling-swap.nvim',
    keys = { '<C-,>', '<C-.>' },
    opts = {
      use_default_keymaps = true,
      keymaps = {
        ['<C-,>'] = 'swap_with_left',
        ['<C-.>'] = 'swap_with_right',
      },
    },
  },
  {
    'cshuaimin/ssr.nvim',
    keys = {
      {
        '<leader>sR',
        function() require('ssr').open() end,
        mode = { 'n', 'x' },
        desc = 'structured search and replace',
      },
    },
  },
}
