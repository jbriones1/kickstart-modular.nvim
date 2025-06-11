-- Displays jump keymaps when searching or using TreeSitter.

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    -- Allows me to jump through the entire buffer
    forward = false,
    modes = {
      char = {
        -- Removed "T"
        keys = { 'f', 'F', 't', ';', ',' },
      },
    },
    -- Excluded filetypes and custom window filters
    ---@type (string|fun(win:window))[]
    exclude = {
      'notify',
      'cmp_menu',
      'noice',
      'flash_prompt',
      'neo-tree filesystem',
      'NeogitStatus',
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>m", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<leader>,", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    -- Disables T to preserve tab shifting
  },
}
