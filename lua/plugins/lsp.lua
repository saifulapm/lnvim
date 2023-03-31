local function trim(str)
  str = str:gsub('^%s*(.-)%s*$', '%1')

  if string.sub(str, -1, -1) == '.' then
    str = string.sub(str, 1, -2)
    str = str:gsub('^%s*(.-)%s*$', '%1')
  end

  return str
end

local with_root_file = function(...)
  local files = { ... }
  return function(utils) return utils.root_has_file(files) end
end

return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    init = function()
      local keys = require('lazyvim.plugins.lsp.keymaps').get()
      -- disable a keymap
      keys[#keys + 1] = { 'gD', false }
      keys[#keys + 1] = { 'gt', false }
      keys[#keys + 1] = { 'gy', '<cmd>Telescope lsp_type_definitions<cr>', desc = 'Goto Type Definition' }
    end,
    opts = {
      diagnostics = {
        underline = false,
        virtual_text = false,
        float = {
          format = function(diagnostic) return trim(diagnostic.message) end,
          prefix = function(diagnostic, i, total)
            local hl = 'Comment'
            local prefix = total > 1 and ('%d. '):format(i) or ''

            if diagnostic.source then prefix = ('%s%s: '):format(prefix, trim(diagnostic.source)) end

            return prefix, hl
          end,
        },
      },
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              environment = {
                phpVersion = '8.0.0',
              },
            },
          },
        },
        theme_check = {},
        svelte = {},
        cssls = {},
        rust_analyzer = {},
        tailwindcss = {},
        eslint = {
          settings = {
            format = false,
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = 'auto' },
          },
        },
        volar = {},
      },
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    opts = function()
      local nls = require('null-ls').builtins
      return {
        root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
        sources = {
          nls.formatting.prettierd.with({
            extra_filetypes = { 'svelte', 'liquid' },
          }),
          nls.formatting.phpcsfixer.with({
            condition = with_root_file('.php-cs-fixer.dist.php', '.php-cs-fixer.php'),
          }),
          nls.formatting.pint.with({
            condition = with_root_file('pint.json'),
          }),
          nls.formatting.stylua.with({
            condition = with_root_file('stylua.toml'),
          }),
        },
      }
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        'stylua',
        'prettierd',
        'php-cs-fixer',
        'pint',
      },
    },
  },
  {
    'lvimuser/lsp-inlayhints.nvim',
    opts = {
      inlay_hints = {
        highlight = 'Comment',
        labels_separator = ' ⏐ ',
        parameter_hints = { prefix = '' },
        type_hints = { prefix = '=> ', remove_colon_start = true },
      },
    },
  },
  {
    'akinsho/flutter-tools.nvim',
    ft = 'dart',
    event = 'BufRead pubspec.yaml',
    opts = {
      outline = { auto_open = false },
      widget_guides = { enabled = true, debug = false },
      dev_log = { enabled = false, open_cmd = 'tabedit' },
      lsp = {
        color = { enabled = true, background = true, virtual_text = false },
        settings = {
          showTodos = false,
          renameFilesWithClasses = 'prompt',
          updateImportsOnRename = true,
          completeFunctionCalls = true,
          lineLength = 100,
        },
      },
    },
    config = function(_, opts)
      require('flutter-tools').setup(opts)
      local ok, telescope = pcall(require, 'telescope')
      if ok and telescope.load_extension then
        telescope.load_extension('flutter')
        vim.keymap.set(
          { 'n' },
          '<LocalLeader>fl',
          function() telescope.extensions.flutter.commands() end,
          { silent = true, buffer = true, desc = 'Flutter Tools' }
        )
      end
    end,
  },
  {
    'DNLHC/glance.nvim',
    opts = {
      preview_win_opts = { relativenumber = false },
      theme = { enable = true, mode = 'darken' },
    },
    keys = {
      { 'gD', '<Cmd>Glance definitions<CR>', desc = 'lsp: glance definitions' },
      { 'gR', '<Cmd>Glance references<CR>', desc = 'lsp: glance references' },
      { 'gY', '<Cmd>Glance type_definitions<CR>', desc = 'lsp: glance type definitions' },
      { 'gM', '<Cmd>Glance implementations<CR>', desc = 'lsp: glance implementations' },
    },
  },
}
