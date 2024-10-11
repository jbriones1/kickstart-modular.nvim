-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree action=focus source=filesystem position=right toggle=true reveal=true<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      commands = {},
      window = {
        mappings = {
          -- Angular mappings
          -- Open the controller and template in a vertical split (controller | template)
          ['<C-1>'] = function(state)
            local node = state.tree:get_node()
            if node == nil or node.type ~= 'file' then
              return
            end

            local name = node.name
            local path = state.tree:get_node().path
            -- If it's a template, change path to the controller
            if string.find(name, '.html$') ~= nil then
              state.tree:get_node().path = string.gsub(path, '.html$', '.ts')
            -- If it's not a controller, then just return
            elseif string.find(name, '.ts$') == nil then
              return
            end

            local cmds = require 'neo-tree.sources.filesystem.commands'
            cmds.open_tabnew(state)
            state.tree:get_node().path = string.gsub(path, '.ts$', '.html')
            cmds.open_vsplit(state)
          end,
        },
      },
    },
  },
}
