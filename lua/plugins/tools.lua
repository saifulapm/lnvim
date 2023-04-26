return {
  {
    'vuki656/package-info.nvim',
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
    },
    event = 'BufRead package.json',
    opts = {
      package_manager = 'npm',
    },
    config = function(_, opts)
      require('package-info').setup(opts)
      local ok, telescope = pcall(require, 'telescope')
      if ok and telescope.load_extension then telescope.load_extension('package_info') end
      vim.keymap.set(
        'n',
        '<LocalLeader>op',
        function() telescope.extensions.package_info.package_info() end,
        { silent = true, buffer = true, desc = 'Package Info' }
      )
    end,
  },
}
