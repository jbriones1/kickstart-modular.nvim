-- GitHub copilot
-- https://github.com/zbirenbaum/copilot.lua

return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp', -- for next editor suggestion functionality
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        layout = {
          position = 'right',
        },
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<A-a>',
        },
      },
      -- nes = {
      --   enabled = true,
      -- },
    }

    -- Get copilot suggestions
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
}
