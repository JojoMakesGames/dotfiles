return {
  'nvim-neo-tree/neo-tree.nvim',
  keys = {
    { '<leader>f', '<cmd>Neotree reveal<cr>' },
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      open_on_setup = true,
      auto_close = true,
    }
  end,
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
}
