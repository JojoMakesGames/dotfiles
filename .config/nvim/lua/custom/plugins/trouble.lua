vim.pack.add {
  'https://github.com/folke/trouble.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

require('trouble').setup {}

vim.keymap.set('n', '<leader>q', function()
  require('trouble').toggle()
end)
