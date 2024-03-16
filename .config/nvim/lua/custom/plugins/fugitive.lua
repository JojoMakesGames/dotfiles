local popup = require 'plenary.popup'
local win_id
local bufnr
function CloseMenu()
  vim.api.nvim_win_close(win_id, true)
end

function MyMenu()
  local opts = {}
  local cb = function(_, sel)
    local branch_name = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
    vim.cmd('G checkout -b ' .. branch_name)
  end
  ShowMenu(opts, cb)
end

function ShowMenu(opts, cb)
  local width = 40
  local height = 1
  local borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
  win_id = popup.create(opts, {
    enter = true,
    title = 'New Branch',
    highlight = 'Insert',
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
    callback = cb,
  })
  bufnr = vim.api.nvim_win_get_buf(win_id)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<cmd>lua CloseMenu()<CR>', { silent = false })
end

return {
  'tpope/vim-fugitive',
  enabled = false,
  event = 'VeryLazy',
  keys = {
    { '<leader>gs', '<cmd>tab Git<cr>' },
    { '<leader>gp', '<cmd>Git push<cr>' },
    { '<leader>grs', '<cmd>Git rebase -i main<cr>' },
    { '<leader>grc', '<cmd>tab Git rebase --continue<cr>' },
    { '<leader>gra', '<cmd>tab Git rebase --abort<cr>' },
    { '<leader>gb', '<cmd>Git blame<cr>' },
    { '<leader>gcb', ':lua MyMenu()<cr>' },
  },
}
