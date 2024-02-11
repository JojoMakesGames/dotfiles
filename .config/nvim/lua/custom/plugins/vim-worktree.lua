return {
  'ThePrimeagen/git-worktree.nvim',
  event = 'VeryLazy',
  dependencies = {
    'thePrimeagen/harpoon',
  },
  config = function()
    local Worktree = require 'git-worktree'
    function check_git_file()
      local current_dir = vim.fn.expand '%:p:h'
      local worktree_file_path = current_dir .. '/worktrees'

      if vim.fn.isdirectory(worktree_file_path) ~= 0 then
        require('telescope').extensions.git_worktree.git_worktrees()
      end
    end

    vim.cmd [[
      augroup GitWorktree
        autocmd!
        autocmd VimEnter * lua check_git_file()
      augroup END
    ]]
    Worktree.on_tree_change(function(op, metadata)
      if op == Worktree.Operations.Switch then
        require('harpoon.ui').nav_file(1)
      end
      if op == Worktree.Operations.Create then
        local base_path = vim.fn.fnamemodify(vim.fn.getcwd(), ':h') .. '/' .. metadata.path
        local infra_path = base_path .. '/infra'
        local is_teamsnap_spas_directory = base_path:match 'teamsnap%-spas'
        if is_teamsnap_spas_directory then
          vim.fn.system('tmux split-window -h -c' .. base_path .. ' "yarn install"')
        elseif vim.fn.isdirectory(infra_path) ~= 0 then
          vim.fn.system('tmux split-window -h -c' .. base_path .. ' "osnp run setup"')
        end
      end
    end)
  end,
}
