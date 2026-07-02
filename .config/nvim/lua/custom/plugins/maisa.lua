vim.keymap.set('n', '<leader>G', function()
  local json = vim.fn.system 'gh pr view --json url'
  local url = vim.fn.json_decode(json).url
  vim.fn.system('open ' .. url)
end)

vim.keymap.set('n', '<leader>J', function()
  local branchName = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
  local jira = branchName.gsub(branchName, '_.*', '')
  vim.fn.system('open https://micollabhub.atlassian.net/browse/' .. jira)
end)
