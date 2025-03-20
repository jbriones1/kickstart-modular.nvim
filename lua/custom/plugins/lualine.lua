return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local filetype = {
        'filetype',
        icon_only = true,
      }

      local filename = {
        'filename',
        newfile_status = true,
        path = 1,
      }

      return {
        options = {
          icons_enabled = vim.g.have_nerd_font,
          theme = 'everforest',
          ignore_focus = { 'neo-tree', 'NeogitStatus' },
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_b = { 'branch' },
          lualine_c = { filename },
          lualine_x = { 'searchcount', 'encoding', 'fileformat' },
          lualine_y = { 'diff', 'diagnostics', 'lsp_status', filetype },
        },
      }
    end,
  },
}
