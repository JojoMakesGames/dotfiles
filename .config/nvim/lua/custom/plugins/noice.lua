vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/folke/noice.nvim',
}

require('noice').setup {
  messages = {
    -- view = false,
  },
  lsp = {
    -- noice's progress handler crashes on progress events without a token
    -- (easy-dotnet's in-process LSP client sends these on nvim 0.12)
    progress = { enabled = false },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
}

require('telescope').load_extension 'noice'

vim.keymap.set('n', '<leader>sm', ':NoiceTelescope<CR>')
vim.keymap.set('n', '<leader>m', ':Noice<CR>')
-- not <C-m>: that's the same keycode as <CR> in most terminals
vim.keymap.set('n', '<leader>nd', ':NoiceDismiss<CR>', { desc = '[N]oice [D]ismiss' })
