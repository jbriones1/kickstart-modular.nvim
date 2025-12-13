-- GitHub Copilot chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    -- build = 'make tiktoken',
    opts = {
      model = 'claude-opus-4.5',
      temperature = 0.1,
      window = {
        layout = 'vertical',
        width = 0.5,
      },
      auto_insert_mode = true,
      -- See Configuration section for options
      -- window = {
      --   layout = 'float',
      --   width = 80, -- Fixed width in columns
      --   height = 20, -- Fixed height in rows
      --   border = 'rounded', -- 'single', 'double', 'rounded', 'solid'
      --   title = '🤖 AI Assistant',
      --   zindex = 100, -- Ensure window stays on top
      -- },

      headers = {
        user = '👤 You',
        assistant = '🤖 Copilot',
        tool = '🔧 Tool',
      },

      separator = '━━',
      auto_fold = true, -- Automatically folds non-assistant messages
    },
  },
}
