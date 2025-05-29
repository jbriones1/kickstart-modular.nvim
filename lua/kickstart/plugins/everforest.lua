return {
  -- Vim everforest
  -- {
  --   'sainnhe/everforest',
  --   priority = 1000,
  --   init = function()
  --     vim.g.everforest_background = 'hard'
  --     vim.g.everforest_better_performance = 1
  --     vim.o.background = 'dark'
  --     vim.cmd.colorscheme 'everforest'
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
  {
    'neanias/everforest-nvim',
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require('everforest').setup {
        -- Your config here
        background = 'hard',
        disable_italic_comments = true,
        diagnostic_line_highlight = true,
        diagnostic_virtual_text = 'grey',
      }
      require('everforest').load()
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
