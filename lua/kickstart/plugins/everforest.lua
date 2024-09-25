return {
  {
    'sainnhe/everforest',
    priority = 1000,
    init = function()
      vim.g.everforest_background = 'hard'
      vim.g.everforest_better_performance = 1
      vim.o.background = 'dark'
      vim.cmd.colorscheme 'everforest'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
