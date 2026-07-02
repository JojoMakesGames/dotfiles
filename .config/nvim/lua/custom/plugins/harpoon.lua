vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
}

local harpoon = require 'harpoon'
harpoon:setup {
  settings = {
    save_on_toggle = true,
  },
}

vim.keymap.set('n', '<leader>ha', function()
  harpoon:list():add()
end, { desc = '[h]arpoon [a]dd' })
vim.keymap.set('n', '<leader>hh', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = '[h]arken [h]arpoon' })
vim.keymap.set('n', '<leader>hp', function()
  harpoon:list():prev()
end, { desc = '[h]arpoon [p]revious' })
vim.keymap.set('n', '<leader>hn', function()
  harpoon:list():next()
end, { desc = '[h]arpoon [n]ext' })
for i = 1, 5 do
  vim.keymap.set('n', '<leader>h' .. i, function()
    harpoon:list():select(i)
  end, { desc = 'Harpoon file ' .. i })
end
