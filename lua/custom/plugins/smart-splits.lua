return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  config = function()
    -- Move between splits
    vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'Move focus to the left' })
    vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'Move focus to the right' })
    vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'Move focus up' })
    vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'Move focus down' })
    -- Swapping buffers between windows
    vim.keymap.set('n', '<leader>h', require('smart-splits').swap_buf_left, { desc = 'Swap with left panel' })
    vim.keymap.set('n', '<leader>j', require('smart-splits').swap_buf_down, { desc = 'Swap with below panel' })
    vim.keymap.set('n', '<leader>k', require('smart-splits').swap_buf_up, { desc = 'Swap with above panel' })
    vim.keymap.set('n', '<leader>l', require('smart-splits').swap_buf_right, { desc = 'Swap with right panel' })
  end,
}
