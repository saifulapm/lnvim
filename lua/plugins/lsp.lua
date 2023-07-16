local function trim(str)
  str = str:gsub('^%s*(.-)%s*$', '%1')

  if string.sub(str, -1, -1) == '.' then
    str = string.sub(str, 1, -2)
    str = str:gsub('^%s*(.-)%s*$', '%1')
  end

  return str
end

return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    opts = {
      diagnostics = {
        underline = false,
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
      autoformat = true,
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
        denols = {},
        volar = {},
        emmet_ls = {
          filetypes = { 'html', 'liquid' },
        },
      },
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    opts = function(_, opts)
      local nls = require('null-ls')
      table.insert(
        opts.sources,
        nls.builtins.formatting.phpcsfixer.with({
          condition = function(utils) return utils.root_has_file({ '.php-cs-fixer.dist.php', '.php-cs-fixer.php' }) end,
        })
      )

      table.insert(
        opts.sources,
        nls.builtins.formatting.pint.with({
          condition = function(utils) return utils.root_has_file('pint.json') end,
        })
      )
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        'php-cs-fixer',
        'pint',
      },
    },
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    opts = {
      outline = { auto_open = false },
      widget_guides = { enabled = false, debug = false },
      dev_log = { enabled = false, open_cmd = 'tabedit' },
      lsp = {
        color = { enabled = true, background = true, virtual_text = false },
        settings = {
          showTodos = false,
          renameFilesWithClasses = 'always',
          updateImportsOnRename = true,
          completeFunctionCalls = true,
          lineLength = 100,
        },
      },
    },
  },
  {
    'smjonas/inc-rename.nvim',
    opts = { hl_group = 'Visual', preview_empty_name = true },
  },
}
