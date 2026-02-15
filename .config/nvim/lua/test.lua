local ns = vim.api.nvim_create_namespace 'live-tests'
local group = vim.api.nvim_create_augroup('jojo-automagic', { clear = true })
local test_running = false

-- Parse cargo test JSON output
-- Each line is a separate JSON object
local function parse_test_output(output)
  local passed = {}
  local failed = {}

  for line in output:gmatch '[^\r\n]+' do
    local ok, decoded = pcall(vim.json.decode, line)
    if ok and decoded.type == 'test' then
      if decoded.event == 'ok' then
        table.insert(passed, {
          name = decoded.name,
          exec_time = decoded.exec_time,
        })
      elseif decoded.event == 'failed' then
        table.insert(failed, {
          name = decoded.name,
          stdout = decoded.stdout or '',
        })
      end
    end
  end

  return { passed = passed, failed = failed }
end

-- Create diagnostics from test results
-- Returns both diagnostics and quickfix items
local function create_diagnostics(test_results, bufnr)
  local diags = {}
  local failures = {}

  -- Get buffer content to search for test locations
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Helper to find test function line number
  local function find_test_line(test_name)
    -- Extract just the function name from full test path
    -- e.g., "module::submodule::test_foo" -> "test_foo"
    local fn_name = test_name:match '([^:]+)$'

    for i, line in ipairs(lines) do
      -- Look for #[test] followed by fn test_name or just fn test_name
      if line:match('fn%s+' .. fn_name .. '%s*%(') then
        return i - 1 -- 0-indexed
      end
    end
    return 0 -- Default to top of file if not found
  end

  -- Add diagnostics for passed tests
  for _, test in ipairs(test_results.passed) do
    local lnum = find_test_line(test.name)
    table.insert(diags, {
      bufnr = bufnr,
      lnum = lnum,
      col = 0,
      message = string.format('✓ %s (%.3fs)', test.name, test.exec_time or 0),
      severity = vim.diagnostic.severity.INFO,
      source = 'cargo-test',
    })
  end

  -- Add diagnostics for failed tests
  for _, test in ipairs(test_results.failed) do
    local lnum = find_test_line(test.name)
    local message = string.format('✗\n%s', test.stdout)

    table.insert(diags, {
      bufnr = bufnr,
      lnum = lnum,
      col = 0,
      message = message,
      severity = vim.diagnostic.severity.ERROR,
      source = 'cargo-test',
    })

    -- -- Add to quickfix
    -- table.insert(failures, {
    --   bufnr = bufnr,
    --   lnum = lnum + 1, -- quickfix is 1-indexed
    --   col = 0,
    --   text = test.name,
    --   type = 'E',
    -- })
  end

  return { diags = diags, failures = failures }
end

-- Run cargo test and update diagnostics
local function run_tests(bufnr)
  -- Prevent multiple concurrent runs
  if test_running then
    return
  end
  test_running = true

  -- Clear existing diagnostics
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local cmd = { 'cargo', '+nightly', 'test', '--', '-Z', 'unstable-options', '--format', 'json' }

  vim.system(cmd, { text = true, env = { RUST_BACKTRACE = '1' } }, function(result)
    vim.schedule(function()
      test_running = false

      -- Exit codes: 0 = all passed, 101 = some tests failed
      if result.code == 0 or result.code == 101 then
        local test_results = parse_test_output(result.stdout)
        local diag_data = create_diagnostics(test_results, bufnr)

        -- Set diagnostics
        vim.diagnostic.set(ns, bufnr, diag_data.diags, {})

        -- Populate quickfix with failures
        if #diag_data.failures > 0 then
          vim.fn.setqflist({}, 'r', { title = 'Rust Test Failures', items = diag_data.failures })
          vim.cmd 'copen'
        else
          -- Close quickfix if all tests passed
          vim.cmd 'cclose'
        end

        -- Show summary notification
        local total = #test_results.passed + #test_results.failed
        local summary = string.format('Tests: %d passed, %d failed', #test_results.passed, #test_results.failed)
        local level = #test_results.failed > 0 and vim.log.levels.WARN or vim.log.levels.INFO
        vim.notify(summary, level)
      else
        -- Cargo failed to run
        vim.notify('Cargo test failed to run:\n' .. (result.stderr or ''), vim.log.levels.ERROR)
      end
    end)
  end)
end

-- Auto-run tests on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.rs',
  group = group,
  callback = function(args)
    run_tests(args.buf)
  end,
})
