local as = require('utils')

return {
  {
    'folke/noice.nvim',
    opts = {
      lsp = {
        progress = { enabled = false },
      },
    },
  },
  {
    'echasnovski/mini.starter',
    opts = function(_, opts) opts.header = table.concat(require('utils').get_weekday(), '\n') end,
    config = function(plugin, opts)
      plugin._.super.config(plugin, opts)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniStarterOpened',
        callback = function(args)
          vim.opt_local.laststatus = 0

          vim.api.nvim_create_autocmd('BufUnload', {
            buffer = args.buf,
            callback = function() vim.opt_local.laststatus = 3 end,
          })
        end,
      })
    end,
  },
  {
    'echasnovski/mini.indentscope',
    opts = {
      symbol = '┊', -- "│", -- ▏┆┊
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    event = 'VeryLazy',
    dependencies = { 'kevinhwang91/promise-async' },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, 'open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, 'close all folds' },
      { 'zP', function() require('ufo').peekFoldedLinesUnderCursor() end, 'preview fold' },
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
      provider_selector = function(_, filetype, _)
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
        local ftMap = { php = { 'indent' } }

        return ftMap[filetype] or customizeSelector
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
