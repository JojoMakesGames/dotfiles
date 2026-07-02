-- Browse the persistent undo history (:h undofile is already enabled)
vim.pack.add {
  'https://github.com/mbbill/undotree',
}

vim.g.undotree_SetFocusWhenToggle = 1

vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle, { desc = '[U]ndotree toggle' })
