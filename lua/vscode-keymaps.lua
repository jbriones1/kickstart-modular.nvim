-- Mappings in VSCode NeoVim extension
vim.keymap.set('n', '<leader>sf', '<cmd>lua require("vscode").action("workbench.action.quickOpen")<CR>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ds', '<cmd>lua require("vscode").action("workbench.action.gotoSymbol")<CR>', { desc = '[D]ocument [S]ymbols' })

-- Code Tools
vim.keymap.set('n', '<leader>ca', '<cmd>lua require("vscode").action("editor.action.quickFix")<CR>', { desc = '[C]ode [A]ctions' })
vim.keymap.set('n', '<leader>f', '<cmd>lua require("vscode").action("editor.action.formatDocument")<CR>', { desc = '[F]ormat Code' })

-- Source Control
vim.keymap.set('n', '<leader>gs', '<cmd>lua require("vscode").action("workbench.view.scm")<CR>', { desc = '[G]it [S]tatus' })
