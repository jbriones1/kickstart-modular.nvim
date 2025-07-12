-- For previewing markdown and Latex
return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  -- For nvim treesitter
  priority = 49,

  -- For blink.cmp's completion
  -- source
  dependencies = {
    'saghen/blink.cmp',
  },
}
