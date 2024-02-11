return {
  'github/copilot.vim',
  event = 'InsertEnter',
  init = function()
    vim.g.copilot_node_command = '~/.nvm/versions/node/v18.17.1/bin/node'
  end,
}
