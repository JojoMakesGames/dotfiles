-- .NET-first tooling: easy-dotnet.nvim owns the whole C# experience — the
-- Roslyn LSP (solution picked once per repo and cached, shared with the
-- debugger), and the launch flow (picks the startup project from the
-- solution, builds, resolves the dll, applies launchSettings.json profiles)
-- registered with nvim-dap.

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
  'https://github.com/GustavEikaas/easy-dotnet.nvim',
}

local dap = require 'dap'
local dapui = require 'dapui'

-- Variable values inline next to the code while stopped at a breakpoint
require('nvim-dap-virtual-text').setup {}

-- easy-dotnet's server is a dotnet global tool (dotnet-easydotnet); make sure
-- the global-tools dir is visible even when nvim inherits a PATH without it
local dotnet_tools = vim.fs.normalize '~/.dotnet/tools'
if not vim.env.PATH:find(dotnet_tools, 1, true) then
  vim.env.PATH = vim.env.PATH .. ':' .. dotnet_tools
end

-- mason's netcoredbg ships an x86_64 binary that cannot debug arm64 .NET
-- processes, so we point at a manually installed native arm64 build
-- (https://github.com/Samsung/netcoredbg/releases, unzipped to this path)
local netcoredbg = vim.fs.normalize '~/.local/share/netcoredbg/netcoredbg/netcoredbg'

require('easy-dotnet').setup {
  debugger = {
    bin_path = netcoredbg,
  },
  lsp = {
    config = {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = true,
        },
        ['csharp|formatting'] = {
          dotnet_organize_imports_on_format = true,
        },
      },
    },
  },
}

-- Attach to an already-running process (easy-dotnet only registers launch
-- configurations)
dap.adapters.coreclr = {
  type = 'executable',
  command = netcoredbg,
  args = { '--interpreter=vscode' },
}

dap.configurations.cs = dap.configurations.cs or {}
table.insert(dap.configurations.cs, {
  type = 'coreclr',
  name = 'attach',
  request = 'attach',
  processId = require('dap.utils').pick_process,
})

vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
