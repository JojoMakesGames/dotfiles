-- Core plugins, installed with the native package manager (:h vim.pack).
-- See docs/adr/0001-native-vim-pack-plugin-management.md for why not lazy.nvim.

-- Build steps that lazy.nvim used to run for us
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-build-hooks', { clear = true }),
  callback = function(ev)
    if ev.data.kind == 'delete' or vim.fn.executable 'make' ~= 1 then
      return
    end
    local name = ev.data.spec.name
    if name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    elseif name == 'LuaSnip' then
      vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/tpope/vim-sleuth',
  'https://github.com/github/copilot.vim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/folke/which-key.nvim',
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1.x' },
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/stevearc/conform.nvim',
  -- tagged release so blink downloads its prebuilt rust fuzzy matcher
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range '1.*' },
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/echasnovski/mini.nvim',
  -- main branch: the frozen master branch crashes on nvim 0.12.3 (old-style
  -- query directives). Needs the tree-sitter CLI (brew install tree-sitter-cli)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
}

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end)
  end,
}

require('which-key').setup()

require('telescope').setup {
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sG', builtin.git_files, { desc = '[S]earch [G]it files' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

require('conform').setup {
  notify_on_error = true,
  format_after_save = function(bufnr)
    return { lsp_format = 'never' }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    typescriptreact = { 'eslint_d' },
    typescript = { 'eslint_d' },
    gdscript = { 'gdformat' },
    rust = { 'rustfmt' },
    ruby = { 'rubocop' },
  },
}

local luasnip = require 'luasnip'
luasnip.config.setup {}

-- Load custom snippets
require('luasnip.loaders.from_lua').load { paths = './lua/snippets' }

-- Set up filetype for .cy.js files
vim.filetype.add {
  extension = {
    ['cy.js'] = 'javascript',
  },
  pattern = {
    ['.*%.cy%.js'] = 'javascript',
  },
}

-- Load cypress snippets for javascript files
luasnip.filetype_extend('javascript', { 'cypress' })

require('blink.cmp').setup {
  snippets = { preset = 'luasnip' },
  keymap = {
    -- default preset already provides <C-n>/<C-p> select and <C-y> accept
    preset = 'default',
    ['<C-j>'] = { 'show' },
    ['<C-l>'] = { 'snippet_forward', 'fallback' },
    ['<C-h>'] = { 'snippet_backward', 'fallback' },
  },
  sources = {
    default = { 'lsp', 'snippets', 'path', 'lazydev' },
    per_filetype = {
      sql = { 'dadbod', 'buffer' },
      mysql = { 'dadbod', 'buffer' },
      plsql = { 'dadbod', 'buffer' },
    },
    providers = {
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
    },
  },
}

-- Advertise completion capabilities to every native-config LSP server
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

-- Precise nvim-API completion/types when editing this config,
-- instead of lua_ls indexing the whole runtimepath
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

require('todo-comments').setup { signs = false }

require('mini.ai').setup { n_lines = 500 }
-- surround comes from tpope/vim-surround (custom/plugins/vim-surround.lua)
local statusline = require 'mini.statusline'
statusline.setup()
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return ''
end

local treesitter_parsers = {
  'http',
  'bash',
  'c',
  'html',
  'lua',
  'go',
  'elixir',
  'typescript',
  'javascript',
  'markdown',
  'vim',
  'vimdoc',
  'markdown_inline',
  'json',
  'yaml',
  'gdscript',
  'c_sharp',
}

require('nvim-treesitter').install(treesitter_parsers)

-- The main branch has no highlight/indent "enable" options; each buffer opts
-- in. pcall covers filetypes without an installed parser.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and pcall(vim.treesitter.start, args.buf, lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('ibl').setup {}

-- Pin the enclosing class/method signature to the top of the window
require('treesitter-context').setup { max_lines = 4 }
