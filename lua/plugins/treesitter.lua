local function ts_disable(bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    keys = function()
      return {}
    end,
    opts = {
      ensure_installed = {
        "html",
        "javascript",
        "json",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "php",
        "dart",
        "tsx",
        "typescript",
        "vim",
        "vue",
      },
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          return ts_disable(bufnr)
        end,
      },
      incremental_selection = {
        enable = true,
        disable = function(_, bufnr)
          return ts_disable(bufnr)
        end,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
      context_commentstring = {
        enable = false,
        disable = function(_, bufnr)
          return ts_disable(bufnr)
        end,
        enable_autocmd = false,
      },
      indent = {
        enable = false,
        disable = function(lang, bufnr)
          return lang == "python" or ts_disable(bufnr)
        end,
      },
      rainbow = {
        enable = true,
        disable = function(_, bufnr)
          return ts_disable(bufnr)
        end,
      },
    },
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "HiPhish/nvim-ts-rainbow2" },
      {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle" },
      },
    },
  },
}
