vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 15

vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.hlsearch = true

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''
vim.opt.foldlevelstart = 100

-- Reload buffers edited outside nvim (e.g. by Claude Code in another pane)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('autoread-checktime', { clear = true }),
  callback = function()
    if vim.bo.buftype == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Add #region folding support for supported languages
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'cs', 'csharp', 'c', 'cpp' },
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.RegionFold(v:lnum)'
  end,
})

function _G.RegionFold(lnum)
  local line = vim.fn.getline(lnum)
  if line:match '^%s*//.*#region' or line:match '^%s*/%*.*#region' then
    return '>1'
  elseif line:match '^%s*//.*#endregion' or line:match '^%s*/%*.*#endregion' then
    return '<1'
  else
    return '='
  end
end
