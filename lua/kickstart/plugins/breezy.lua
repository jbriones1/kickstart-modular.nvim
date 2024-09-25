return {
  {
    'fneu/breezy',
    priority = 1000,
    init = function()
      vim.o.termguicolors = true
      -- vim.o.background = 'light'
      -- vim.cmd.colorscheme 'breezy'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
