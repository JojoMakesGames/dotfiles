vim.pack.add {
  'https://github.com/daliusd/ghlite.nvim',
}

require('ghlite').setup {
  debug = false,
  view_split = 'vsplit',
  diff_split = 'vsplit',
  diff_tool = 'auto',
  comment_split = 'split',
  open_command = 'open',
  merge = {
    approved = '--squash',
    nonapproved = '--auto --squash',
  },
  keymaps = {
    diff = {
      open_file = 'gf',
      open_file_tab = '',
      open_file_split = 'o',
      open_file_vsplit = 'O',
      approve = 'cA',
      request_changes = 'cR',
    },
    comment = {
      send_comment = 'c<CR>',
    },
    pr = {
      approve = 'cA',
      request_changes = 'cR',
      merge = 'cM',
      comment = 'ca',
      diff = 'cp',
    },
  },
}

vim.keymap.set('n', '<leader>us', ':GHLitePRSelect<cr>', { silent = true, desc = 'PR Select' })
vim.keymap.set('n', '<leader>uo', ':GHLitePRCheckout<cr>', { silent = true, desc = 'PR Checkout' })
vim.keymap.set('n', '<leader>uv', ':GHLitePRView<cr>', { silent = true, desc = 'PR View' })
vim.keymap.set('n', '<leader>uu', ':GHLitePRLoadComments<cr>', { silent = true, desc = 'PR Load Comments' })
vim.keymap.set('n', '<leader>up', ':GHLitePRDiff<cr>', { silent = true, desc = 'PR Diff' })
vim.keymap.set('n', '<leader>ul', ':GHLitePRDiffview<cr>', { silent = true, desc = 'PR Diffview' })
vim.keymap.set('n', '<leader>ua', ':GHLitePRAddComment<cr>', { silent = true, desc = 'PR Add comment' })
vim.keymap.set('n', '<leader>uc', ':GHLitePRUpdateComment<cr>', { silent = true, desc = 'PR Update comment' })
vim.keymap.set('n', '<leader>ud', ':GHLitePRDeleteComment<cr>', { silent = true, desc = 'PR Delete comment' })
vim.keymap.set('n', '<leader>ug', ':GHLitePROpenComment<cr>', { silent = true, desc = 'PR Open comment' })
