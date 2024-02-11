return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  opts = function(_, opts)
    local nls = require 'null-ls'
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.code_actions.gitsigns,
      -- go
      -- nls.builtins.code_actions.gomodifytags,
      -- nls.builtins.code_actions.impl,
      -- nls.builtins.diagnostics.golangci_lint,
      -- ts
      nls.builtins.formatting.prettier,
      require 'typescript.extensions.null-ls.code-actions',
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.rubocop,
      nls.builtins.diagnostics.credo,
      -- other
      -- nls.builtins.formatting.stylua,
      -- nls.builtins.formatting.shfmt,
    })
    opts.on_attach = function(client, bufnr)
      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      if client.supports_method 'textDocument/formatting' then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            vim.lsp.buf.format { async = false, timeout_ms = 5000 }
          end,
        })
      end
    end
    return opts
  end,
  dependencies = {
    'jose-elias-alvarez/typescript.nvim',
  },
}
