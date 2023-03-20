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
    opts = {
      diagnostics = {
        underline = true,
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
    'akinsho/flutter-tools.nvim',
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
  },
}
