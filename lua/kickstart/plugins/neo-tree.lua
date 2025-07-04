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
  lazy = false,
  keys = {
    { '\\', ':Neotree action=focus source=filesystem position=right toggle=true reveal=true<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      commands = {
        ng_open = function(state)
          local node = state.tree:get_node()
          if node == nil or node.type ~= 'file' then
            return
          end

          local file_type = string.match(node.name, 'component(.+)$')
          -- File doesn't match a controller, template or test file
          if file_type == nil then
            return
          end

          local orig_path = node.path
          local cmds = require 'neo-tree.sources.filesystem.commands'
          local template = '.html'
          local test = '.spec.ts'
          local controller = '.ts'
          local style = '.scss'
          -- If it's test, open in a new tab with three panes in the form `controller | test | template`
          if file_type == test then
            -- Open test
            cmds.open_tabnew(state)
            -- Open controller
            node.path = string.gsub(orig_path, test .. '$', controller)
            cmds.open_leftabove_vs(state)
            -- Open template
            node.path = string.gsub(node.path, controller .. '$', template)
            cmds.open_rightbelow_vs(state)
            return
          elseif file_type == template then
            node.path = string.gsub(orig_path, template .. '$', controller)
          elseif file_type == style then
            node.path = string.gsub(orig_path, style .. '$', controller)
          end

          -- Open in a new tab with panes `controller | template | css`
          cmds.open_tabnew(state)
          -- Open template
          node.path = string.gsub(orig_path, controller .. '$', template)
          cmds.open_vsplit(state)
          node.path = string.gsub(node.path, template .. '$', style)
          cmds.open_split(state)
        end,
      },
      window = {
        position = 'right',
        mappings = {
          ['s'] = 'open_split',
          ['v'] = 'open_vsplit',
          -- Angular mappings
          -- Open the controller and template in a vertical split (controller | template)
          ['<C-1>'] = 'ng_open',
        },
      },
    },
  },
}
