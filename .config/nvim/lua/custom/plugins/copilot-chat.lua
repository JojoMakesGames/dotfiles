return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' },
    },
    opts = {
      debug = false, -- Enable debugging
      window = {
        layout = 'float',
        relative = 'cursor',
        width = 1,
        height = 0.4,
        row = 1,
      },
    },
    keys = {
      {
        '<leader>ct',
        '<cmd>CopilotChatToggle<CR>',
      },
    },
  },
}
