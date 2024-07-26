return {
  vim.keymap.set('n', '<leader>G', function()
    local json = vim.fn.system 'gh pr view --json url'
    local url = vim.fn.json_decode(json).url
    vim.fn.system('open ' .. url)
  end),
  vim.keymap.set('n', '<leader>J', function()
    local branchName = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
    local jira = branchName.gsub(branchName, '_.*', '')
    vim.fn.system('open https://teamsnap.atlassian.net/browse/' .. jira)
  end),
  vim.keymap.set('n', '<leader>t', function()
    local output_file = '/tmp/test-runner.json'
    vim.fn.jobstart('docker exec subscription-service yarn run test -o --json --testLocationInResults > ' .. output_file, {
      on_exit = function(_, exit_code, _)
        if exit_code >= 0 then
          local file = io.open(output_file, 'r')
          if file then
            local content = file:read '*a'
            file:close()
            local output = vim.fn.json_decode(content)

            if not output.success then
              local failures = {}
              local namespace = vim.api.nvim_create_namespace 'test-failures'
              for _, v in ipairs(output.testResults) do
                if v.status ~= 'passed' then
                  local diags = {}
                  local filename = v.name:gsub('^/[^/]+/', '')
                  local bufnr = vim.fn.bufadd(filename)
                  vim.fn.bufload(bufnr)
                  for _, t in ipairs(v.assertionResults) do
                    if t.status ~= 'passed' then
                      local failedTest = {
                        bufnr = bufnr,
                        text = t.fullName,
                        type = 'E',
                      }
                      if t.location ~= vim.NIL then
                        failedTest.lnum = t.location.line
                        failedTest.col = t.location.column
                      else
                        local i, j = string.find(t.failureMessages[2], 'spec.ts:(%d+):')
                        if i then
                          failedTest.lnum = tonumber(string.sub(t.failureMessages[2], i + 8, j - 1))
                          failedTest.col = 0
                        end
                      end
                      local diag = {
                        bufnr = bufnr,
                        col = 0,
                        message = t.failureMessages[1],
                        lnum = failedTest.lnum - 1,
                        severity = vim.diagnostic.severity.ERROR,
                        user_data = {
                          message = t.failureMessages[1],
                        },
                        source = 'jest',
                      }
                      table.insert(diags, diag)
                      table.insert(failures, failedTest)
                    end
                  end
                  vim.diagnostic.set(namespace, bufnr, diags, {})
                end
              end
              vim.fn.setqflist({}, 'r', { title = 'Test Failures', items = failures })
              vim.cmd 'copen'
            end
            -- print(vim.inspect(output))
          end
        else
          print('failed ' .. exit_code)
        end
      end,
    })
  end),
}
