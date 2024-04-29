return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  dependencies = {
    'tpope/vim-rhubarb'
  },
  keys = {
    { '<leader>b', '<cmd>Git blame<CR>' }
  }
}
