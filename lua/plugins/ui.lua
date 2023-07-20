local as = require('utils')

return {
  {
    'folke/noice.nvim',
    opts = {
      lsp = {
        progress = { enabled = false },
        documentation = {
          opts = {
            position = { row = 2 },
          },
        },
        signature = {
          enabled = true,
          opts = {
            position = { row = 2 },
          },
        },
        hover = { enabled = true },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      popupmenu = {
        backend = 'nui',
      },
      views = {
        vsplit = { size = { width = 'auto' } },
        split = { win_options = { winhighlight = { Normal = 'Normal' } } },
        cmdline_popup = {
          position = { row = 5, col = '50%' },
          size = { width = 'auto', height = 'auto' },
        },
        popupmenu = {
          relative = 'editor',
          position = { row = 9, col = '50%' },
          size = { width = 60, height = 10 },
          win_options = { winhighlight = { Normal = 'NormalFloat', FloatBorder = 'FloatBorder' } },
        },
      },
      redirect = { view = 'popup', filter = { event = 'msg_show' } },
      routes = {
        {
          opts = { skip = true },
          filter = {
            any = {
              { event = 'msg_show', find = 'written' },
              { event = 'msg_show', find = '%d+ lines, %d+ bytes' },
              { event = 'msg_show', kind = 'search_count' },
              { event = 'msg_show', find = '%d+L, %d+B' },
              { event = 'msg_show', find = '^Hunk %d+ of %d' },
              { event = 'msg_show', find = '%d+ changes' },
              { event = 'msg_show', find = '%d+ more line' },
              -- TODO: investigate the source of this LSP message and disable it happens in typescript files
              { event = 'notify', find = 'No information available' },
            },
          },
        },
        {
          view = 'vsplit',
          filter = { event = 'msg_show', min_height = 20 },
        },
        {
          view = 'notify',
          filter = {
            any = {
              { event = 'msg_show', min_height = 10 },
              { event = 'msg_show', find = 'Treesitter' },
            },
          },
          opts = { timeout = 10000 },
        },
        {
          view = 'mini',
          filter = {
            any = {
              { event = 'msg_show', find = '^E486:' },
              { event = 'notify', max_height = 1 },
            },
          }, -- minimise pattern not found messages
        },
        {
          view = 'notify',
          filter = {
            any = {
              { warning = true },
              { event = 'msg_show', find = '^Warn' },
              { event = 'msg_show', find = '^W%d+:' },
              { event = 'msg_show', find = '^No hunks$' },
            },
          },
          opts = { title = 'Warning', level = vim.log.levels.WARN, merge = false, replace = false },
        },
        {
          view = 'notify',
          opts = { title = 'Error', level = vim.log.levels.ERROR, merge = true, replace = false },
          filter = {
            any = {
              { error = true },
              { event = 'msg_show', find = '^Error' },
              { event = 'msg_show', find = '^E%d+:' },
            },
          },
        },
        {
          view = 'notify',
          opts = { title = '' },
          filter = { kind = { 'emsg', 'echo', 'echomsg' } },
        },
      },
      commands = {
        history = { view = 'vsplit' },
      },
      presets = {
        inc_rename = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    'echasnovski/mini.starter',
    opts = function(_, opts)
      opts.header = table.concat(require('utils').get_weekday(), '\n')
      opts.content_hooks = nil
      opts.footer = table.concat(require('utils.fortune').get_fortune(), '\n')
    end,
  },
  {
    'echasnovski/mini.indentscope',
    opts = {
      symbol = '▏', -- "│", -- ▏┆┊
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
      { 'zP', function() require('ufo').peekFoldedLinesUnderCursor() end, desc = 'Preview Fold' },
    },
    opts = {
      open_fold_hl_timeout = 0,
      preview = { win_config = { winhighlight = 'Normal:Normal,FloatBorder:Normal' } },
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth) end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
      provider_selector = function(buffer, filetype, _)
        local function customizeSelector(bufnr)
          local function handleFallbackException(err, providerName)
            if type(err) == 'string' and err:match('UfoFallbackException') then
              return require('ufo').getFolds(bufnr, providerName)
            else
              return require('promise').reject(err)
            end
          end

          return require('ufo')
            .getFolds(bufnr, 'lsp')
            :catch(function(err) return handleFallbackException(err, 'treesitter') end)
            :catch(function(err) return handleFallbackException(err, 'indent') end)
        end

        if vim.api.nvim_buf_line_count(buffer) > 5000 or filetype == 'php' then return { 'indent' } end

        return customizeSelector
      end,
    },
  },
  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 5000,
      stages = 'fade_in_slide_out',
      top_down = false,
      background_colour = 'NormalFloat',
      max_width = function() return math.floor(vim.o.columns * 0.6) end,
      max_height = function() return math.floor(vim.o.lines * 0.8) end,
      render = function(...)
        local notification = select(2, ...)
        local style = as.empty(notification.title[1]) and 'minimal' or 'default'
        require('notify.render')[style](...)
      end,
    },
  },
}
