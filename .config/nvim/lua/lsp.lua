vim.pack.add {
  { src = 'https://github.com/mason-org/mason.nvim' },
}

require('mason').setup {}

-- C# LSP is owned by easy-dotnet.nvim (see lua/debugging.lua)

vim.lsp.inlay_hint.enable(true)

-- Enable every server that has a config on the runtimepath (lsp/*.lua)
local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[g]o to [d]efinition' })

vim.keymap.set('n', '<leader>i', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

vim.keymap.set('v', 'f', function()
  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  vim.lsp.buf.format {
    range = {
      ['start'] = { line = start_pos[1] - 1, character = start_pos[2] },
      ['end'] = { line = end_pos[1] - 1, character = end_pos[2] },
    },
  }
end, { desc = 'Format selection', silent = true })

vim.keymap.set('n', 'gro', function()
  vim.lsp.buf.code_action {
    context = {
      only = { 'source.organizeImports' },
      diagnostics = {},
    },
    apply = true,
  }
end, { desc = 'Organize Imports' })

vim.keymap.set('n', 'gru', function()
  vim.lsp.buf.code_action {
    context = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      only = { 'source.removeUnused' },
      diagnostics = {},
    },
    apply = true,
  }
end, { desc = 'Remove Unused' })
