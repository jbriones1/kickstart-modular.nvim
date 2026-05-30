return {
  {
    'olimorris/codecompanion.nvim',
    version = '^19.0.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      interactions = {
        chat = {
          adapter = 'copilot',
          model = 'gpt-5-codex',
        },
        inline = {
          adapter = 'copilot',
          model = 'gpt-5-codex',
        },
        cli = {
          agent = 'copilot',
          agents = {
            copilot = {
              cmd = 'copilot',
              args = {},
              description = 'Copilot CLI',
              provider = 'terminal',
            },
          },
        },
      },
      display = {
        chat = {
          window = {
            layout = 'vertical',
            width = 0.4,
          },
        },
      },
    },
    keys = {
      { '<leader>cc', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle AI [c]hat sidebar', mode = { 'n', 'v' } },
      { '<leader>cc', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle AI [c]hat sidebar', mode = { 'n', 'v' } },
      { '<leader>lp', '<cmd>CodeCompanionActions<CR>', desc = 'Open Code Companion command [p]alette', mode = { 'n', 'v' } },
      {
        '<leader>lc',
        function() return require('codecompanion').cli { prompt = true } end,
        desc = 'Open Code Companion agent CLI',
        mode = { 'n', 'v' },
      },
      {
        '<leader>la',
        function() return require('codecompanion').cli('#{this}', { focus = false }) end,
        desc = 'Add context to CLI agent',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ld',
        function() return require('codecompanion').cli('#{diagnostics} Fix these.', { focus = false, submit = true }) end,
        desc = 'Prompt the agent to fix the cause of the diagnostic messages',
        mode = { 'n', 'v' },
      },
      { 'ga', '<cmd>CodeCompanionChat Add<CR>', desc = 'Add selected area to AI chat sidebar', mode = { 'v' } },
    },
  },
}
