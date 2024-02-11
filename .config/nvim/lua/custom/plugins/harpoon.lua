local wk = require 'which-key'
wk.register { ['<leader>h'] = { name = 'Harpoon' } }
return {
  'ThePrimeagen/harpoon',
  event = 'VeryLazy',
  config = function()
    require('harpoon').setup {
      global_settings = {
        save_on_toggle = true,
        save_on_change = true,
      },
    }
  end,
  keys = {
    {
      '<leader>ha',
      function()
        require('harpoon.mark').add_file()
      end,
      desc = '[h]arpoon [a]dd',
    },
    {
      '<leader>hh',
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      desc = '[h]arken [h]arpoon',
    },
    {
      '<leader>hp',
      function()
        require('harpoon.ui').nav_prev()
      end,
      desc = '[h]arpoon [p]revious',
    },
    {
      '<leader>hn',
      function()
        require('harpoon.ui').nav_next()
      end,
      desc = '[h]arpoon [n]ext',
    },
    {
      '<leader>h1',
      function()
        require('harpoon.ui').nav_file(1)
      end,
      desc = 'Harpoon file 1',
    },
    {
      '<leader>h2',
      function()
        require('harpoon.ui').nav_file(2)
      end,
      desc = 'Harpoon file 2',
    },
    {
      '<leader>h3',
      function()
        require('harpoon.ui').nav_file(3)
      end,
      desc = 'Harpoon file 3',
    },
    {
      '<leader>h4',
      function()
        require('harpoon.ui').nav_file(4)
      end,
      desc = 'Harpoon file 4',
    },
    {
      '<leader>h5',
      function()
        require('harpoon.ui').nav_file(5)
      end,
      desc = 'Harpoon file 5',
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
