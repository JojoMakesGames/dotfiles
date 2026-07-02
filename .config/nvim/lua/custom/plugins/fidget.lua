-- LSP progress in the corner — replaces noice's progress handler, which is
-- disabled because it crashes on easy-dotnet's token-less progress events.
-- Roslyn solution loading is slow enough that visible progress matters.
vim.pack.add {
  'https://github.com/j-hui/fidget.nvim',
}

require('fidget').setup {}
