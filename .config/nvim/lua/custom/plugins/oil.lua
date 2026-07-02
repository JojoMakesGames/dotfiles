vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('oil').setup {
  keymaps = {
    ['q'] = 'actions.close',
  },
}

vim.keymap.set('n', '<leader>f', '<cmd>Oil --float<cr>')
