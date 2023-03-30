return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'benfowler/telescope-luasnip.nvim' },
      {
        'danielfalk/smart-open.nvim',
        branch = '0.2.x',
        dependencies = { 'kkharji/sqlite.lua' },
      },
    },
    opts = {
      defaults = {
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        dynamic_preview_title = true,
        prompt_prefix = '  ',
        selection_caret = '  ',
        entry_prefix = '  ',
        cycle_layout_list = { 'flex', 'horizontal', 'vertical', 'bottom_pane', 'center' },
        mappings = {
          i = {
            ['<c-e>'] = require('telescope.actions.layout').toggle_preview,
            ['<c-l>'] = require('telescope.actions.layout').cycle_layout_next,
          },
        },
        file_ignore_patterns = {
          '%.jpg',
          '%.jpeg',
          '%.png',
          '%.otf',
          '%.ttf',
          '%.DS_Store',
          '^.git/',
          'node%_modules/.*',
          '^site-packages/',
          '%.yarn/.*',
          '^vendor/',
          '^.dart_tool/',
          '^.git/',
          '^.github/',
          '^.idea/',
          '^.vscode/',
          '^.settings/',
          '^.env/',
          '^__pycache__/',
          '^build/',
          '^target/',
          '^gradle/',
          '^obj/',
          '^zig%-cache/',
          '^zig%-out/',
        },
        path_display = { 'truncate' },
        winblend = 0,
        color_devicons = true,
        layout_strategy = 'flex',
        layout_config = { horizontal = { preview_width = 0.55 } },
        preview = {
          filesize_hook = function(filepath, bufnr, opts)
            local max_bytes = 10000
            local cmd = { 'head', '-c', max_bytes, filepath }
            require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
          end,
        },
      },
      pickers = {
        find_files = {
          layout_config = { height = 0.50 },
          theme = 'ivy',
          previewer = false,
        },
        git_files = {
          layout_config = { height = 0.50 },
          theme = 'ivy',
          previewer = false,
        },
      },
      extensions = {
        fzf = {
          case_mode = 'ignore_case',
        },
        smart_open = {
          max_unindexed = 1000,
          match_algorithm = 'fzf',
          ignore_patterns = { '*.git/*', '*/tmp/*', '*/node_modules/*', '*/vendor/*' },
        },
      },
    },
    keys = {
      {
        '<leader><space>',
        function() require('telescope').extensions.smart_open.smart_open({ cwd_only = true }) end,
        desc = 'Find Files (smart_open)',
      },
      {
        '<leader>sl',
        function() require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_dropdown({ previewer = false })) end,
        desc = 'luasnip: available snippets',
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      local extensions_list = {
        'luasnip',
        'smart_open',
        'fzf',
      }

      for _, extension in ipairs(extensions_list) do
        telescope.load_extension(extension)
      end
    end,
  },
}
