return {
  'JojoMakesGames/git-remote-url.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    {
      '<leader>yg',
      function()
        vim.cmd 'CopyGithubLink'
      end,
    },
    {
      '<leader>yG',
      function()
        vim.cmd 'CopyGithubLinkWithBranchName'
      end,
    },
  },
}
