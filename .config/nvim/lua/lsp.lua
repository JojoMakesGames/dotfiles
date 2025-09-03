vim.pack.add {
  { src = 'https://github.com/williamboman/mason.nvim' },
  -- { src = 'https://github.com/seblyng/roslyn.nvim' },
}

require('mason').setup {
  registries = {
    'github:mason-org/mason-registry',
    'github:Crashdummyy/mason-registry',
  },
}

-- configure Roslyn through Neovim's LSP

local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)
