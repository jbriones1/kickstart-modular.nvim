-- Neogen plugin
-- Automatically creates documentation for functions, classes, etc.
return {
  'danymat/neogen',
  keys = {
    { '<leader>gd', ':lua require("neogen").generate()<CR>', desc = '[G]enerate [d]ocumentation', silent = true },
  },
  config = true,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
}
