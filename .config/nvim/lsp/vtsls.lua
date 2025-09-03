local function has_eslint_config(root_dir)
  local eslint_files = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.json',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'eslint.config.cjs',
    'eslint.config.mjs',
    'eslint.config.ts',
  }

  for _, f in ipairs(eslint_files) do
    if vim.fn.filereadable(root_dir .. '/' .. f) == 1 then
      return true
    end
  end
  return false
end
return {
  cmd = { 'vtsls', '--stdio' },
  root_markers = { 'package.json', '.git' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  on_attach = function(client, bufnr)
    if has_eslint_config(client.config.root_dir) then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
}
