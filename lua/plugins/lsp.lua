local function trim(str)
  str = str:gsub('^%s*(.-)%s*$', '%1')

  if string.sub(str, -1, -1) == '.' then
    str = string.sub(str, 1, -2)
    str = str:gsub('^%s*(.-)%s*$', '%1')
  end

  return str
end

local without_root_file = function(...)
  local files = { ... }
  return function(utils) return not utils.root_has_file(files) end
end

return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
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
        rust_analyzer = {},
        tailwindcss = {
          root_dir = require('lspconfig.util').root_pattern('tailwind.config.js', 'tailwind.config.ts'),
        },
        tsserver = {
          init_options = {
            hostInfo = 'neovim',
            preferences = {
              quotePreference = 'double',
              includeCompletionsWithSnippetText = true,
              generateReturnInDocTemplate = true,
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          settings = {
            format = false,
          },
        },
        eslint = {
          root_dir = require('lspconfig.util').root_pattern(
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.cjs',
            '.eslintrc.yaml',
            '.eslintrc.yml',
            '.eslintrc.json'
          ),
          settings = {
            format = {
              enable = false,
            },
            workingDirectory = { mode = 'auto' },
          },
          handlers = {
            -- this error shows up occasionally when formatting
            -- formatting actually works, so this will supress it
            ['window/showMessageRequest'] = function(_, result)
              if result.message:find('ENOENT') then return vim.NIL end

              return vim.lsp.handlers['window/showMessageRequest'](nil, result)
            end,
          },
        },
        denols = {},
        volar = {},
        emmet_ls = {
          filetypes = { 'html', 'liquid' },
        },
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd('BufWritePre', {
            callback = function(event)
              if not require('lazyvim.plugins.lsp.format').enabled() then
                -- exit early if autoformat is not enabled
                return
              end

              local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = 'eslint' })[1]
              if client then
                local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then vim.cmd('EslintFixAll') end
              end
            end,
          })
        end,
      },
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    opts = function(_, opts)
      local nls = require('null-ls')
      table.insert(
        opts.sources,
        nls.builtins.formatting.prettierd.with({
          condition = without_root_file('.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json'),
        })
      )

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
        'prettierd',
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
