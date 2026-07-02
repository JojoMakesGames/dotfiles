-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dbout',
  callback = function()
    vim.keymap.set('n', '<leader>jq', function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local json_lines = {}
      for _, line in ipairs(lines) do
        local trimmed = vim.trim(line)
        if trimmed ~= '' and not trimmed:match '^JSON_F' and not trimmed:match '^%-%-%-' and not trimmed:match '^%(%d+ row' then
          table.insert(json_lines, trimmed)
        end
      end
      local text = table.concat(json_lines, '')
      local result = vim.fn.system("jq '.'", text)
      if vim.v.shell_error == 0 then
        vim.fn.setreg('+', result)
        vim.notify 'jq output copied to clipboard'
      else
        vim.notify('jq error: ' .. result, vim.log.levels.ERROR)
      end
    end, { buffer = true })
  end,
})
