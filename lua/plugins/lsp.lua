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

local without_root_file = function(...)
  local files = { ... }
  return function(utils) return not utils.root_has_file(files) end
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
        volar = {},
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd('BufWritePre', {
            callback = function(event)
              if require('lspconfig.util').get_active_client_by_name(event.buf, 'eslint') then vim.cmd('EslintFixAll') end
            end,
          })
        end,
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
            condition = without_root_file(
              '.eslintrc',
              '.eslintrc.js',
              '.eslintrc.cjs',
              '.eslintrc.yaml',
              '.eslintrc.yml',
              '.eslintrc.json'
            ),
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
        -- 'rome',
        'php-cs-fixer',
        'pint',
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
}
