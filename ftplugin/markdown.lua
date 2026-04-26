if vim.g.vscode then
  -- Don't load quarto plugin in vscode, as it causes issues with the markdown preview extension
  return
end
require('quarto').activate()
