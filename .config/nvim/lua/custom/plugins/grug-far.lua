-- Project-wide find & replace (ripgrep-backed live buffer UI)
vim.pack.add {
  'https://github.com/MagicDuck/grug-far.nvim',
}

require('grug-far').setup {}

vim.keymap.set('n', '<leader>F', '<cmd>GrugFar<CR>', { desc = '[F]ind & replace in project' })
vim.keymap.set('v', '<leader>F', function()
  require('grug-far').with_visual_selection()
end, { desc = '[F]ind & replace selection' })
