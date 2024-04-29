return {
  {
    'vhyrro/luarocks.nvim',
    enabled = false,
    priority = 1000,
    config = true,
  },
  {
    'rest-nvim/rest.nvim',
    enabled = false,
    dependencies = { 'luarocks.nvim' },
    ft = { 'http' },
    config = function()
      require('rest-nvim').setup()
    end,
    keys = {
      { 'n', '<leader>rr', ':lua require("rest-nvim").run()<CR>' },
      { 'n', '<leader>rp', ':lua require("rest-nvim").run(true)<CR>' },
    },
  },
}
