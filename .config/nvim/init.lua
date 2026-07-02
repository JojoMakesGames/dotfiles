require 'opts'
require 'keymaps'
require 'plugins'
require 'lsp'
require 'debugging'
require 'appearance'
require 'test'

-- compact virtual text everywhere except the cursor line, which gets the
-- full multi-line rendering instead
vim.diagnostic.config {
  virtual_text = { current_line = false },
  virtual_lines = { current_line = true },
}

-- Load every module in lua/custom/plugins (each installs its own plugins via
-- vim.pack.add and runs its own setup)
for _, f in ipairs(vim.api.nvim_get_runtime_file('lua/custom/plugins/*.lua', true)) do
  local name = vim.fn.fnamemodify(f, ':t:r')
  local mod = name == 'init' and 'custom.plugins' or ('custom.plugins.' .. name)
  require(mod)
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
