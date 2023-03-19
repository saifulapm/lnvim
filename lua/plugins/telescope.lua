return {
  {
    'nvim-telescope/telescope.nvim',
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
    },
  },
}
