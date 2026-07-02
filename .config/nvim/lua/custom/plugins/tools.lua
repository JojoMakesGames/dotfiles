vim.opt.conceallevel = 2 -- for markdown

vim.pack.add {
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/mistweaverco/kulala.nvim',
}

require('nvim-autopairs').setup {}

-- vim-dadbod-ui
vim.g.db_ui_use_nerd_fonts = 1
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'dbout' },
  callback = function()
    vim.opt.foldenable = false
  end,
})

require('neogit').setup {}
vim.keymap.set('n', '<leader>g', '<cmd>:wa<CR><cmd>Neogit<CR>')

require('kulala').setup()

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'

local find_http_files = function()
  pickers
    .new({}, {
      prompt_title = 'HTTP Files',
      finder = finders.new_oneshot_job { 'find', '.', '-name', '*.http', '-maxdepth', '1', '-exec', 'basename', '\\{\\}', '.po', '\\;' },
    })
    :find()
end

vim.api.nvim_create_user_command('KulalaFindHttpFiles', find_http_files, {})
vim.api.nvim_set_keymap('n', '<leader>sp', '<cmd>KulalaFindHttpFiles<CR>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Setup Kulala keymaps',
  pattern = '*.http',
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>k', '<cmd>lua require("kulala").run()<CR>', {})
  end,
})
