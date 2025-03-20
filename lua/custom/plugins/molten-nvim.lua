-- Molten-nvim is for running Jupyter notebooks
-- https://github.com/benlubas/molten-nvim
-- No image.nvim configured, so images can't be displayed

return {
  'benlubas/molten-nvim',
  version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
  build = ':UpdateRemotePlugins',
  config = function()
    vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>', { desc = 'Initialize Molten', silent = true })
    vim.keymap.set('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { desc = '(Molten) Evaluate', silent = true })
    vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { desc = '(Molten) [R]e[r]run cell', silent = true })
    vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { desc = '(Molten) [O]utput show', silent = true })
    vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { desc = '(Molten) [O]utput hide', silent = true })
    vim.keymap.set('n', '<localleader>rv', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = '(Molten) [R]un [v]isual', silent = true })
    vim.keymap.set('n', '<localleader>rl', ':MoltenEvaluateLine<CR>', { desc = '(Molten) [R]un [l]ine', silent = true })

    -- Disables outputs automatically showing when hovering over a cell
    vim.g.molten_auto_open_output = false

    -- Outputs come out as virtual text
    vim.g.molten_virt_text_output = true

    -- Displays output below the cell delimiter
    vim.g.molten_virt_lines_off_by_1 = true
  end,
}
