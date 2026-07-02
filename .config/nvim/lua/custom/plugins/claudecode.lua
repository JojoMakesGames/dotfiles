-- Claude Code IDE integration: nvim speaks the same WebSocket/MCP protocol as
-- the official VS Code extension, so Claude sees the current file/selection
-- and proposed edits open as native diffs here.
vim.pack.add {
  'https://github.com/coder/claudecode.nvim',
}

require('claudecode').setup {
  terminal = {
    provider = 'native', -- no snacks.nvim dependency
  },
}

vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Cl[a]ude [c]ode toggle' })
vim.keymap.set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Cl[a]ude [f]ocus' })
vim.keymap.set('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'Cl[a]ude [r]esume' })
vim.keymap.set('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Cl[a]ude add [b]uffer' })
vim.keymap.set('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Cl[a]ude [s]end selection' })
vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Cl[a]ude diff [a]ccept' })
vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Cl[a]ude diff [d]eny' })
