return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'Trouble',
  enabled = true,
  opts = {},
  keys = {
    {
      '<leader>q',
      function()
        require('trouble').toggle()
      end,
    },
  },
}
