return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>q',
      function()
        require('trouble').toggle()
      end,
    },
  },
}
