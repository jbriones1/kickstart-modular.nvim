-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Set semi-colon to act as colon
vim.keymap.set({ 'n', 'v' }, ';', ':')

-- Delete text with CTRL+BS
vim.keymap.set('i', '<C-BS>', '<C-w>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybinds for tab control
vim.keymap.set({ 'n', 'v' }, '<S-t>', ':tabp<CR>', { desc = 'Go to previous tab', silent = true })
vim.keymap.set({ 'n', 'v' }, '<S-Tab>', ':tabn<CR>', { desc = 'Go to next tab', silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-t>w', ':tabclose<CR>', { desc = 'Close current tab', silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-t>t', ':tabnew<CR>', { desc = 'Open a new tab', silent = true })

-- Press enter to make a new line in normal mode
vim.keymap.set('n', '<Enter>', 'o<Esc>', { desc = 'Make a new empty line', silent = true })

-- Move the current line down/up
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move current line down', silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move current line up', silent = true })
vim.keymap.set('i', '<A-j>', ' <Esc>:m .+1<CR>==gi', { desc = 'Move current line down', silent = true })
vim.keymap.set('i', '<A-k>', ' <Esc>:m .-2<CR>==gi', { desc = 'Move current line up', silent = true })

-- Move the current visual block down/up
vim.keymap.set('v', '<A-j>', ':m >+1<CR>gv=gv', { desc = 'Move current visual block down', silent = true })
vim.keymap.set('v', '<A-k>', ':m <-2<CR>gv=gv', { desc = 'Move current visual block up', silent = true })

-- Comment lines
vim.keymap.set('n', '<C-/>', 'gcc', { desc = 'Toggle line comment', remap = true, silent = true })
vim.keymap.set('v', '<C-/>', 'gc', { desc = 'Toggle visual block comment', remap = true, silent = true })
-- This is for Windows, as WezTerm consumes <C-/> as <C-_> there
vim.keymap.set('n', '<C-_>', 'gcc', { desc = 'Toggle line comment', remap = true, silent = true })
vim.keymap.set('v', '<C-_>', 'gc', { desc = 'Toggle visual block comment', remap = true, silent = true })

-- Custom tab configurations
local tab_split1 = function()
  vim.cmd [[ tabnew ]]
  vim.cmd [[ vsplit ]]
  vim.cmd [[ split ]]
end
vim.keymap.set({ 'n', 'v' }, '<C-t>1', tab_split1, { desc = 'Open a new tab with configured split 1', silent = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
