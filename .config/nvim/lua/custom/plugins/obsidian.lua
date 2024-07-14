vim.opt.conceallevel = 2
return {
  'JojoMakesGames/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  event = 'VeryLazy',
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   'BufReadPre path/to/my-vault/**.md',
  --   'BufNewFile path/to/my-vault/**.md',
  -- },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  opts = {
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = 'notes/dailies',
    },
    new_notes_directory = 'notes',
    follow_url_func = function(url)
      vim.fn.jobstart { 'open', url }
    end,
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ''
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,
    sort_by = 'modified',
    sort_reversed = true,
    mappings = {
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    workspaces = {
      {
        name = 'teamsnap',
        path = '~/.obsidian/TeamSnap',
      },
      {
        name = 'stripe',
        path = '~/.obsidian/Teamsnap/stripe',
      },
      {
        name = 'personal',
        path = '~/.obsidian/Personal',
      },
      {
        name = 'gamedev',
        path = '~/.obsidian/GameDev',
      },
    },
  },
  keys = {
    {
      '<leader>ow',
      '<cmd>ObsidianWorkspace<CR>',
    },
    {
      '<leader>os',
      '<cmd>ObsidianSearch<CR>',
    },
    {
      '<leader>ot',
      '<cmd>ObsidianToday<CR>',
    },
    {
      '<leader>oT',
      '<cmd>ObsidianTomorrow<CR>',
    },
    {
      '<leader>oy',
      '<cmd>ObsidianYesterday<CR>',
    },
    {
      '<leader>on',
      '<cmd>ObsidianNew<CR>',
    },
  },
}
