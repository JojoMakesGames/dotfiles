return {
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('hardtime').setup()
      require('hardtime').toggle()
    end,
  },
  -- disable {{ and }} in normal mode
  vim.keymap.set('n', '{', function() vim.notify('Use <C-u> silly!', vim.log.levels.WARN) end),
  vim.keymap.set('n', '}', function() vim.notify('Use <C-d> silly!', vim.log.levels.WARN) end),
}
