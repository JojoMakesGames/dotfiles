-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Telescope process picker
    local function pick_process_telescope()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local conf = require('telescope.config').values
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      return coroutine.create(function(coro)
        local opts = {}
        local handle = io.popen 'ps ax -o pid,comm'
        local result = handle:read '*a'
        handle:close()

        local processes = {}
        for line in result:gmatch '[^\r\n]+' do
          local pid, name = line:match '^%s*(%d+)%s+(.+)$'
          if pid and name then
            table.insert(processes, { pid = pid, name = name })
          end
        end

        pickers
          .new(opts, {
            prompt_title = 'Select Process to Attach',
            finder = finders.new_table {
              results = processes,
              entry_maker = function(entry)
                return {
                  value = entry.pid,
                  display = entry.pid .. ': ' .. entry.name,
                  ordinal = entry.pid .. ' ' .. entry.name,
                }
              end,
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                coroutine.resume(coro, tonumber(selection.value))
              end)
              return true
            end,
          })
          :find()
      end)
    end

    -- Use vsdbg instead of netcoredbg for Apple Silicon
    --[[ dap.adapters.coreclr = {
      type = 'executable',
      command = vim.fn.expand '~/.vsdbg/vsdbg',
      args = { '--interpreter=vscode' },
    } ]]

    dap.adapters.coreclr = {
      type = 'executable',
      command = 'netcoredbg',
      args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
      --   {
      --     type = 'coreclr',
      --     name = 'launch',
      --     request = 'launch',
      --     -- preLaunchTask = 'build',
      --     program = function()
      --       return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/Backend/API/bin/Debug/net8.0/API.dll', 'file')
      --     end,
      --     cwd = vim.fn.getcwd() .. '/Backend/API',
      --     stopAtEntry = false,
      --     env = {
      --       ASPNETCORE_ENVIRONMENT = 'Local',
      --       ASPNETCORE_URLS = 'https://localhost:7170;http://localhost:5233',
      --     },
      --   },
      --   {
      --     type = 'coreclr',
      --     name = 'attach',
      --     request = 'attach',
      --     processId = pick_process_telescope,
      --   },
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/Backend/API/bin/Debug/net8.0/API.dll', 'file')
        end,
        cwd = vim.fn.getcwd() .. '/Backend/API',
        env = function()
          return {
            ASPNETCORE_ENVIRONMENT = 'Local',
            ASPNETCORE_URLS = 'https://localhost:7170;http://localhost:5233',
          }
        end,
      },
    }

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'csharp',
        'js',
        'typescript',
        'delve',
      },
    }

    vim.keymap.set('n', '<F5>', function()
      -- Show debug info
      print 'Starting debugger...'
      dap.continue()
    end, { desc = 'Debug: Start/Continue' })
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
  end,
}
